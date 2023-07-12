import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let userPick = UIImageView()
    private let userNameLabel = UILabel()
    private let userLoginLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let logOutButton: UIButton = {
        let image: UIImage = UIImage(named: "Logout") ?? UIImage()
        let button: UIButton = .systemButton(with: image,
                                             target: self,
                                             action: #selector(Self.didTapLogoutButton))
        return button
    }()
    private let authStorage = OAuth2TokenStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        constraintView()
        guard let profile = profileService.profile else { return }
        updateView(profile)
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL.imageUrlSmall!)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        userPick.kf.indicatorType = .activity
        userPick.kf.setImage(with: url,
                              placeholder: UIImage(named: "person.crop"),
                              options: [.processor(processor)])
    }
    
    private func updateView(_ profile: Profile) {
        userNameLabel.text = profile.name
        userLoginLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    private func setupView(_ subView: UIView) {
        view.addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addViews() {
        let imageAvatar = UIImage(named: "person.crop")
        userPick.image = imageAvatar
        userPick.layer.cornerRadius = 35
        userPick.layer.masksToBounds = true
        
        userNameLabel.font = UIFont(name: "SFProText-Bold", size: 23)
        userNameLabel.textColor = UIColor(.ypWhite)
        
        userLoginLabel.font = UIFont(name: "SFProText-Regular", size: 13)
        userLoginLabel.textColor = UIColor(.ypGray)
        
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
    
    @objc
    private func didTapLogoutButton() {
        showLogoutAlert()
    }
    
    private func logout() {
        authStorage.clearToken()
        WebViewViewController.clean()
        cleanServicesData()
        tabBarController?.dismiss(animated: true)
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration") }
        window.rootViewController = SplashViewController()
    }
    
    private func showLogoutAlert() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] action in
            guard let self = self else { return }
            self.logout()
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func cleanServicesData() {
        ImagesListService.shared.clean()
        ProfileService.shared.clean()
        ProfileImageService.shared.clean()
    }
}
