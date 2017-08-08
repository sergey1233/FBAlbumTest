import UIKit

class FBAlbum: NSObject {
    var id = ""
    var name = ""
    var coverPhoto = Picture()
    var photos = [Picture()]
    
    override init() {
        super.init()
    }
    
    init(id: String, name: String, coverPhoto: Picture, photos: [Picture]) {
        self.id = id
        self.name = name
        self.coverPhoto = coverPhoto
        self.photos = photos
    }
}
