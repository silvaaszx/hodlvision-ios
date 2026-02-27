import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    // Header Pessoal
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Olá, Matheus")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("HodlVision")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        Spacer()
                        Image(systemName: "bitcoinsign.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.orange)
                    }
                    .padding(.horizontal)
                    
                    // Card Principal (Preço)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Preço Atual (BTC)")
                            .font(.headline)
                            .foregroundStyle(.white.opacity(0.8))
                        
                        if viewModel.isLoading && viewModel.currentPrice == 0 {
                            ProgressView()
                                .tint(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundStyle(.red)
                                .bold()
                        } else {
                            Text(viewModel.currentPrice, format: .currency(code: "USD"))
                                .font(.system(size: 42, weight: .heavy, design: .rounded))
                                .foregroundStyle(.white)
                                .contentTransition(.numericText()) // Animação suave nativa
                        }
                    }
                    .padding(.vertical, 30)
                    .padding(.horizontal, 25)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        LinearGradient(
                            colors: [.orange.opacity(0.9), .orange.opacity(0.5)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(color: .orange.opacity(0.3), radius: 15, x: 0, y: 8)
                    .padding(.horizontal)
                    
                    // Cards Secundários (Variação e Market Cap ao vivo)
                    HStack(spacing: 15) {
                        // Card de Variação
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: viewModel.priceChange24h >= 0 ? "arrow.up.right.circle.fill" : "arrow.down.right.circle.fill")
                                    .foregroundStyle(viewModel.priceChange24h >= 0 ? .green : .red)
                                Text("Variação 24h")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Text("\(viewModel.priceChange24h >= 0 ? "+" : "")\(viewModel.priceChange24h, format: .number.precision(.fractionLength(2)))%")
                                .font(.headline)
                                .foregroundStyle(viewModel.priceChange24h >= 0 ? .green : .red)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        // Card de Market Cap
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "chart.pie.fill")
                                    .foregroundStyle(.blue)
                                Text("Market Cap")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Text(viewModel.marketCap, format: .currency(code: "USD").notation(.compactName))
                                .font(.headline)
                                .foregroundStyle(.primary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top)
            }
            // A mágica acontece aqui: atualiza sozinho ao abrir a tela!
            .task {
                await viewModel.fetchPrice()
            }
        }
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}
