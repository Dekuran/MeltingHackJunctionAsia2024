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
            Task {
                let requestKey = try? await CheckFoodAPIRequest.postImage(with: pngData) ?? ""
                screenType = .result
            }        }
    }
    
    var cameraView: some View {
        ZStack {
            CapturePreview(captureCameraViewModel: viewModel)
                .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth)
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
                    Text("Camera")
                        .font(.system(size: 32, weight: .bold))
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
                    Text("Text")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.init(uiColor: .button))
                }
            }
        }
        .frame(width: .infinity, height: 56.0)
    }
}
