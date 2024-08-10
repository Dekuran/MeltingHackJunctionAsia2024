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
    
    @ObservedObject private(set) var viewModel = CaptureCameraViewModel()
    @State private var screenType: ScreenType = .camera

    var body: some View {
        Group {
            switch screenType {
            case .camera:
                cameraView
                
            case .text:
                textView
                
            case .requesting:
                requestingView
                
            case .result:
                IngredientResultView()
            }
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
            VStack {
                Spacer()
                Button {
                    viewModel.capture()
                } label: {
                    Image(systemName: "circle.inset.filled")
                        .resizable(resizingMode: .stretch)
                        .foregroundColor(.white)
                }
                .frame(width: 60, height: 60)
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
            Color.red
        }
    }

    var requestingView: some View {
        ZStack {
            Color.blue
        }
    }
}
