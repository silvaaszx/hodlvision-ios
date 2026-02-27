import SwiftUI
import SwiftData

struct WalletView: View {
    // Acessa o banco de dados
    @Environment(\.modelContext) private var modelContext
    // Busca os aportes ordenados do mais recente para o mais antigo
    @Query(sort: \Contribution.date, order: .reverse) private var contributions: [Contribution]
    
    @State private var showingAddSheet = false
    
    // Lógica que soma todos os aportes automaticamente
    var totalAmount: Double {
        contributions.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Card Header: Total Aportado
                VStack(spacing: 10) {
                    Text("Total Aportado")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))
                    
                    Text(totalAmount, format: .currency(code: "USD"))
                        .font(.system(size: 42, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                }
                .padding(.vertical, 30)
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
                                        Text("Depósito")
                                            .font(.headline)
                                        Text(contribution.date, format: .dateTime.day().month().year())
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(contribution.amount, format: .currency(code: "USD"))
                                        .fontWeight(.bold)
                                        .foregroundStyle(.green)
                                }
                                .padding(.vertical, 4)
                            }
                            .onDelete(perform: deleteContributions) // Permite arrastar para apagar!
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
                    .presentationDetents([.medium]) // Faz a tela subir só até a metade
            }
        }
    }
    
    // Função para deletar um aporte se você arrastar para o lado
    private func deleteContributions(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(contributions[index])
        }
    }
}
