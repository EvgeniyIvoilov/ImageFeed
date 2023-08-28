import UIKit
import WebKit

protocol ProfilePresenterProtocol: AnyObject {
    var profileImageURL: URL? { get }
    var profile: Profile? { get }
    
    func viewDidLoad()
    func cleanServicesData()
    func logout()
}

final class ProfileViewPresenter: ProfilePresenterProtocol {
   
    weak var view: ProfileViewControllerProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileImageService: ProfileImageServiceProtocol
    private let profileService: ProfileServiceProtocol
    private let authService = OAuth2Service()
    private let authStorage: OAuth2TokenStorageProtocol
    
    var profileImageURL: URL? {
        guard
            let profileImageURL = profileImageService.avatarURL?.imageUrlSmall
        else { return nil }
        let url = URL(string: profileImageURL)
        return url
    }
    
    var profile: Profile? {
        profileService.profile
    }
    
    init(profileService: ProfileServiceProtocol,
         profileImageService: ProfileImageServiceProtocol,
         authStorage: OAuth2TokenStorageProtocol) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.authStorage = authStorage
    }
    
    func viewDidLoad() {
        guard let profile = profileService.profile else { return }
        view?.updateView(profile)
        
        guard let url = profileImageURL else { return }
        view?.updateAvatar(with: url)
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard
                    let self = self,
                    let url = self.profileImageURL
                else { return }
                self.view?.updateAvatar(with: url)
            }
    }
    
    func cleanServicesData() {
        profileImageService.clean()
        profileService.clean()
        profileImageService.clean()
    }
    
    func logout() {
        authStorage.clearToken()
        WebViewViewController.clean()
        cleanServicesData()
    }
}
