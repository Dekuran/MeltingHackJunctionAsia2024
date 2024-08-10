import SwiftUI

struct CapturePreview: UIViewRepresentable {
    private var captureCameraViewModel: CaptureCameraViewModel
    
    init(captureCameraViewModel: CaptureCameraViewModel) {
        self.captureCameraViewModel = captureCameraViewModel
    }
    
    public func makeUIView(context: Context) -> some UIView {
        
        let cameraView = captureCameraViewModel.previewView
        cameraView.frame = .init(x: 0, y: 0, width: UIScreen.screenWidth, height: UIScreen.screenWidth)
        captureCameraViewModel.launchCamera()
        
        return cameraView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
