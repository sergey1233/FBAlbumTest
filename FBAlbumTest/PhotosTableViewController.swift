import UIKit
import Alamofire
import AlamofireImage

class PhotosTableViewController: UITableViewController {

    var photos: [Picture] = []
    var photoData: [String:UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Photos"
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
        
        getPhoto(cell: cell, photo: photo)
        
        return cell
    }
    
    func getPhoto(cell: UITableViewCell, photo: Picture) {
        let size = CGSize(width: 60.0, height: 60.0)
        
        let id = photo.id
        if !id.isEmpty {
            if !photoData.keys.contains(id) {
                let url = photo.urlString
                if !url.isEmpty {
                    Alamofire.request(url).responseImage { response in
                        if let imageResponse = response.result.value {
                            self.photoData[id] = imageResponse
                            cell.imageView?.image = imageResponse.af_imageAspectScaled(toFill: size)
                            cell.setNeedsLayout()
                        }
                    }
                }
            }
            else {
                cell.imageView?.image = self.photoData[id]?.af_imageAspectScaled(toFill: size)
                cell.setNeedsLayout()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showBigPhoto") {
            let currentPhotoViewController = segue.destination as! CurrentPhotoViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                let id = photos[(indexPath as NSIndexPath).row].id
                if !id.isEmpty {
                    currentPhotoViewController.picture = photoData[id] ?? UIImage()
                }
            }
        }
    }
}
