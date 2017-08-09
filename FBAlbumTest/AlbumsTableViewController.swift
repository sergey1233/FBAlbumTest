import UIKit
import Alamofire
import AlamofireImage

class AlbumsTableViewController: UITableViewController {

    var albums: [FBAlbum] = []
    var albumData: [String:UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        if cell?.picture.image == nil {
            getCoverAlbumPhoto(cell: cell, album: album)
        }
        cell?.title.text = album.name

        return cell!
    }
    
    func getCoverAlbumPhoto(cell: AlbumCell?, album: FBAlbum) {
        let size = CGSize(width: 60.0, height: 60.0)
        
        let url = album.coverPhoto.urlString
        if !url.isEmpty {
            Alamofire.request(url).responseImage { response in
                if let imageResponse = response.result.value {
                    cell?.picture.image = imageResponse.af_imageAspectScaled(toFill: size)
                    cell?.setNeedsLayout()
                }
            }
        }
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
