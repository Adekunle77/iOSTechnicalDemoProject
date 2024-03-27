//
//  AppDelegate.swift
//  iOSTechnicalDemoProject
//
//  Created by Ade Adegoke on 20/03/2024.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let container = DIContainer.shared
        let api = NetworkManager()
        let repository = BreedRepository(api: api)
        
        container.register(type: Networkable.self, component: api)
        container.register(type: Repository.self, component: repository)
    
        return true
    }
}
