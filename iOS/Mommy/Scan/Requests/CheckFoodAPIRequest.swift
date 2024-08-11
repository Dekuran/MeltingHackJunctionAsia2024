import Foundation
import UIKit

struct CheckFoodAPIRequest {
    static func postImage(with imageData: Data) async throws -> String {
        // 이미지 데이터를 UIImage로 변환하고 압축
        guard let image = UIImage(data: imageData) else {
            throw NSError(domain: "Invalid Image Data", code: -1, userInfo: nil)
        }
        
        // 이미지를 1% 압축률로 JPEG 형식으로 변환
        guard let compressedImageData = image.jpegData(compressionQuality: 0.01) else {
            throw NSError(domain: "Compression Error", code: -1, userInfo: nil)
        }
        
        // 압축된 이미지를 Base64 인코딩
        let base64Image = compressedImageData.base64EncodedString()
        
        // 서버 URL 확인
        guard let url = URL(string: "https://4470-211-168-232-124.ngrok-free.app/") else {
            throw NSError(domain: "Invalid URL", code: -1, userInfo: nil)
        }
        
        // URLRequest 설정
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        // Content-Type 헤더 설정
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // 요청 Body 생성
        let bodyString = "data=THIS_IS_AN_IMAGE_FILE\(base64Image)"
        urlRequest.httpBody = bodyString.data(using: .utf8)
        
        // 서버로부터의 응답 처리
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        // HTTP 응답 코드 출력
        if let httpResponse = response as? HTTPURLResponse {
            print("Response Status Code: \(httpResponse.statusCode)")
        }
        
        // 응답 데이터를 String으로 변환
        let responseDataString = String(data: data, encoding: .utf8) ?? "No response data"
        print("Response Data: \(responseDataString)")
        
        // String 형식으로 응답 반환
        return responseDataString
    }

    static func postText(with text: String) async throws -> String {
        // 이미지 데이터를 UIImage로 변환하고 압축
//        guard let image = UIImage(data: imageData) else {
//            throw NSError(domain: "Invalid Image Data", code: -1, userInfo: nil)
//        }
//        
        // 이미지를 1% 압축률로 JPEG 형식으로 변환
//        guard let compressedImageData = image.jpegData(compressionQuality: 0.01) else {
//            throw NSError(domain: "Compression Error", code: -1, userInfo: nil)
//        }
        
        // 압축된 이미지를 Base64 인코딩
//        let base64Image = compressedImageData.base64EncodedString()
        
        // 서버 URL 확인
        guard let url = URL(string: "https://4470-211-168-232-124.ngrok-free.app/") else {
            throw NSError(domain: "Invalid URL", code: -1, userInfo: nil)
        }
        
        // URLRequest 설정
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        // Content-Type 헤더 설정
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // 요청 Body 생성
        let bodyString = "data=THIS_IS_A_TEXT_FILE\(text)"
        urlRequest.httpBody = bodyString.data(using: .utf8)
        
        // 서버로부터의 응답 처리
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        // HTTP 응답 코드 출력
        if let httpResponse = response as? HTTPURLResponse {
            print("Response Status Code: \(httpResponse.statusCode)")
        }
        
        // 응답 데이터를 String으로 변환
        let responseDataString = String(data: data, encoding: .utf8) ?? "No response data"
        print("Response Data: \(responseDataString)")
        
        // String 형식으로 응답 반환
        return responseDataString
    }
}
