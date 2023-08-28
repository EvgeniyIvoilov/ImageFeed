import Foundation

protocol ProfileImageServiceProtocol {
    var avatarURL: AvatarUrl? { get }
    func fetchProfileImageUrl(_ token: String,userName: String, completion: @escaping (Result<AvatarUrl, Error>) -> Void)
    func clean()
}

final class ProfileImageService: ProfileImageServiceProtocol {
    
    private (set) var avatarURL: AvatarUrl?
    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private let urlSession = URLSession.shared
    private let decoder = JSONDecoder()
    private var task: URLSessionTask?
    
    func fetchProfileImageUrl(_ token: String,userName: String, completion: @escaping (Result<AvatarUrl, Error>) -> Void) {
        guard let url = URL(string: "https://api.unsplash.com/users/\(userName)") else
        { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = urlSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                }
                guard let data = data else { return }
                do {
                    let userResult = try self.decoder.decode(UserResult.self, from: data)
                    let avatarUrl: AvatarUrl = .from(userResult)
                    self.avatarURL = avatarUrl
                    completion(.success(avatarUrl))
                    NotificationCenter.default
                        .post(
                            name: ProfileImageService.DidChangeNotification,
                            object: self,
                            userInfo: ["URL": self.avatarURL])
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func clean() {
        avatarURL = nil
        task?.cancel()
        task = nil
    }
}

struct AvatarUrl {
    let imageUrlSmall: String?
    let imageUrlMedium: String?
    let imageUrlLarge: String?
}

extension AvatarUrl {
    static func from(_ userResult: UserResult) -> AvatarUrl {
        AvatarUrl(imageUrlSmall: userResult.image?.small, imageUrlMedium: userResult.image?.medium, imageUrlLarge: userResult.image?.large)
    }
}

struct UserResult: Codable {
    let image: ProfileImage?
    enum CodingKeys: String, CodingKey {
        case image = "profile_image"
    }
}

struct ProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?
}


