import Foundation
import UIKit

class DogApi {
    
    enum Endpoint {
        case randomImageFromAllDogs
        case randomImageForBreed (String)
        case listAllBreeds
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case .randomImageFromAllDogs:
                return "https://dog.ceo/api/breeds/image/random"
            case .randomImageForBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
            case .listAllBreeds:
                return "https://dog.ceo/api/breeds/list/all"
            }
        }
    }

    class func requestRandomImage(breed: String ,completionHandler: @escaping (DogImage?, Error?) -> Void) {
        
        let randomImageEndpoint = DogApi.Endpoint.randomImageForBreed(breed).url
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
    // list of breeds
    class func requestListOfImage(completionHandler: @escaping ([String], Error?) -> Void) {
        
        let randomImageEndpoint = DogApi.Endpoint.listAllBreeds.url
        let task = URLSession.shared.dataTask(with: randomImageEndpoint) { (data, response, error) in
            guard let data = data else {
                completionHandler([], error)
                return
            }
            print(data)

            let decoder = JSONDecoder()
            let breedsResponse = try! decoder.decode(BreedsListResponse.self, from: data)
            let breeds = breedsResponse.message.keys.map({$0})
            print(breeds)
            completionHandler(breeds, nil)
        }
        task.resume()
    }
    // show the image
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
