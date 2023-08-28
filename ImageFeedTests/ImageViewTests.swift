@testable import ImageFeed
import XCTest

final class ImageViewListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var photos: [ImageFeed.Photo] = []
    var viewDidLoadCall: Bool = false
    var nextPageCall: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCall = true
    }
    
    func nextPage() {
        nextPageCall = true
    }
    
    func likePhoto(for index: Int, complition: @escaping (Result<Bool, Error>) -> ()) {
        
    }
}

final class ImageListViewControllerSpy: ImagesListViewControllerProtocol {
    
    func updateTableViewAnimated(range: Range<Int>) {
        
    }
}

final class ImageViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImageViewListPresenterSpy()
          viewController.presenter = presenter
          presenter.view = viewController
        
        //when
        viewController.viewDidLoad()
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCall)
    }
}
