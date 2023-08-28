import UIKit

protocol ImagesListViewControllerProtocol: AnyObject {
    func updateTableViewAnimated(range: Range<Int>)
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    // Dependensies
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    var presenter: ImagesListPresenterProtocol?
    
    // UI
    @IBOutlet private var tableView: UITableView!
    
    // MARK: LifeCicly
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        tableView?.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let photo = presenter?.photos[indexPath.row]
            guard
                let photo = presenter?.photos[indexPath.row],
                let imageURL = URL(string: photo.fullImageURL)
            else { return }
            viewController.imageURL = imageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func configCell(for cell: ImagesListCell, indexPath: IndexPath) {
        guard let photoModel = presenter?.photos[indexPath.row] else { return }
        cell.configure(with: photoModel, imageLoaded: { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        })
        cell.delegate = self
    }
    
    func updateTableViewAnimated(range: Range<Int>) {
        
        tableView.performBatchUpdates {
            let indexPaths = range.map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .bottom)
        } completion: { _ in }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowSingleImage", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photoModel = presenter?.photos[indexPath.row] else { return 0 }
        
        let heightImage = photoModel.size.height + 8
        let widthImage = photoModel.size.width
        let aspectRatioImage = heightImage / widthImage
        let widthTable = tableView.contentSize.width
        let widthCell = widthTable - 32
        let height = widthCell * aspectRatioImage
        return height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == presenter?.photos.count {
            presenter?.nextPage()
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photos.count ?? 0
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
        UIBlockingProgressHUD.show()
        presenter?.likePhoto(for: indexPath.row) { result in
            switch result {
            case .success(let isLike):
                cell.setIsLiked(isLike)
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}
