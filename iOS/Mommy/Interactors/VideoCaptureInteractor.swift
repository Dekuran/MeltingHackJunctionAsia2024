import Foundation
import AVKit

final class VideoCaptureInteractor: NSObject, ObservableObject {
    private let captureSession = AVCaptureSession()
    @Published var previewLayer: AVCaptureVideoPreviewLayer?
    private var captureDevice: AVCaptureDevice?
    private var photoOutput : AVCapturePhotoOutput?
    @Published var captureImage: UIImage?

    /// - Tag: CreateCaptureSession
     func setupAVCaptureSession() {
         print(#function)
         captureSession.sessionPreset = .photo
         if let availableDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first {
             captureDevice = availableDevice
         }

         do {
             let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice!)
             captureSession.addInput(captureDeviceInput)
         } catch let error {
             print(error.localizedDescription)
         }

         let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.name = "CameraPreview"
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.backgroundColor = UIColor.black.cgColor
         self.previewLayer = previewLayer

         let dataOutput = AVCaptureVideoDataOutput()
         dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32BGRA]

         if captureSession.canAddOutput(dataOutput) {
             captureSession.addOutput(dataOutput)
         }
         captureSession.commitConfiguration()
     }

    func startSettion() {
        if captureSession.isRunning { return }
        captureSession.startRunning()
    }

    func stopSettion() {
        if !captureSession.isRunning { return }
        captureSession.stopRunning()
    }

    func capture() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        self.photoOutput?.capturePhoto(with: settings, delegate: self as AVCapturePhotoCaptureDelegate)
    }
}

extension VideoCaptureInteractor: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            captureImage = UIImage(data: imageData)
        }
    }
}
