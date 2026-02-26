import Foundation
import SwiftUI
import Combine

@MainActor // Garante que a interface gráfica é sempre atualizada na thread principal
class HomeViewModel: ObservableObject {
    // Variáveis reativas que a UI vai escutar
    @Published var currentPrice: String = "$ --,---.--"
    @Published var priceChange: String = "--"
    @Published var isPositiveChange: Bool = true
    @Published var isLoading: Bool = false
    
    // Função para chamar o nosso serviço de rede
    func loadBitcoinData() {
        isLoading = true
        
        Task {
            do {
                // Chamada à API da CoinGecko
                let data = try await NetworkService.shared.fetchBitcoinPrice()
                
                // Formatação profissional de moeda e percentagem
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                formatter.currencyCode = "USD"
                formatter.maximumFractionDigits = 2
                
                if let formattedPrice = formatter.string(from: NSNumber(value: data.usd)) {
                    self.currentPrice = formattedPrice
                }
                
                self.isPositiveChange = data.usd24hChange >= 0
                let changePrefix = self.isPositiveChange ? "+" : ""
                self.priceChange = "\(changePrefix)\(String(format: "%.2f", data.usd24hChange))%"
                
                self.isLoading = false
            } catch {
                print("Erro na API: \(error)")
                self.currentPrice = "Erro de Ligação"
                self.isLoading = false
            }
        }
    }
}
