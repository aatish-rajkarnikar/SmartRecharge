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
        }
    }
    @IBOutlet var imageView:UIImageView!
    @IBOutlet var cropAreaView:UIView!
    
    var image:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        print("width \(image?.size.width) height \(image?.size.height)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
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
            
//            let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
//            let previewBounds = CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
//            let imageCoordinate = self.frameForImage(image: image, inImageView: imageView)
//            let imageViewFrame = imageView.frame
//            
//            let imageBoundsWithView = CGRect(x: imageCoordinate.origin.x + imageViewFrame.origin.x, y: imageCoordinate.origin.y + imageViewFrame.origin.y, width: imageCoordinate.width, height: imageCoordinate.height)
//            
//            let offset = scrollView.contentOffset
//            
//            let zoomedImageBounds = CGRect(x: imageBoundsWithView.origin.x - offset.x, y: imageBoundsWithView.origin.y - offset.y, width: imageBoundsWithView.width, height: imageBoundsWithView.height)
//            
//            let scaleFactor = imageView.image!.size.width/zoomedImageBounds.size.width
//            
//            let cropperFrame = CGRect(x: (view.frame.origin.x - zoomedImageBounds.origin.x) * scaleFactor, y: (view.frame.origin.y - zoomedImageBounds.origin.y) * scaleFactor, width: view.frame.size.width * scaleFactor, height: view.frame.size.height * scaleFactor)
//            
//            let cgImg = image.cgImage?.cropping(to: cropperFrame)
            let img = scaleImage(image: UIImage(cgImage: cgImg!), maxDimension: 640)
            print(img.size)
            TesseractManager.performImageRecognition(img, completion: { (result:String) in
                print(result)
                let storyboard = UIStoryboard.mainStoryboard()
                let resultViewController:ResultViewController = storyboard.instantiateViewController()
                resultViewController.previewImage = img
                resultViewController.previewText = result
                self.present(resultViewController, animated: true, completion: nil)
            })
            
        }
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
}
