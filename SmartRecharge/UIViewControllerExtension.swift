//
//  UIViewControllerExtension.swift
//  SmartRecharge
//
//  Created by Aatish Rajkarnikar on 9/30/16.
//  Copyright © 2016 iOSHub. All rights reserved.
//

import Foundation

protocol StoryboardIdentifiable {
    static var storyboardIdentifier:String {get}
}

extension StoryboardIdentifiable where Self: UIViewController{
    static var storyboardIdentifier: String{
        get{
            return String(describing: self)
        }
    }
}

extension UIViewController: StoryboardIdentifiable{
    
}
