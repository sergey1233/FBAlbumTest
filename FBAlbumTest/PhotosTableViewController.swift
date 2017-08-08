import UIKit
import Alamofire
import AlamofireImage

class PhotosTableViewController: UITableViewController {

    var photos: [Picture] = []
    var photoData: [String:UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Photos"
        
        for photo in photos {
            Alamofire.request(photo.urlString).responseImage { response in
                if let imageResponse = response.result.value {
                    self.photoData[photo.id] = imageResponse
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath)
        let photo = photos[(indexPath as NSIndexPath).row]
        
        let size = CGSize(width: 60.0, height: 60.0)
        cell.imageView?.image = photoData[photo.id]?.af_imageAspectScaled(toFill: size)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showBigPhoto") {
            let currentPhotoViewController = segue.destination as! CurrentPhotoViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                currentPhotoViewController.picture = photoData[photos[(indexPath as NSIndexPath).row].id]!
            }
        }
    }
}
