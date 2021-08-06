//
//  AppDelegate.swift
//  TrainingTime
//
//  Created by Ivan Bolshakov on 11.03.2021.
//

import UIKit
import Firebase
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private var firstAuthStateChange = true
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow()
        self.window = window
        window.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartLoadingViewController")
        window.makeKeyAndVisible()
        
        UINavigationBar.appearance().barTintColor = backgroundColorOur
        UINavigationBar.appearance().tintColor = UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1)]

        FirebaseApp.configure()
        
        Auth.auth().addStateDidChangeListener{ (auth, user) in
            
            if user == nil {
                UserState.shared.isLoggedIn = false
            } else {
                UserState.shared.userID = user!.uid
                UserState.shared.isLoggedIn = true
            }
            
            if self.firstAuthStateChange {
                window.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController")
            } else if let tabBarController = self.window?.rootViewController as? TabBarController {
                tabBarController.selectedIndex = 0
                tabBarController.updateSelectedViewController()
            }
            
            self.firstAuthStateChange = false
        }
        return true
    }

}

