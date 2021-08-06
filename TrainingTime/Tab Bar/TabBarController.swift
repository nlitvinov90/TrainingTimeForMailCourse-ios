//
//  TabBarController.swift
//  TrainingTime
//
//  Created by Никита Литвинов on 14.05.2021.
//

import UIKit

final class TabBarController : UITabBarController, UITabBarControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.barTintColor = UIColor(red: 0.071, green: 0.078, blue: 0.086, alpha: 1)
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if !UserState.shared.isLoggedIn, let _ = viewController as? ProfileViewController {
                tabBarController.present(AuthMainViewController(), animated: true, completion: nil)
                return false
            }
        if !UserState.shared.isLoggedIn, let _ = viewController as? NavBarForFavorites {
                tabBarController.present(AuthMainViewController(), animated: true, completion: nil)
                return false
            }
            
            return true
        }
    
    func updateSelectedViewController() {
        var baseViewController: BaseViewController?
        
        if let navVC = selectedViewController as? UINavigationController {
            navVC.popToRootViewController(animated: false)
            baseViewController = navVC.viewControllers.first as? BaseViewController
        } else {
            baseViewController = selectedViewController as? BaseViewController
        }
        
        baseViewController?.updateAfterAuthStateChanged()
    }
}
