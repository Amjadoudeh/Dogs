import Foundation
import UIKit

class DogApi {
    enum Endpoint: String {
        case randomImageFromAllDogs = "https://dog.ceo/api/breeds/image/random"
        var url: URL {
            return URL(string: self.rawValue)!
        }
    }

    class func requestRandomImage(completionHandler: @escaping (DogImage?, Error?) -> Void) {
        
        let randomImageEndpoint = DogApi.Endpoint.randomImageFromAllDogs.url
        let task = URLSession.shared.dataTask(with: randomImageEndpoint) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            print(data)

            let decoder = JSONDecoder()
            let imageData = try! decoder.decode(DogImage.self, from: data)
            print(imageData)
            completionHandler(imageData, nil)
        }
        task.resume()
    }
    
    class func requestImageFile(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            print(data)
            let downloadedImage = UIImage(data: data)
            completionHandler(downloadedImage,nil)
        })
        task.resume()
    }
}
