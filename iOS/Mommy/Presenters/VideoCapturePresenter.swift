import Foundation
import QuartzCore

final class VideoCapturePresenter: ObservableObject {

    var previewLayer: CALayer {
        return interactor.previewLayer!
    }

    enum Inputs {
        case onAppear
        case tappedCameraButton
        case onDisappear
    }

    init() {
        interactor.setupAVCaptureSession()
    }

    func apply(inputs: Inputs) {
        switch inputs {
            case .onAppear:
                interactor.startSettion()
            break
            case .tappedCameraButton:
            break
            case .onDisappear:
              interactor.stopSettion()
        }
    }

    func capture() {
        interactor.capture()
    }

    // MARK: Privates
    private let interactor = VideoCaptureInteractor()
}
