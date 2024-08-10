import SwiftUI
import Combine
import OpenAISwift

final class HomeViewModel: ObservableObject {
    @Published var isPresented = false
    @Published var encouragementMessage: String = ""
    @Published var isLoading: Bool = false // 로딩 상태를 관리하는 변수
    
    @AppStorage("userName") private var userName = ""
    @AppStorage("currentStage") private var currentStage: String?
    @AppStorage("weekOfPregnancy") private var weekOfPregnancy = ""
    @AppStorage("dueDate") private var dueDateString = ""
    @AppStorage("allergies") private var allergies = ""
    
    private var openAI: OpenAISwift?

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    var dueDate: Date? {
        return dateFormatter.date(from: dueDateString)
    }
    
    var currentDate: Date {
        return Date()
    }
    
    var userGreeting: String {
        return "Hello, \(userName)!"
    }
    
    var weeksSinceStart: (weeks: Int, days: Int) {
        guard let dueDate = dueDate else { return (0, 0) }
        let startDate = Calendar.current.date(byAdding: .day, value: -268, to: dueDate) ?? Date()
        let components = Calendar.current.dateComponents([.weekOfYear, .day], from: startDate, to: currentDate)
        return (weeks: components.weekOfYear ?? 0, days: components.day ?? 0)
    }
    
    var weeksUntilDue: (weeks: Int, days: Int) {
        guard let dueDate = dueDate else { return (0, 0) }
        let components = Calendar.current.dateComponents([.weekOfYear, .day], from: currentDate, to: dueDate)
        return (weeks: components.weekOfYear ?? 0, days: components.day ?? 0)
    }
    
    
    private let apiKey = "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"
    
    func fetchEncouragementMessage() {
        isLoading = true
        let pregnancyStage = calculatePregnancyStage()
        let prompt = "Give me two sentences of encouragement and advice for a pregnant woman who is \(pregnancyStage) months pregnant. The sentences must include the pregnacy month and must be fitted and personalized. The whole sentences must be maximum 20 words."
        
        // Define the request body for chat model
        let requestBody: [String: Any] = [
            "model": "gpt-4o",
            "messages": [
                ["role": "system", "content": "You are a helpful assistant."],
                ["role": "user", "content": prompt]
            ],
            "max_tokens": 100
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody, options: []) else {
            print("Failed to convert request body to JSON")
            return
        }
        
        guard let apiURL = URL(string: "https://api.openai.com/v1/chat/completions") else {
            print("Invalid API URL")
            return
        }
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self?.encouragementMessage = "Failed to fetch message: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    self?.encouragementMessage = "Failed to fetch message: No data received"
                    return
                }
                
                if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Full JSON Response: \(jsonResponse)")
                    
                    if let choices = jsonResponse["choices"] as? [[String: Any]],
                       let message = choices.first?["message"] as? [String: Any],
                       let content = message["content"] as? String {
                        print("API Response: \(content.trimmingCharacters(in: .whitespacesAndNewlines))")
                        self?.encouragementMessage = content.trimmingCharacters(in: .whitespacesAndNewlines)
                    } else {
                        print("Unexpected response format")
                        self?.encouragementMessage = "Failed to fetch message: Unexpected response format"
                    }
                } else {
                    print("Failed to parse response")
                    self?.encouragementMessage = "Failed to fetch message: Failed to parse response"
                }
            }
        }
        
        task.resume()
    }
    
    private func calculatePregnancyStage() -> Int {
        guard let dueDate = dateFormatter.date(from: dueDateString) else { return 0 }
        let startDate = Calendar.current.date(byAdding: .day, value: -268, to: dueDate) ?? Date()
        let components = Calendar.current.dateComponents([.month], from: startDate, to: Date())
        return components.month ?? 0
    }
}
