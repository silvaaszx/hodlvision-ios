//
//  HodlVisionApp.swift
//  HodlVision
//
//  Created by Matheus Silva on 26/02/26.
//

import SwiftUI
import SwiftData

@main
struct HodlVisionApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
            
        }
        .modelContainer(for: Contribution.self)
    }
}

