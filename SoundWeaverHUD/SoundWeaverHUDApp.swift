//
//  SoundWeaverHUDApp.swift
//  SoundWeaverHUD
//
//  Created by Jeremy Huang on 7/28/24.
//

import SwiftUI
import Combine
import SoundAnalysis
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct SoundWeaverHUDApp: App {
    // register app delegate for Firebase setup
      @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    
    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }.windowStyle(.volumetric)
        
        ImmersiveSpace(id: "ImmersiveSpace") {
            ContentView()
        }
    }
}
