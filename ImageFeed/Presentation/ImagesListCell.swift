import UIKit

final class ImagesListCell: UITableViewCell {
    
    let gradient = CAGradientLayer()
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var gradientView: UIView!
    
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
        gradientSetup()
        
    }
    // метод определения размеров относительно экрана (не в сториборде)
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = gradientView.bounds
        gradient.cornerRadius = 16
        gradient.masksToBounds = true
    }
    
    func gradientSetup() {
        let colorTop = UIColor(cgColor: .init(red: 26, green: 27, blue: 34, alpha: 0)).cgColor
        let colorBottom = UIColor(cgColor: .init(red: 26, green: 27, blue: 34, alpha: 0.2)).cgColor
        gradient.colors = [colorTop, colorBottom]
        gradient.locations = [0, 1]
        gradientView.layer.addSublayer(gradient)
    }
}
