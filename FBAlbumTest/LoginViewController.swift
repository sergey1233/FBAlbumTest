import UIKit
import FBSDKLoginKit
import FacebookLogin
import FacebookCore
import SwiftyJSON

class LoginViewController: UIViewController {
    
    @IBOutlet weak var fbLoginButton: UIButton!
    
    var dict : [String : AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fbLoginButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
    }
    
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                self.getFBUserData()
            }
        }
    }
    
    func getFBUserData() {
        if((FBSDKAccessToken.current()) != nil) {
            FBSDKGraphRequest(graphPath: "me/albums", parameters: ["fields":"id, name, cover_photo{picture}, photos{images}"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil) {
                    let albumJsonResult = JSON(result!)
                    let albumDataResult = albumJsonResult["data"]
                    
                    for i in 0..<albumDataResult.count {
                        //Get data for FBAlbum
                        let albumId = albumDataResult[i]["id"].rawString()
                        let albumName = albumDataResult[i]["name"].rawString()
                        let albumCoverPhoto = albumDataResult[i]["cover_photo"]["picture"].rawString()
                        let photosArray: [Picture] = self.getPhotosArray(photoArrayJson: albumDataResult[i]["photos"]["data"])
                        
                        let album = FBAlbum(id: albumId!, name: albumName!, coverPhoto: Picture(urlString: albumCoverPhoto!), photos: photosArray)
                        GlobalVariables.sharedInstance.albums.append(album)
                        
                    }
                    self.performSegue(withIdentifier: "showAlbums", sender: self)
                }
            })
        }
    }
    
    func getPhotosArray(photoArrayJson: JSON) -> [Picture] {
        var arr: [Picture] = []
        for i in 0..<photoArrayJson.count {
            //get the most big photo
            let images = photoArrayJson[i]["images"]
            var height = 0
            var source = ""
            for i in 0..<images.count {
                let imageHeight: Int = images[i]["height"].rawValue as! Int
                if imageHeight > height {
                    height = Int(imageHeight)
                    source = images[i]["source"].rawString()!
                }
            }
            arr.append(Picture(id: photoArrayJson[i]["id"].rawString()!, urlString: source))
        }
        return arr
    }
}
