import SwiftUI
import SwiftData

struct WalletView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Contribution.date, order: .reverse) private var contributions: [Contribution]
    
    @State private var showingAddSheet = false
    @State private var currentBtcPrice: Double = 0.0
    @State private var isLoadingPrice = true
    
    // Cálculos dinâmicos
    var totalFiatInvested: Double {
        contributions.reduce(0) { $0 + $1.fiatAmount }
    }
    
    var totalBtcAccumulated: Double {
        contributions.reduce(0) { $0 + $1.btcAmount }
    }
    
    var currentEquity: Double {
        totalBtcAccumulated * currentBtcPrice
    }
    
    var profitOrLoss: Double {
        currentEquity - totalFiatInvested
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Card Header Inteligente
                VStack(spacing: 15) {
                    Text("Patrimônio Atual (Ao Vivo)")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))
                    
                    if isLoadingPrice {
                        ProgressView().tint(.white)
                    } else {
                        Text(currentEquity, format: .currency(code: "USD"))
                            .font(.system(size: 42, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)
                            .contentTransition(.numericText())
                        
                        // Badge de Lucro/Prejuízo
                        HStack {
                            Image(systemName: profitOrLoss >= 0 ? "arrow.up.right" : "arrow.down.right")
                            Text(abs(profitOrLoss), format: .currency(code: "USD"))
                        }
                        .font(.headline)
                        .foregroundStyle(profitOrLoss >= 0 ? .green : .red)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Capsule())
                    }
                    
                    Divider().background(.white.opacity(0.3)).padding(.horizontal, 40)
                    
                    HStack(spacing: 40) {
                        VStack {
                            Text("Total Investido")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.7))
                            Text(totalFiatInvested, format: .currency(code: "USD"))
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                        
                        VStack {
                            Text("Saldo em BTC")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.7))
                            Text("\(String(format: "%.4f", totalBtcAccumulated)) ₿")
                                .font(.headline)
                                .foregroundStyle(.orange)
                        }
                    }
                }
                .padding(.vertical, 25)
                .frame(maxWidth: .infinity)
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
                .padding(.top, 10)
                
                // Lista de Histórico
                List {
                    Section("Histórico de Aportes") {
                        if contributions.isEmpty {
                            Text("Nenhum aporte registrado ainda.")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(contributions) { contribution in
                                HStack {
                                    Image(systemName: "arrow.down.left.circle.fill")
                                        .foregroundStyle(.green)
                                        .font(.title2)
                                    
                                    VStack(alignment: .leading) {
                                        Text("\(String(format: "%.4f", contribution.btcAmount)) BTC")
                                            .font(.headline)
                                            .foregroundStyle(.orange)
                                        Text(contribution.date, format: .dateTime.day().month().year())
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(contribution.fiatAmount, format: .currency(code: "USD"))
                                        .fontWeight(.bold)
                                        .foregroundStyle(.primary)
                                }
                                .padding(.vertical, 4)
                            }
                            .onDelete(perform: deleteContributions)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Carteira")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.orange)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddContributionView()
                    .presentationDetents([.medium])
            }
            // Gatilho para buscar o preço ao vivo ao abrir a aba
            .task {
                await fetchCurrentPrice()
            }
        }
    }
    
    private func fetchCurrentPrice() async {
            isLoadingPrice = true
            do {
                // 1. Chama a função com o nome novo
                let data = try await NetworkService.shared.fetchBitcoinData()
                // 2. Agora acessamos a propriedade '.price' do nosso novo modelo
                currentBtcPrice = data.price
                isLoadingPrice = false
            } catch {
                print("Erro ao buscar preço na Carteira")
                isLoadingPrice = false
            }
        }
    private func deleteContributions(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(contributions[index])
        }
    }
}
