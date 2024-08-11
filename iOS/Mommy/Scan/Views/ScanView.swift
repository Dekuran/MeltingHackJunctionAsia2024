import SwiftUI
import Lottie

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
            Color(uiColor: .preimary).ignoresSafeArea()
            switch screenType {
                case .camera:
                    cameraView
                    
                case .text:
                    textView
                    
                case .requesting:
                    requestingView
                    
                case .result:
                    IngredientResultView(viewModel: IngredientRiskViewModel(ingredientRisks: ingredientRisks), captureCameraViewModel: viewModel)
            }
            
            navigationBar
        }
        .onChange(of: viewModel.imageData) { imageData in
            guard let pngData = imageData?.pngData() else {
                return
            }
            screenType = .requesting // 먼저 requesting 상태로 전환
            
            Task {
                do {
                    let responseString = try await CheckFoodAPIRequest.postImage(with: pngData)
                    
                    // responseDataString을 JSON 데이터로 변환
                    if let data = responseString.data(using: .utf8) {
                        do {
                            let risks = try JSONDecoder().decode([IngredientRisk].self, from: data)
                            ingredientRisks = risks
                            print("Successfully parsed \(ingredientRisks.count) risks.")
                        } catch {
                            print("Error decoding JSON: \(error)")
                            screenType = .camera 
                        }
                    } else {
                        print("Error: Could not convert responseString to Data.")
                        screenType = .camera
                    }
                    
                    if !ingredientRisks.isEmpty {
                        screenType = .result
                    } else {
                        print("Received empty response. Remaining in requesting state.")
                        screenType = .camera
                    }
                } catch {
                    print("Error: \(error)")
                    screenType = .camera
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
                TextView(didSentText: { searchText in
                    screenType = .requesting // 먼저 requesting 상태로 전환
                    
                    Task {
                        do {
                            let responseString = try await CheckFoodAPIRequest.postText(with: searchText)
                            
                            // JSON 데이터로 파싱하여 ingredientRisks 배열에 저장
                            if let data = responseString.data(using: .utf8) {
                                let risks = try JSONDecoder().decode([IngredientRisk].self, from: data)
                                ingredientRisks = risks
                            } else {
                                print("Error: Could not convert responseString to Data.")
                            }
                            
                            if !ingredientRisks.isEmpty {
                                screenType = .result
                            } else {
                                print("Received empty response. Remaining in requesting state.")
                            }
                        } catch {
                            print("Error: \(error)")
                        }
                    }
                })
                toggleButton
            }
        }
    }
    
    var requestingView: some View {
        ZStack {
            Color(uiColor: .preimary)
            
            LottieView(animation: .named("Loading"))
                .playing(loopMode: .loop)
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
