import Foundation
import SwiftData

@Model
final class Contribution {
    var fiatAmount: Double
    var btcAmount: Double
    var date: Date
    
    init(fiatAmount: Double, btcAmount: Double, date: Date = Date()) {
        self.fiatAmount = fiatAmount
        self.btcAmount = btcAmount
        self.date = date
    }
}
