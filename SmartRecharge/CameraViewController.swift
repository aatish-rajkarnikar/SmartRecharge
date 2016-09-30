//
//  CameraViewController.swift
//  SmartRecharge
//
//  Created by Aatish Rajkarnikar on 9/22/16.
//  Copyright © 2016 iOSHub. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var previewView:UIView!
    
    @IBAction func capture(){
        if let videoConnection = imageOutput!.connection(withMediaType: AVMediaTypeVideo) {
            imageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(sampleBuffer, error) in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                var takenImage = UIImage(data: imageData!)
                takenImage = self.fixOrientationOfImage(image: takenImage!)
                print(takenImage?.imageOrientation.rawValue)
                let storyboard = UIStoryboard.mainStoryboard()
                let vc:CropperViewController = storyboard.instantiateViewController()
                vc.image = takenImage
                self.present(vc, animated: true, completion: nil)
//                let outputRect = self.previewLayer?.metadataOutputRectOfInterest(for: self.previewLayer!.bounds)
//                let takenCGImage = takenImage?.cgImage
//                let width = takenCGImage?.width
//                let height = takenCGImage?.height
//                let originX = outputRect!.origin.x
//                let originY = outputRect!.origin.y
//                
//                let factorW = CGFloat(width!)/self.previewImageView.frame.width
//                let factorH = CGFloat(height!)/self.boundaryRectView.frame.height
//                
//                let cropRect = CGRect(x:  originX * CGFloat(width!), y: originY * CGFloat(height!), width: outputRect!.size.width * CGFloat(width!), height: factorW * self.boundaryRectView.frame.width )
//                let cropImage = takenCGImage?.cropping(to: cropRect)
//                takenImage = UIImage(cgImage: cropImage!, scale: 1, orientation: (takenImage?.imageOrientation)!)
//                
//                self.previewImageView.image = takenImage
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSessionPresetPhoto
        
        let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let input = try! AVCaptureDeviceInput(device: backCamera)
        session?.addInput(input)
        
        imageOutput = AVCaptureStillImageOutput()
        imageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        session?.addOutput(imageOutput)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session!)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer!.frame = previewView.bounds
        previewView.layer.addSublayer(previewLayer!)
        session?.startRunning()
    }
    
    
    func fixOrientationOfImage(image: UIImage) -> UIImage? {
        if image.imageOrientation == .up {
            return image
        }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform = CGAffineTransform.identity
        
        switch image.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: image.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: image.size.height)
            transform = transform.rotated(by: -CGFloat(M_PI_2))
        default:
            break
        }
        
        switch image.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: image.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        guard let context = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: image.cgImage!.bitsPerComponent, bytesPerRow: 0, space: image.cgImage!.colorSpace!, bitmapInfo: image.cgImage!.bitmapInfo.rawValue) else {
            return nil
        }
        
        context.concatenate(transform)
        
        switch image.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            context.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width))
        default:
            context.draw(image.cgImage!, in: CGRect(origin: .zero, size: image.size))
        }
        
        // And now we just create a new UIImage from the drawing context
        guard let CGImage = context.makeImage() else {
            return nil
        }
        
        return UIImage(cgImage: CGImage)
    }
}

