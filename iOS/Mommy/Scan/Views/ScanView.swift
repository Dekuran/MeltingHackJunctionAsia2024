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
                IngredientResultView()
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
}
