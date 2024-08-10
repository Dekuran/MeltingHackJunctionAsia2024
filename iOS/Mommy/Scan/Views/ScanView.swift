import SwiftUI

protocol ScanViewDelegate {
    func passImage(image: UIImage)
}

enum ScreenType {
    case camera
    case text
    case requesting
    case result
}

struct ScanView: View {
    @Environment(\.presentationMode) var presentation
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject private(set) var viewModel = CaptureCameraViewModel()
    @State private var screenType: ScreenType = .camera
    @State private var ingredientRisks: [IngredientRisk] = []
    
    var body: some View {
        ZStack {
            switch screenType {
                case .camera:
                    cameraView
                    
                case .text:
                    textView
                    
                case .requesting:
                    requestingView
                    
                case .result:
                    IngredientResultView(captureCameraViewModel: viewModel)
            }
            
            navigationBar
        }
        .background(Color(uiColor: .preimary))
        .onChange(of: viewModel.imageData) { imageData in
            guard let pngData = imageData?.pngData() else {
                return
            }
            screenType = .requesting // 먼저 requesting 상태로 전환
            
            Task {
                do {
                    let responseString = try await CheckFoodAPIRequest.postImage(with: pngData)
                    
                    // JSON 문자열을 개별 라인으로 나누고 각 라인을 디코딩
                    let responseLines = responseString.components(separatedBy: "\n")
                    var risks: [IngredientRisk] = []
                    
                    for line in responseLines {
                        if let data = line.data(using: .utf8), !data.isEmpty {
                            let risk = try JSONDecoder().decode(IngredientRisk.self, from: data)
                            risks.append(risk)
                        }
                    }
                    
                    ingredientRisks = risks
                    
                    if !ingredientRisks.isEmpty {
                        screenType = .result
                    } else {
                        print("Received empty response. Remaining in requesting state.")
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    var cameraView: some View {
        ZStack {
            CapturePreview(captureCameraViewModel: viewModel)
                .frame(width: UIScreen.screenWidth - 32, height: UIScreen.screenWidth - 32)
            VStack(spacing: 16.0) {
                Spacer()
                captureButton
                toggleButton
            }
            
            if let uiimage = viewModel.imageData {
                Image(uiImage: uiimage)
                    .resizable()
                    .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth)
            }
        }
    }
    
    var textView: some View {
        ZStack {
            Color(uiColor: .preimary)
            VStack {
                Spacer()
                toggleButton
            }
        }
    }
    
    var requestingView: some View {
        ZStack {
            Color(uiColor: .preimary)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .foregroundColor(.white)
        }
    }
    
    var navigationBar: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .resizable(resizingMode: .stretch)
                        .frame(width: 24, height: 24)
                        .accentColor(.init(uiColor: .button))
                }
                .frame(width: 44, height: 44)
            }
            .padding(.top, 8)
            Spacer()
        }
    }
    
    var captureButton: some View {
        Button {
            viewModel.capture()
        } label: {
            Image(systemName: "circle.inset.filled")
                .resizable(resizingMode: .stretch)
                .foregroundColor(.white)
        }
        .frame(width: 60, height: 60)
    }
    
    var toggleButton: some View {
        HStack {
            Button {
                screenType = .camera
            } label: {
                ZStack {
                    Color(uiColor: .preimary)
                    if screenType == .camera {
                        RoundedRectangle(cornerRadius: 16.0)
                            .foregroundColor(.init(uiColor: .secondary))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                    }
                    Text("Camera")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.init(uiColor: .button))
                }
            }
            RoundedRectangle(cornerRadius: 1)
                .foregroundColor(.init(uiColor: .button))
                .frame(width: 2.0, height: 56.0)
            Button {
                screenType = .text
            } label: {
                ZStack {
                    Color(uiColor: .preimary)
                    if screenType == .text {
                        RoundedRectangle(cornerRadius: 16.0)
                            .foregroundColor(.init(uiColor: .secondary))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                    }
                    Text("Text")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.init(uiColor: .button))
                }
            }
        }
        .frame(width: .infinity, height: 56.0)
    }
}
