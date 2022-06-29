//
//  AppDelegate.swift
//  wordLearning
//
//  Created by Andrey Luferau on 5/9/22.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        ServiceContainer.register(WordCardService() as WordCardServiceProtocol)
        ServiceContainer.register(UserService() as UserServiceProtocol)
        
        return true
    }
}
