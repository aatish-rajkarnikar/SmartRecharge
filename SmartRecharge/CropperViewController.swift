//
//  CropperViewController.swift
//  SmartRecharge
//
//  Created by Aatish Rajkarnikar on 9/27/16.
//  Copyright © 2016 iOSHub. All rights reserved.
//

import UIKit

class CropperViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var scrollView:UIScrollView!{
        didSet{
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = 10.0
            scrollView.delegate = self
        }
    }
    @IBOutlet var imageView:UIImageView!
    @IBOutlet var cropAreaView:UIView!{
        didSet{
            cropAreaView.layer.borderColor = UIColor.red.cgColor
            cropAreaView.layer.borderWidth = 1.0
        }
    }
    
    var image:UIImage?{
        didSet{
            imageView.image = image
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    
    
    @IBAction func crop(){
        if let image = image,let imageView = imageView{
            let factor = image.size.width/view.frame.width
            let scale = 1/scrollView.zoomScale
            let imageFrame = frameForImage(image: image, inImageView: imageView)
            let x = (scrollView.contentOffset.x + cropAreaView.frame.origin.x - imageFrame.origin.x) * scale * factor
            let y = (scrollView.contentOffset.y + cropAreaView.frame.origin.y - imageFrame.origin.y) * scale * factor
            
            let visibleRect = CGRect(x: x, y: y, width: cropAreaView.frame.size.width * scale * factor, height: cropAreaView.frame.size.height * scale * factor)
            let cgImg = image.cgImage?.cropping(to: visibleRect)
            
            let img = scaleImage(image: UIImage(cgImage: cgImg!), maxDimension: 640)

            TesseractManager.performImageRecognition(img, completion: { (result:String) in
                print(result)
                let storyboard = UIStoryboard.mainStoryboard()
                let resultViewController:ResultViewController = storyboard.instantiateViewController()
                resultViewController.previewImage = img
                resultViewController.previewText = result.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
                self.present(resultViewController, animated: false, completion: nil)
            })
            
        }
    }
    
    @IBAction func retake(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func frameForImage(image:UIImage, inImageView imageView:UIImageView)->CGRect{
        let imageRatio = image.size.width / image.size.height
        let imageViewRatio = imageView.frame.size.width / imageView.frame.size.height
        
        if imageRatio < imageViewRatio {
            let scaleFactor = imageView.frame.size.height / image.size.height
            let width = image.size.width * scaleFactor
            let topLeftX = (imageView.frame.size.width - width) * 0.5
            return CGRect(x: topLeftX, y: 0, width: width, height: imageView.frame.size.height)
        }else{
            let scalFactor = imageView.frame.size.width / image.size.width
            let height = image.size.height * scalFactor
            let topLeftY = (imageView.frame.size.height - height) * 0.5
            return CGRect(x: 0, y: topLeftY, width: imageView.frame.size.width, height: height)
        }
    }

    func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor:CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
