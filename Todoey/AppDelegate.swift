//
//  AppDelegate.swift
//  Todoey
//
//  Created by Sikorskiy Yaroslav on 1/3/19.
//  Copyright © 2019 Sikorskiy Yaroslav. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do{
            _ = try Realm()
        }catch{
            print("Realm error \(error)")
        }
        
        return true
    }
}

