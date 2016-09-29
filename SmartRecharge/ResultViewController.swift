//
//  ResultViewController.swift
//  SmartRecharge
//
//  Created by Aatish Rajkarnikar on 9/29/16.
//  Copyright © 2016 iOSHub. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet var previewImageView:UIImageView!
    @IBOutlet var previewTextfield:UITextField!
    
    var previewImage:UIImage?
    var previewText:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        previewImageView.image = previewImage
        previewTextfield.text = previewText
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recharge(){
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
