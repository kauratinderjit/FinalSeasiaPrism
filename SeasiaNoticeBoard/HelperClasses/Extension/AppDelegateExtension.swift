//
//  AppDelegateExtension.swift
//  OrganicsBazaar
//
//  Created by Taranjeet Singh on 5/9/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import UIKit


var appDelegate: AppDelegate {
    guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
        fatalError("AppDelegate is not UIApplication.shared.delegate")
    }
    return delegate
}


extension AppDelegate{

    
}

