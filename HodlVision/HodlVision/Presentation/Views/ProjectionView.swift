import SwiftUI

struct ProjectionView: View {
    // Variáveis de entrada (Aportes)
    @State private var initialAmount: String = ""
    @State private var monthlyContribution: String = ""
    @State private var targetYears: Double = 35
    
    // Variáveis de cenário do Bitcoin
    @State private var averageBtcPrice: String = "" // Preço médio de compra
    @State private var futureBtcPrice: String = ""  // Preço que vai atingir
    
    // Variáveis de resultado
    @State private var projectedTotalFiat: Double = 0.0
    @State private var totalInvested: Double = 0.0
    @State private var accumulatedBTC: Double = 0.0
    @State private var showResult: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Seus Aportes")) {
                    HStack {
                        Text("Investimento Inicial ($)")
                        Spacer()
                        TextField("0.00", text: $initialAmount)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(.orange)
                    }
                    
                    HStack {
                        Text("Aporte Mensal ($)")
                        Spacer()
                        TextField("0.00", text: $monthlyContribution)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(.orange)
                    }
                }
                
                Section(header: Text("Horizonte de Tempo: \(Int(targetYears)) anos")) {
                    Slider(value: $targetYears, in: 1...40, step: 1)
                        .tint(.orange)
                }
                
                Section(header: Text("Cenário do Bitcoin")) {
                    HStack {
                        Text("Preço Médio de Compra ($)")
                        Spacer()
                        TextField("Ex: 100000", text: $averageBtcPrice)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Preço Alvo Futuro ($)")
                        Spacer()
                        TextField("Ex: 1000000", text: $futureBtcPrice)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section {
                    Button(action: {
                        calculateDCA()
                    }) {
                        Text("Calcular Projeção")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .padding(.vertical, 4)
                    }
                    .listRowBackground(Color.orange)
                }
                
                // Card de Resultado
                if showResult {
                    Section(header: Text("Resultado da Estratégia")) {
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Total Aportado:")
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(totalInvested, format: .currency(code: "USD"))
                                    .fontWeight(.medium)
                            }
                            
                            HStack {
                                Text("BTC Acumulado:")
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("\(String(format: "%.4f", accumulatedBTC)) BTC")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.orange)
                            }
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Patrimônio Estimado:")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                                Text(projectedTotalFiat, format: .currency(code: "USD"))
                                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                                    .foregroundStyle(.green)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("Simulador DCA")
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showResult)
        }
    }
    
    // A MÁGICA REAL DO MERCADO (DCA)
    private func calculateDCA() {
        // Formata os textos para números
        let initial = Double(initialAmount.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        let monthly = Double(monthlyContribution.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        let avgPrice = Double(averageBtcPrice.replacingOccurrences(of: ",", with: ".")) ?? 1.0 // Evita divisão por zero
        let futurePrice = Double(futureBtcPrice.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        let years = targetYears
        
        let totalMonths = years * 12.0
        
        // 1. Calcula o total em dólares tirados do bolso
        totalInvested = initial + (monthly * totalMonths)
        
        // 2. Calcula quanto de Bitcoin esse dinheiro comprou com base no preço médio
        accumulatedBTC = totalInvested / avgPrice
        
        // 3. Calcula quanto esse saldo de Bitcoin valerá no preço alvo do futuro
        projectedTotalFiat = accumulatedBTC * futurePrice
        
        // Esconde o teclado e mostra o resultado
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        showResult = true
    }
}

#Preview {
    ProjectionView()
        .preferredColorScheme(.dark)
}
