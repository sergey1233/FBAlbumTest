import UIKit

class GlobalVariables: NSObject {
    
    static let sharedInstance = GlobalVariables()
    var albums: [FBAlbum] = []
    
    override fileprivate init() {}
}
