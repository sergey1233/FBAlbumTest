import UIKit

class CurrentPhotoViewController: UIViewController {

    @IBOutlet weak var photo: UIImageView!
    var picture: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photo.image = picture
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false;
    }
    
    @IBAction func closePhoto(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
