import Foundation

struct CheckFoodAPIRequest {
    static func postImage(with imageData: Data) async throws -> String {
        let boundary = APIRequestHelper.boundary
//        let headers = APIRequestHelper.makeHeaders(with: boundary)
        var body = [String: String]()
        body["image"] = imageData.base64EncodedString()

        guard let url = URL(string: "https://72ea-211-168-232-124.ngrok-free.app/") else {
            throw NSError(domain: "error", code: -1, userInfo: nil)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
//        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = APIRequestHelper.makeBody(with: [:], imageData: imageData, boundary: boundary)
        print("urlRequest: \(urlRequest)")
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        print("data: \(data), \(String(decoding: data, as: UTF8.self))")
        let response = try JSONDecoder().decode(String.self, from: data)
        print("response: \(response)")
        return response
    }

    static func postText(with text: String) async throws -> String {
        let boundary = APIRequestHelper.boundary
        let headers = APIRequestHelper.makeHeaders(with: boundary)
        var body = [String: String]()
        body["image"] = text

        guard let url = URL(string: "https://api.example.com") else {
            throw NSError(domain: "error", code: -1, userInfo: nil)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = APIRequestHelper.makeBody(with: body, boundary: boundary)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let response = try JSONDecoder().decode(String.self, from: data)
        return response
    }
}

