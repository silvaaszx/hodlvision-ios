import SwiftUI
import SwiftData

struct AddContributionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var fiatAmount: String = ""
    @State private var btcAmount: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Detalhes do Aporte")) {
                    TextField("Valor investido (US$)", text: $fiatAmount)
                        .keyboardType(.decimalPad)
                        .foregroundStyle(.orange)
                    
                    TextField("Fração de BTC comprada", text: $btcAmount)
                        .keyboardType(.decimalPad)
                        .foregroundStyle(.orange)
                }
            }
            .navigationTitle("Novo Aporte")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        let formattedFiat = fiatAmount.replacingOccurrences(of: ",", with: ".")
                        let formattedBtc = btcAmount.replacingOccurrences(of: ",", with: ".")
                        
                        if let fiatValue = Double(formattedFiat), let btcValue = Double(formattedBtc) {
                            let newContribution = Contribution(fiatAmount: fiatValue, btcAmount: btcValue)
                            modelContext.insert(newContribution)
                            dismiss()
                        }
                    }
                    .bold()
                    .tint(.orange)
                }
            }
        }
    }
}
