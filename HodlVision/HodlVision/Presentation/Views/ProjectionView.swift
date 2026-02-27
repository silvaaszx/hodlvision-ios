import SwiftUI

struct ProjectionView: View {
    // Variáveis de estado para guardar os dados digitados
    @State private var initialAmount: String = ""
    @State private var monthlyContribution: String = ""
    @State private var targetYears: Double = 10
    @State private var estimatedBitcoinPrice: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Parâmetros de Investimento")) {
                    HStack {
                        Text("Investimento Inicial ($)")
                        Spacer()
                        TextField("0.00", text: $initialAmount)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Aporte Mensal ($)")
                        Spacer()
                        TextField("0.00", text: $monthlyContribution)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section(header: Text("Projeção de Tempo: \(Int(targetYears)) anos")) {
                    Slider(value: $targetYears, in: 1...40, step: 1)
                        .tint(.orange)
                }
                
                Section(header: Text("Cenário do Bitcoin")) {
                    HStack {
                        Text("Preço Alvo do BTC ($)")
                        Spacer()
                        TextField("Ex: 150000", text: $estimatedBitcoinPrice)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section {
                    Button(action: {
                        print("Aqui vamos fazer a mágica matemática depois!")
                    }) {
                        Text("Calcular Projeção")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.orange)
                    }
                }
            }
            .navigationTitle("Simulador")
        }
    }
}

#Preview {
    ProjectionView()
        .preferredColorScheme(.dark)
}
