//
//  OCRManager.swift
//  SmartRecharge
//
//  Created by Aatish Rajkarnikar on 9/22/16.
//  Copyright © 2016 iOSHub. All rights reserved.
//

import UIKit
import Foundation


protocol OCRManager {
    static func performImageRecognition(image:UIImage,completion:(result:String)->())
}



struct TesseractManager:OCRManager {
    
    static func performImageRecognition(image: UIImage,completion:(result:String)->()) {
        let tesseract = G8Tesseract()
        tesseract.language = "eng+fra"
        tesseract.engineMode = .TesseractCubeCombined
        tesseract.pageSegmentationMode = .Auto
        tesseract.maximumRecognitionTime = 60.0
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        completion(result: tesseract.recognizedText)
    }
    
}