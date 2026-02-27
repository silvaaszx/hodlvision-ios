import Foundation
import SwiftData

@Model
final class Contribution {
    var amount: Double
    var date: Date
    
    init(amount: Double, date: Date = Date()) {
        self.amount = amount
        self.date = date
    }
}
