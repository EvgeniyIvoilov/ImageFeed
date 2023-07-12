import Foundation

final class ImagesListService {
    
    static let shared = ImagesListService()
    static let DidChangeNotification = Notification.Name(rawValue:"ImagesListServiceDidChange")
    
    private var lastLoadedPage: Int?
    private (set) var photos: [Photo] = []
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private let token = OAuth2TokenStorage().token
    private lazy var decoder = JSONDecoder()

    func fetchPhotosNextPage(_ token: String) {
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        if task != nil { return }
        var request = URLRequest.makeHTTPRequest(path: "/photos" + "/?page=\(nextPage)", httpMethod: "GET")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        task = urlSession.dataTask(with: request, completionHandler: { data, response, error in
            guard let data = data else { return }
            do {
                let photosResult = try self.decoder.decode([PhotosResult].self, from: data)
                let newPhotos: [Photo] = photosResult.map { Photo(from: $0)}
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: newPhotos)
                    self.notification()
                    self.lastLoadedPage = nextPage
                }
            } catch {
                print(error)
            }
            self.task = nil
        })
        task?.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ token: String, _ completion: @escaping (Result<Void, Error>) -> Void) {
         
        if task != nil { return }
        let request = makeLikeRequest(photoId: photoId, isLike: isLike, token)
         let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
             guard let self = self else { return }
             guard data != nil else { return }
             
             if let error = error {
                 DispatchQueue.main.async {
                     completion(.failure(error))
                 }
             } else {
                 if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                     let photo = self.photos[index]
                     var newPhoto = photo
                     newPhoto.isLiked.toggle()
                     self.photos[index] = newPhoto
                     DispatchQueue.main.async {
                         completion(.success(()))
                     }
                 }
             }
             self.task = nil
         }
         self.task = task
         task.resume()
     }
    
    private func makeLikeRequest(photoId: String, isLike: Bool, _ token: String) -> URLRequest {
        let httpMethod = isLike ? "POST" : "DELETE"
        var request =  URLRequest.makeHTTPRequest(
                path: "/photos/\(photoId)/like",
                httpMethod: httpMethod,
                baseURL: DefaultBaseURL
            )
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func notification() {
        NotificationCenter.default.post(
            name: ImagesListService.DidChangeNotification,
            object: self,
            userInfo: ["Photos": self.photos])
    }
    
    func clean() {
        photos = []
        lastLoadedPage = nil
        task?.cancel()
        task = nil
    }
}
