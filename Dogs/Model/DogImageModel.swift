import Foundation

struct DogImage: Codable {
    let status: String
    let message: String
}

struct BreedsListResponse: Codable {
    let message: [String: [String]]?
        let status: String?
}
