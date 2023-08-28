import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let fullImageURL: String
    var isLiked: Bool
    
    
    init(from result: PhotosResult) {
        self.id = result.id
        self.size = CGSize(width: result.width, height: result.height)
        self.createdAt = Photo.dateFormatt.date(from: result.createdAt ?? "")
        self.welcomeDescription = result.description
        self.thumbImageURL = result.urls.thumb
        self.fullImageURL = result.urls.full
        self.isLiked = result.likedByUser
    }
    
    static var dateFormatt: DateFormatter = {
        let dateFormatt = DateFormatter()
        dateFormatt.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatt
    }()
}

    
