import UIKit
import SwiftyJSON

class ParseData: NSObject {
    var albums: [FBAlbum] = []
    
    func parseAlbumsData(res: Any) -> [FBAlbum]  {
        let albumJsonResult = JSON(res)
        let albumDataResult = albumJsonResult["data"]
        for i in 0..<albumDataResult.count {
            //Get data for FBAlbum
            let albumId = albumDataResult[i]["id"].rawString()
            let albumName = albumDataResult[i]["name"].rawString()
            let albumCoverPhotoUrl = albumDataResult[i]["cover_photo"]["picture"].rawString()
            let photosArray: [Picture] = self.getPhotosArray(photoArrayJson: albumDataResult[i]["photos"]["data"])
            
            let album = FBAlbum(id: albumId, name: albumName, coverPhoto: Picture(urlString: albumCoverPhotoUrl), photos: photosArray)
            self.albums.append(album)
        }
        return self.albums
    }
    
    func getPhotosArray(photoArrayJson: JSON) -> [Picture] {
        var arr: [Picture] = []
        for i in 0..<photoArrayJson.count {
            //get the most big photo
            let images = photoArrayJson[i]["images"]
            var height = 0
            var source: String? = ""
            for i in 0..<images.count {
                if let imageHeight: Int = images[i]["height"].rawValue as? Int {
                    if imageHeight > height {
                        height = Int(imageHeight)
                        source = images[i]["source"].rawString()
                    }
                }
            }
            arr.append(Picture(id: photoArrayJson[i]["id"].rawString(), urlString: source))
        }
        return arr
    }
}
