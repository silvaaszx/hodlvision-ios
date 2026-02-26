import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    
                    // Cabeçalho (Header)
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Olá, Matheus")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("HodlVision")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        Spacer()
                        Image(systemName: "bitcoinsign.circle.fill")
                            .resizable()
                            .frame(width: 45, height: 45)
                            .foregroundStyle(.orange)
                            .shadow(color: .orange.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Card Principal de Preço
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Preço Atual (BTC)")
                            .font(.headline)
                            .foregroundStyle(.white.opacity(0.9))
                        
                        HStack(alignment: .bottom) {
                            Text(viewModel.currentPrice)
                                .font(.system(size: 38, weight: .heavy, design: .rounded))
                                .foregroundStyle(.white)
                                .redacted(reason: viewModel.isLoading ? .placeholder : [])
                            
                            Text(viewModel.priceChange)
                                .font(.headline)
                                .foregroundStyle(viewModel.isPositiveChange ? .green : .red)
                                .padding(.bottom, 5)
                                .redacted(reason: viewModel.isLoading ? .placeholder : [])
                        }
                    }
                    .padding(25)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.orange.opacity(0.9), Color.orange.opacity(0.5)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .shadow(color: .orange.opacity(0.2), radius: 10, x: 0, y: 5)
                    .padding(.horizontal)
                    
                    // Grid de Estatísticas Secundárias
                    HStack(spacing: 15) {
                        StatCard(title: "Variação 24h", value: "+ $ 2,400", icon: "arrow.up.right.circle.fill", color: .green)
                        StatCard(title: "Market Cap", value: "$ 1.9 T", icon: "chart.pie.fill", color: .blue)
                    }
                    .padding(.horizontal)
                    
                    // Botão de Ação Modernizado
                    Button(action: {
                        viewModel.loadBitcoinData()
                    }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "arrow.triangle.2.circlepath")
                            }
                            Text(viewModel.isLoading ? "A atualizar..." : "Atualizar Cotação")
                        }
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(uiColor: .systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .disabled(viewModel.isLoading) // Agora sim, no lugar certo!
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    Spacer()
                }
            }
            .background(Color.black.ignoresSafeArea())
            .navigationBarHidden(true)
            .task { // O GATILHO MÁGICO
                viewModel.loadBitcoinData()
            }
        }
    }
}

// COMPONENTE REUTILIZÁVEL
struct StatCard: View {
    var title: String
    var value: String
    var icon: String
    var color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .font(.title3)
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: .systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}
