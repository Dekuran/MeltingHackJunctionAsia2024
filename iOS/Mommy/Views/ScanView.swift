import SwiftUI

protocol ScanViewDelegate {
    func passImage(image: UIImage)
}

struct ScanView: View {
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject private(set) var viewModel = CaptureCameraViewModel()
    
    var delegate: ScanViewDelegate?
    
    var body: some View {
        ZStack {
            CapturePreview(captureCameraViewModel: viewModel)
                .frame(width: 320, height: 320)
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
                    .frame(width: 320, height: 320)
            }
        }
        .onChange(of: viewModel.imageData) { imageData in
            guard let imageData = imageData else {
                return
            }
            delegate?.passImage(image: imageData)
//            presentation.wrappedValue.dismiss()
        }
    }
}

struct CapturePreview: UIViewRepresentable {
    private var captureCameraViewModel: CaptureCameraViewModel
    
    init(captureCameraViewModel: CaptureCameraViewModel) {
        self.captureCameraViewModel = captureCameraViewModel
    }
    
    public func makeUIView(context: Context) -> some UIView {
        
        let cameraView = captureCameraViewModel.previewView
        cameraView.frame = .init(x: 0, y: 0, width: 320, height: 320)//UIScreen.main.bounds
        captureCameraViewModel.launchCamera()
        
        return cameraView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
