//
//  CameraViewController.swift
//  SmartRecharge
//
//  Created by Aatish Rajkarnikar on 9/22/16.
//  Copyright © 2016 iOSHub. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var previewView:UIView!
    @IBAction func capture(){
        if let videoConnection = imageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
            imageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                let dataProvider = CGDataProviderCreateWithCFData(imageData)
                let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, .RenderingIntentDefault)
                _ = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                self.session?.stopRunning()
            })
        }
    }
    
    var session:AVCaptureSession?
    var imageOutput:AVCaptureStillImageOutput?
    var previewLayer:AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSessionPresetPhoto
        
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let input = try! AVCaptureDeviceInput(device: backCamera)
        session?.addInput(input)
        
        imageOutput = AVCaptureStillImageOutput()
        imageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        session?.addOutput(imageOutput)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session!)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer!.frame = previewView.bounds
        previewView.layer.addSublayer(previewLayer!)
        session?.startRunning()
    }
}
