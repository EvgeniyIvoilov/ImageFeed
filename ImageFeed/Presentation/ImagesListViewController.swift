import UIKit

class ImagesListViewController: UIViewController {
    // Dependensies
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    
    // Models
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    // UI
    @IBOutlet private var tableView: UITableView!
    
    // MARK: LifeCicly
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func configCell(for cell: ImagesListCell, indexPath: IndexPath) {
        let imageName = photosName[indexPath.row]
        guard let image = UIImage(named: imageName) else {
            return
        }
        cell.mainImageView.image = image
        let dateText = dateFormatter.string(from: Date())
        cell.dateLabel.text = dateText
        if indexPath.row % 2 != 0 {
            let activeLike = UIImage(named: "Active")
            cell.likeButton.setImage(activeLike, for: .normal)
        } else {
            let noActiveLike = UIImage(named: "No Active")
            cell.likeButton.setImage(noActiveLike, for: .normal)
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowSingleImage", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageName = photosName[indexPath.row]
        guard let image = UIImage(named: imageName) else {
            return UITableView.automaticDimension
        }
        let heightImage = image.size.height + 8
        let widthImage = image.size.width
        let aspectRatioImage = heightImage / widthImage
        let widthTable = tableView.contentSize.width
        let widthCell = widthTable - 32
        let height = widthCell * aspectRatioImage
        return height
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
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
