//
//  StoryboardExtension.swift
//  SmartRecharge
//
//  Created by Aatish Rajkarnikar on 9/30/16.
//  Copyright © 2016 iOSHub. All rights reserved.
//

import Foundation

extension UIStoryboard{
    class func mainStoryboard()-> UIStoryboard{
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    func instantiateViewController<T: UIViewController>()->T where T: StoryboardIdentifiable {
        guard let vc = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else{
            fatalError("Couldn't instantiate ViewController with identifier \(T.storyboardIdentifier)")
        }
        return vc
    }
}
