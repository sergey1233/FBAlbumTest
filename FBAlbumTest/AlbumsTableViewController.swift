import UIKit
import Alamofire
import AlamofireImage

class AlbumsTableViewController: UITableViewController {

    let albums = GlobalVariables.sharedInstance.albums
    var albumData: [String:UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for album in albums {
            var coverPhoto: UIImage = UIImage()
            let size = CGSize(width: 60.0, height: 60.0)
            
            Alamofire.request(album.coverPhoto.urlString).responseImage { response in
                if let imageResponse = response.result.value {
                    coverPhoto = imageResponse.af_imageAspectScaled(toFill: size)
                    self.albumData[album.id] = coverPhoto
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
        return albums.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell") as! AlbumCell!
        let album = albums[(indexPath as NSIndexPath).row]
        
        cell?.picture.image = albumData[album.id]
        cell?.title.text = album.name

        return cell!
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showPhotos") {
            let photosTableViewController = segue.destination as! PhotosTableViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                photosTableViewController.photos = albums[(indexPath as NSIndexPath).row].photos
            }
        }
    }

}
