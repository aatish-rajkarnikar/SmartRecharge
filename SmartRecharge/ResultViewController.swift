//
//  ResultViewController.swift
//  SmartRecharge
//
//  Created by Aatish Rajkarnikar on 9/29/16.
//  Copyright © 2016 iOSHub. All rights reserved.
//

import UIKit
import MessageUI

class ResultViewController: UIViewController {
    
    @IBOutlet var previewImageView:UIImageView!
    @IBOutlet var previewTextfield:UITextField!
    
    var image:UIImage?
    var text:String?{
        didSet{
            previewTextfield.text = text
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        previewImageView.image = image
        previewTextfield.text = text
        TesseractManager.performImageRecognition(image!, completion: { (result:String) in
            print(result)
            text = result.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
        })
    }
    
    @IBAction func recharge(){
        sendSMS(recipients: ["90012"], body: text!)
    }
    
    func sendSMS(recipients:[String],body:String) {
        let messageVC = MFMessageComposeViewController()
        messageVC.body = body
        messageVC.recipients = recipients
        messageVC.messageComposeDelegate = self
        present(messageVC, animated: true, completion: nil)
    }

}

extension ResultViewController: MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .cancelled :
            print("message canceled")
        case .failed :
            print("message failed")
            
        case .sent :
            print("message sent")
            
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
