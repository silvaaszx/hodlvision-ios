import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // Aba 1: Mercado (A que já temos pronta)
            HomeView()
                .tabItem {
                    Label("Mercado", systemImage: "chart.line.uptrend.xyaxis")
                }
            
            // Aba 2: Calculadora de Projeção
            ProjectionView()
                .tabItem {
                    Label("Projeção", systemImage: "function")
                }
            
            // Aba 3: Carteira (Onde vai entrar o SwiftData depois)
            WalletView()
                .tabItem {
                    Label("Carteira", systemImage: "briefcase.fill")
                }
        }
        .tint(.orange) // Mantém a identidade visual do Bitcoin
    }
}

#Preview {
    MainTabView()
        .preferredColorScheme(.dark)
}
