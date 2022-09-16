import UIKit

class ViewController: UIViewController {
 
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var randomImage: UIImageView!
    
    var breeds: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        DogApi.requestListOfImage(completionHandler: handleListofBreeds(breeds:error:))
    }  
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        DogApi.requestRandomImage(breed: breeds[row] ,completionHandler: handleRandomImageResponse(imageData:error:))
    }
    func handleListofBreeds(breeds: [String], error: Error?) {
        // update the breeds list here
        self.breeds = breeds
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
        }
    }
    
    func handleRandomImageResponse(imageData: DogImage?, error: Error?) {
        guard let imageURL = URL(string: imageData?.message ?? "" ) else { return }
        DogApi.requestImageFile(url: imageURL, completionHandler: self.handleImageFileResponse(image:error:))
    }
    
    func handleImageFileResponse(image: UIImage?, error: Error?) {
        DispatchQueue.main.async {
            self.randomImage.image = image
        }
    }
}
