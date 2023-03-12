import UIKit

final class ProfileViewController: UIViewController {
    
    private let userPick = UIImageView()
    private let userNameLabel = UILabel()
    private let userLoginLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let logOutButton = UIButton.systemButton(with: UIImage(named: "Logout")!, target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        constraintView()
    }
    
    private func setupView(_ subView: UIView) {
        view.addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addViews() {
        let imageAvatar = UIImage(named: "Avatar")
        userPick.image = imageAvatar
        
        userNameLabel.text = "Екатерина Новикова"
        userNameLabel.font = UIFont(name: "SFProText-Bold", size: 23)
        userNameLabel.textColor = UIColor(.ypWhite)
        
        userLoginLabel.text = "@ekaterina_nov"
        userLoginLabel.font = UIFont(name: "SFProText-Regular", size: 13)
        userLoginLabel.textColor = UIColor(.ypGray)
        
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.font = UIFont(name: "SFProText-Regular", size: 13)
        descriptionLabel.textColor = UIColor(.ypWhite)
        
        logOutButton.tintColor = UIColor(.ypRed)
        
        setupView(userPick)
        setupView(userNameLabel)
        setupView(userLoginLabel)
        setupView(descriptionLabel)
        setupView(logOutButton)
    }
    
    private func constraintView() {
        NSLayoutConstraint.activate([
            userPick.widthAnchor.constraint(equalToConstant: 70),
            userPick.heightAnchor.constraint(equalToConstant: 70),
            userPick.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userPick.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            
            userNameLabel.topAnchor.constraint(equalTo: userPick.bottomAnchor, constant: 8),
            userNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            userLoginLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            userLoginLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            descriptionLabel.topAnchor.constraint(equalTo: userLoginLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            logOutButton.widthAnchor.constraint(equalToConstant: 20),
            logOutButton.heightAnchor.constraint(equalToConstant: 22),
            logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            logOutButton.centerYAnchor.constraint(equalTo: userPick.centerYAnchor)])
    }
}
