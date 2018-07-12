//
//  ScanQRController.swift
//  CliqCard
//
//  Created by Sam Ober on 7/11/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftSpinner

class ScanQRController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIViewControllerTransitioningDelegate {
    
    var callback: (CCGroup) -> Void
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    lazy var qrCodeFrameView: UIView! = {
        let view = UIView()
        view.layer.borderColor = UIColor.green.cgColor
        view.layer.borderWidth = 2
        
        return view
    }()
    
    init(callback: @escaping (CCGroup) -> Void) {
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Scan QR Code"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))

        // get the camera
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: .video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else { return }
        
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        // capture on the capture session
        self.captureSession.addInput(input)
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        self.captureSession.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        // create the video preview layer
        self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.videoPreviewLayer?.frame = self.view.layer.bounds
        self.view.layer.addSublayer(self.videoPreviewLayer!)
        
        // setup the qr code preview
        self.view.addSubview(self.qrCodeFrameView)
        self.view.bringSubview(toFront: self.qrCodeFrameView)
        
        // start video capture
        self.captureSession.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // check for barcode frame
            let barCodeObject = self.videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            self.qrCodeFrameView.frame = barCodeObject!.bounds
            
            guard let code = metadataObj.stringValue else { return }
            // stop capture
            self.captureSession.stopRunning()
            // try to join using the code
            self.join(code)
        }
    }
    
    func join(_ code: String) {
        // get sharing details
        let controller = GroupSharingController { (phoneIds, emailIds) in
            self.dismiss(animated: false, completion: nil)
            SwiftSpinner.show("Joining group...")
            
            CliqCardAPI.shared.joinGroup(code: code, phoneIds: phoneIds, emailIds: emailIds) { (group, error) in
                SwiftSpinner.hide({
                    if let group = group {
                        // call the callback
                        self.callback(group)
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.showError(title: "Error", message: "This is not a valid group code.") { () -> Void in
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                })
            }
        }
        let navigationController = SJONavigationController(rootViewController: controller)
        navigationController.transitioningDelegate = self
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc func cancel() {
        self.captureSession.stopRunning()
        self.dismiss(animated: true, completion: nil)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PageOverPresentAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PageOverDismissAnimator()
    }

}
