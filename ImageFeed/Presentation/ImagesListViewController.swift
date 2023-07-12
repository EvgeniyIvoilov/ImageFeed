import UIKit

final class ImagesListViewController: UIViewController {
    // Dependensies
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let imagesListService = ImagesListService()
    private let token = OAuth2TokenStorage().token
    private var photos: [Photo] = []
    private var imagesListServiceObserver: NSObjectProtocol?
    
    // UI
    @IBOutlet private var tableView: UITableView!
    
    // MARK: LifeCicly
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesListServiceObserver = NotificationCenter.default.addObserver(
                    forName: ImagesListService.DidChangeNotification,
                    object: nil,
                    queue: .main) { [weak self] _ in
                        guard let self = self else { return }
                        self.updateTableViewAnimated()
                    }
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        guard let token = token else { return }
        imagesListService.fetchPhotosNextPage(token)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let photo = photos[indexPath.row]
                        guard let imageURL = URL(string: photo.fullImageURL) else { return }
                        viewController.imageURL = imageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func configCell(for cell: ImagesListCell, indexPath: IndexPath) {
        let photoModel = photos[indexPath.row]
        cell.configure(with: photoModel, imageLoaded: { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        })
        cell.delegate = self
    }
    
    @objc func updateTableViewAnimated() {
        let newPhotos = imagesListService.photos
        let oldCount = photos.count
        let newCount = newPhotos.count
        
        photos = newPhotos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .bottom)
            } completion: { _ in }
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowSingleImage", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photoModel = photos[indexPath.row]
        
        let heightImage = photoModel.size.height + 8
        let widthImage = photoModel.size.width
        let aspectRatioImage = heightImage / widthImage
        let widthTable = tableView.contentSize.width
        let widthCell = widthTable - 32
        let height = widthCell * aspectRatioImage
        return height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage(token!)
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, indexPath: indexPath)
        return imageListCell
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
     
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked, token ?? "") { result in
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}
