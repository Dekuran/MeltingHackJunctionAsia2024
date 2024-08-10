import Foundation

struct Constant {
    static let apiKey = ""
}

struct APIRequestHelper {
    static let boundary = UUID().uuidString
    static func makeHeaders(with boundary: String) -> [String: String] {
        [
            "accept": "application/json; type=image/png",
            "authorization": "Bearer \(Constant.apiKey)",
            "content-type": "multipart/form-data; boundary=\"\(boundary)\""
        ]
    }

    static func makeBody(
        with bodyDics: [String: String],
        imageData: Data? = nil,
        boundary: String
    ) -> Data {
        var postData = Data()
        if let imageData {
            postData.append("--\(boundary)\r\n".data(using: .utf8)!)
            postData.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.png\"\r\n".data(using: .utf8)!)
            postData.append("Content-Type: image/png\r\n".data(using: .utf8)!)
            postData.append("\r\n".data(using: .utf8)!)
            postData.append(imageData)
            postData.append("\r\n".data(using: .utf8)!)
        }

        for (key, value) in bodyDics {
            postData.append("--\(boundary)\r\n".data(using: .utf8)!)
            postData.append("Content-Disposition: form-data; name=\"\(key)\"\"\r\n".data(using: .utf8)!)
            postData.append("\r\n".data(using: .utf8)!)
            postData.append(value.data(using: .utf8)!)
            postData.append("\r\n".data(using: .utf8)!)
        }
        postData.append("--\(boundary)--".data(using: .utf8)!)
        return postData
    }
}
