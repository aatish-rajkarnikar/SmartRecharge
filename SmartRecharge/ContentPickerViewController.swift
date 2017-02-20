//
//  ContentPickerViewController.swift
//  SmartRecharge
//
//  Created by Aatish Rajkarnikar on 2/14/17.
//  Copyright © 2017 iOSHub. All rights reserved.
//

import UIKit

class ContentPickerViewController: UIViewController, CameraViewControllerDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    private var cameraViewController:CameraViewController!{
        didSet{
            cameraViewController.delegate = self
        }
    }
    private var cropperViewController:CropperViewController!{
        didSet{
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "EmbedCameraViewController":
            cameraViewController =  segue.destination as! CameraViewController
            break
        case "EmbedCropperViewController":
            cropperViewController = segue.destination as! CropperViewController
            break
        default:
            break
        }
    }
    
    func cameraViewController(_ cameraViewController: CameraViewController, didCaptureImage image: UIImage) {
        UIView.animate(withDuration: 0.33, delay: 0, options: .curveEaseInOut, animations: {
            self.cropperViewController.image = image
            self.scrollView.scrollRectToVisible(CGRect(x: 0, y: self.scrollView.frame.size.height, width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height), animated: false)}, completion: nil)
        
    }

}
