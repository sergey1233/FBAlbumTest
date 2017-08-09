import UIKit

class FBAlbum: NSObject {
    var id: String = ""
    var name: String = ""
    var coverPhoto = Picture()
    var photos = [Picture()]
    
    override init() {
        super.init()
    }
    
    init(id: String?, name: String?, coverPhoto: Picture = Picture(), photos: [Picture] = []) {
        self.id = id ?? ""
        self.name = name ?? "empty"
        self.coverPhoto = coverPhoto
        self.photos = photos
    }
}
