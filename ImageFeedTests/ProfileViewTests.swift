@testable import ImageFeed
import XCTest

final class ProfileViewPresenterSpy: ProfilePresenterProtocol {
    
    var view: ProfileViewControllerProtocol?
    var profileImageURL: URL?
    var profile: Profile?
    var viewDidLoadCall: Bool = false

    func cleanServicesData() {
    }

    func viewDidLoad() {
        viewDidLoadCall = true
    }
    
    func logout() {
    }
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {

    var presenter: ImageFeed.ProfilePresenterProtocol?
    var profile: Profile?
    var updateViewCall = false
    var updateAvatarCall = false
    
    func updateView(_ profile: ImageFeed.Profile) {
        updateViewCall = true
    }
    
    func updateAvatar(with url: URL) {
        updateAvatarCall = true
    }
}

final class ProfileServiceSpy: ProfileServiceProtocol {
    var profileStub: ImageFeed.Profile?
    var profile: ImageFeed.Profile? {
        return profileStub
    }

    func fetchProfile(_ token: String, completion: @escaping (Result<ImageFeed.Profile, Error>) -> Void) {
        
    }

    func clean() {
    }
}

final class AuthStorageSpy: OAuth2TokenStorageProtocol {
    var token: String?
    
    func removeToken() {
        
    }
    
    func clearToken() {
        
    }
    
}

final class ProfileImageServiceSpy: ProfileImageServiceProtocol {
    var avatarURLStub: ImageFeed.AvatarUrl?
    var avatarURL: ImageFeed.AvatarUrl? {
        return avatarURLStub
    }
    
    func fetchProfileImageUrl(_ token: String, userName: String, completion: @escaping (Result<ImageFeed.AvatarUrl, Error>) -> Void) {
        
    }
    
    func clean() {
        
    }
    
    
}

final class ProfileViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
            // given
            var presenter = ProfileViewPresenterSpy()
            let viewController = ProfileViewController(presenter: presenter)
            presenter.view = viewController
            
            // when
            viewController.viewDidLoad()
            
            // then
            XCTAssertTrue(presenter.viewDidLoadCall)
        }
    
    func testPresenter_whenViewDidLoad() {
        // given
        let viewController = ProfileViewControllerSpy()
        let profileService = ProfileServiceSpy()
        let profileImageService = ProfileImageServiceSpy()
        let authStorage = AuthStorageSpy()
        let presenter = ProfileViewPresenter(profileService: profileService,
                                             profileImageService: profileImageService,
                                             authStorage: authStorage)
        
        viewController.presenter = presenter
        presenter.view = viewController
        profileService.profileStub = .init(userName: "userName", name: "name", bio: "bio")
        profileImageService.avatarURLStub = .init(imageUrlSmall: "imageUrlSmall",
                                                  imageUrlMedium: "imageUrlMedium",
                                                  imageUrlLarge: "imageUrlLarge")
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(viewController.updateViewCall)
        XCTAssertTrue(viewController.updateAvatarCall)
    }
}
