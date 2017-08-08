import UIKit

class Picture: NSObject {
    var id = ""
    var urlString = ""
    
    override init() {
        super.init()
    }
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    init(id: String, urlString: String) {
        self.id = id
        self.urlString = urlString
    }
}
