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
    static func performImageRecognition(_ image:UIImage,completion:(_ result:String)->())
}



struct TesseractManager:OCRManager {
    
    static func performImageRecognition(_ image: UIImage,completion:(_ result:String)->()) {
        let tesseract = G8Tesseract()
        tesseract.language = "eng"
        tesseract.charWhitelist = "0123456789"
        tesseract.engineMode = .tesseractCubeCombined
        tesseract.pageSegmentationMode = .singleLine
        tesseract.maximumRecognitionTime = 60.0
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        completion(tesseract.recognizedText)
    }
    
}
