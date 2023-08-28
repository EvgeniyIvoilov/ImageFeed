import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imageListPresenter = ImagesListPresenter(imagesListService: ImagesListService.shared)
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        imagesListViewController.presenter = imageListPresenter
        imageListPresenter.view = imagesListViewController
        let presenter = ProfileViewPresenter(profileService: ProfileService.shared,
                                             profileImageService: ProfileImageService.shared,
                                             authStorage: OAuth2TokenStorage())
        let profileViewController = ProfileViewController(presenter: presenter)
        presenter.view = profileViewController
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        imagesListViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_editorial_active"),
            selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
