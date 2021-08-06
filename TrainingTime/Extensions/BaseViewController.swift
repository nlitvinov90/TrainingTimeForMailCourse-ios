//
//  UIViewController+Extensions.swift
//  TrainingTime
//
//  Created by Andrey Babkov on 01.06.2021.
//

import UIKit

class BaseViewController: UIViewController {
    var oldIsLoggedIn = UserState.shared.isLoggedIn
    
    func updateAfterAuthStateChanged() {
        // subclasses can override
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if oldIsLoggedIn != UserState.shared.isLoggedIn {
            updateAfterAuthStateChanged()
            oldIsLoggedIn.toggle()
        }
    }
}
