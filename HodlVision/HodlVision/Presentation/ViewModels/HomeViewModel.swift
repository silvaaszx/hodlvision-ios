import Foundation
import SwiftUI
import SwiftData
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var currentPrice: Double = 0.0
    @Published var priceChange24h: Double = 0.0
    @Published var marketCap: Double = 0.0
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    func fetchPrice() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let data = try await NetworkService.shared.fetchBitcoinData()
            self.currentPrice = data.price
            self.priceChange24h = data.priceChange24h
            self.marketCap = data.marketCap
        } catch {
            self.errorMessage = "Erro de Ligação"
        }
        
        isLoading = false
    }
}
