
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

