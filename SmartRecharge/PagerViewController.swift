//
//  PagerViewController.swift
//  SmartRecharge
//
//  Created by Aatish Rajkarnikar on 1/5/17.
//  Copyright © 2017 iOSHub. All rights reserved.
//

import UIKit

class PagerViewController: UIViewController {

    @IBOutlet var leftTopButton: UIButton!
    @IBOutlet var rightTopButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    @IBAction func rightTopButtonPressed(_ sender: UIButton) {
    }
    @IBAction func leftTopButtonPressed(_ sender: UIButton) {
    }
    
    
}
