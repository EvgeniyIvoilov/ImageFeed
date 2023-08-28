import Foundation

protocol ImagesListPresenterProtocol: AnyObject {
    var photos: [Photo] { get }
    func viewDidLoad()
    func nextPage()
    func likePhoto(for index: Int, complition: @escaping (Result<Bool,Error>) -> ())
}

class ImagesListPresenter: ImagesListPresenterProtocol {
    // Dependensies
    weak var view: ImagesListViewControllerProtocol?
    private let imagesListService: ImagesListServiceProtocol
    private var imagesListServiceObserver: NSObjectProtocol?
    private let token = OAuth2TokenStorage().token
    
    // Models
    private(set) var photos: [Photo] = []
    
    init(imagesListService: ImagesListServiceProtocol) {
        self.imagesListService = imagesListService
    }
    
    func viewDidLoad() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
                    forName: ImagesListService.DidChangeNotification,
                    object: nil,
                    queue: .main) { [weak self] _ in
                        guard let self = self else { return }
                        self.updateTableView()
                    }
        nextPage()
    }
    
    func nextPage() {
        guard let token = token else { return }
        imagesListService.fetchPhotosNextPage(token)
    }
    
    func likePhoto(for index: Int, complition: @escaping (Result<Bool,Error>) -> ()) {
     
        let photo = photos[index]
        
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked, token ?? "") { [weak self] result in
            guard let self = self else { return }
            switch result {

            case .success:
                self.photos = self.imagesListService.photos
                
                complition(.success(self.photos[index].isLiked))
                
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
    
    private func updateTableView() {
        let newPhotos = imagesListService.photos
        let oldCount = photos.count
        let newCount = newPhotos.count
        
        photos = newPhotos
        if oldCount != newCount {
            view?.updateTableViewAnimated(range: (oldCount..<newCount))
        }
    }
}
