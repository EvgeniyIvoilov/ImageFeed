import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    weak var delegate: ImagesListCellDelegate?
    let gradient = CAGradientLayer()
    static let reuseIdentifier = "ImagesListCell"
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    private var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var dateLabel = UILabel()
    
    private lazy var likeButton: UIButton = {
        let image: UIImage = UIImage(named: "No Active") ?? UIImage()
        let button: UIButton = UIButton()
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private var gradientView = UIView()

        
    // здесь создается экземпляр ячейки из кода
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    // здесь создается экземпляр ячейки из сториборда
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    // метод загружает аутлеты
    override func awakeFromNib() {
        super.awakeFromNib()
        addViews()
        constraintView()
        likeButton.accessibilityLabel = "like button"
    }
    
    private func setupView(_ subView: UIView) {
        contentView.addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addViews() {
        photoImageView.kf.indicatorType = .activity
        photoImageView.layer.cornerRadius = 16
        photoImageView.layer.masksToBounds = true
        
        dateLabel.font = UIFont(name: "SFProText-Regular", size: 13)
        dateLabel.textColor = UIColor(.ypWhite)
        
        setupView(photoImageView)
        setupView(likeButton)
        setupView(dateLabel)
        setupView(gradientView)
        gradientSetup()
        imageView?.contentMode = .scaleAspectFill
    }
    
    private func constraintView() {
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            photoImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            likeButton.topAnchor.constraint(equalTo: photoImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor),
            
            dateLabel.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -8),
            dateLabel.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor, constant: 8),
            
            gradientView.heightAnchor.constraint(equalToConstant: 30),
            gradientView.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor),
            gradientView.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor)
        ])
    }
    
    // метод определения размеров относительно экрана (не в сториборде)
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = gradientView.bounds
        gradient.cornerRadius = 16
        gradient.masksToBounds = true
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.kf.cancelDownloadTask()
    }
    
    func configure(with model: Photo, imageLoaded: @escaping () -> Void) {
        photoImageView.kf.setImage(with: URL(string: model.thumbImageURL),
                               placeholder: UIImage(named: "Stub"),
                               options: []) { [weak self] _ in
            imageLoaded()
            self?.layoutIfNeeded()
        }
        guard let date = model.createdAt else { return }
        let dateText = ImagesListCell.dateFormatter.string(from: date)
        dateLabel.text = dateText
    }
    
    func setIsLiked(_ isLiked: Bool) {
        if isLiked {
            likeButton.setImage(UIImage(named: "Active"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "No Active"), for: .normal)
        }
    }
    
    func gradientSetup() {
        let colorTop = UIColor(cgColor: .init(red: 26, green: 27, blue: 34, alpha: 0)).cgColor
        let colorBottom = UIColor(cgColor: .init(red: 26, green: 27, blue: 34, alpha: 0.2)).cgColor
        gradient.colors = [colorTop, colorBottom]
        gradient.locations = [0, 1]
        gradientView.layer.addSublayer(gradient)
    }
    
    @objc private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
}
