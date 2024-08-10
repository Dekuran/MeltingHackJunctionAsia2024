import Foundation
import UIKit

struct CheckFoodAPIRequest {
    static func postImage(with imageData: Data) async throws -> String {
        guard let image = UIImage(data: imageData) else {
            throw NSError(domain: "Invalid Image Data", code: -1, userInfo: nil)
        }
        
        // 1% compressed jpeg image
        guard let compressedImageData = image.jpegData(compressionQuality: 0.01) else {
            throw NSError(domain: "Compression Error", code: -1, userInfo: nil)
        }
        
        // Encode compressed image into base64
        let base64Image = compressedImageData.base64EncodedString()
        
        // Check Server URL
        guard let url = URL(string: "https://0787-211-168-232-124.ngrok-free.app/") else {
            throw NSError(domain: "Invalid URL", code: -1, userInfo: nil)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        // Content-Type header
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Make POST request body
        let bodyString = "data=\(base64Image)"
        urlRequest.httpBody = bodyString.data(using: .utf8)
        
        // Print for debugging base64
        print("Request Body: \(bodyString)")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        // Print response
        if let httpResponse = response as? HTTPURLResponse {
            print("Response Status Code: \(httpResponse.statusCode)")
            // print("Response Headers: \(httpResponse.allHeaderFields)")
        }
        
        // Print response data
        let responseDataString = String(data: data, encoding: .utf8) ?? "No response data"
        // print("Response Data: \(responseDataString)")
        
        // JSON Decoding
        let finalResponse = try JSONDecoder().decode(String.self, from: data)
        return finalResponse
    }
    
    
    static func postText(with text: String) async throws -> String {
        let boundary = APIRequestHelper.boundary
        let headers = APIRequestHelper.makeHeaders(with: boundary)
        
        print("Boundary: \(boundary)")
        print("Headers: \(headers)")
        
        var body = [String: String]()
        body["text"] = text
        
        guard let url = URL(string: "https://api.example.com") else {
            throw NSError(domain: "error", code: -1, userInfo: nil)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = headers
        
        let httpBody = APIRequestHelper.makeBody(with: body, boundary: boundary)
        urlRequest.httpBody = httpBody
        
        if let bodyString = String(data: httpBody.prefix(1000), encoding: .utf8) {
            print("HTTP Body (Partial): \(bodyString)")
        }
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("Response Status Code: \(httpResponse.statusCode)")
            print("Response Headers: \(httpResponse.allHeaderFields)")
        }
        
        let responseDataString = String(data: data, encoding: .utf8) ?? "No response data"
        print("Response Data: \(responseDataString)")
        
        let fianlResponse = try JSONDecoder().decode(String.self, from: data)
        return fianlResponse
    }
}
