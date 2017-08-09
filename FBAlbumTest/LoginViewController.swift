import UIKit
import FBSDKLoginKit
import FacebookLogin
import FacebookCore


class LoginViewController: UIViewController {
    
    @IBOutlet weak var fbLoginButton: UIButton!    
    var albums: [FBAlbum] = []
    
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
                    if let res = result {
                        let parseData = ParseData()
                        self.albums = parseData.parseAlbumsData(res: res)
                        self.performSegue(withIdentifier: "showAlbums", sender: self)
                    }
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showAlbums") {
            let destinationNavigationController = segue.destination as! UINavigationController
            let targetAlbumsTableViewController = destinationNavigationController.topViewController as! AlbumsTableViewController
            targetAlbumsTableViewController.albums = self.albums
        }
    }
}
