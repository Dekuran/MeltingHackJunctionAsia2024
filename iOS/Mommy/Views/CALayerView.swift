import UIKit
import SwiftUI

struct CALayerView: UIViewRepresentable {
    typealias UIViewType = UIView
    var caLayer: CALayer
    let size: CGSize

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.layer.addSublayer(caLayer)
        caLayer.frame = CGRect(origin: .zero, size: size) //view.layer.frame
        view.layer.masksToBounds = true
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        caLayer.frame = CGRect(origin: .zero, size: size) // uiView.layer.bounds
    }
}

//struct CALayerView: UIViewControllerRepresentable {
//    typealias UIViewControllerType = UIViewController
//    var caLayer: CALayer
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        let viewController = UIViewController()
//        viewController.view.layer.addSublayer(caLayer)
//        caLayer.frame = viewController.view.layer.frame
//        return viewController
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        caLayer.frame = uiViewController.view.layer.frame
//    }
//}
