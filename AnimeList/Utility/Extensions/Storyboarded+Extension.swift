//
//  StoryBoarded+Extension.swift
//  AnimeList
//
//  Created by David on 17/03/2022.
//

import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    
    static func instantiate() -> Self {
        // this pulls out the class name from the class being instantiated
        let fullName = NSStringFromClass(self)

        //this splits the string into Array Items by the dot and uses the second item changing "AnimeList.{className}" to "{className}"
        let className = fullName.components(separatedBy: ".")[1]

        // load our storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // instantiate a view controller with that identifier, and force cast as the type that was requested
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
