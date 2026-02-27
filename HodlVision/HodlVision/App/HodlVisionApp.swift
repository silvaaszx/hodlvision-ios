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
            LockView()
            
        }
        .modelContainer(for: Contribution.self)
    }
}

