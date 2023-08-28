import Foundation

protocol ProfileServiceProtocol {
    var profile: Profile? { get }
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void)
    func clean()
}

final class ProfileService: ProfileServiceProtocol {
    
    static let shared = ProfileService()
    private(set) var profile: Profile?
    
    private let urlSession = URLSession.shared
    private let decoder = JSONDecoder()
    private var task: URLSessionTask?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        guard let url = URL(string: "https://api.unsplash.com/me") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        task?.cancel()
        let task = urlSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                }
                guard let data = data else { return }
                do {
                    let profileResult = try self.decoder.decode(ProfileResult.self, from: data)
                    self.profile = Profile.from(profileResult)
                    completion(.success(.from(profileResult)))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    func clean() {
        profile = nil
        task?.cancel()
        task = nil
    }
}

struct ProfileResult: Codable {
    let userName: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

struct Profile {
    
    let userName: String
    let name: String
    let bio: String
    var loginName: String {
        "@" + userName
    }
}

extension Profile {
    static func from(_ profileResult: ProfileResult) -> Profile {
        let name = (profileResult.firstName ?? "")  + " " + (profileResult.lastName ?? "")
        return Profile(userName: profileResult.userName,
                       name: name,
                       bio: profileResult.bio ?? "Not found")
    }
}
