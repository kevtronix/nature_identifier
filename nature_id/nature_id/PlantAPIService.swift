import Foundation
import UIKit

class PlantAPIService {
    static let shared = PlantAPIService()

    func uploadImage(image: UIImage, urlString: String, completion: @escaping (PlantIdentificationResponse?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }

        let base64String = imageData.base64EncodedString(options: .lineLength64Characters)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("KEY_VALUE", forHTTPHeaderField: "Api-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let json: [String: Any] = ["images": [base64String], "similar_images": true]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: json, options: [])
        } catch {
            print("Failed to serialize JSON body: ", error)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error during URLSession data task:", error ?? "Unknown error")
                completion(nil)
                return
            }
            if let jsonString = String(data: data, encoding: .utf8) {
                let jsonData = Data(jsonString.utf8)
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(PlantIdentificationResponse.self, from: data)
                    completion(response)
                } catch {
                    print("Error decoding response: \(error)")
                    completion(nil)
                }
            } else {
                print("Failed to decode binary data to String")
            }
        }.resume()
    }
}
