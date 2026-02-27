import SwiftUI
import SwiftData

struct AddContributionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var amount: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Detalhes do Aporte")) {
                    TextField("Valor do Aporte ($)", text: $amount)
                        .keyboardType(.decimalPad)
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
                        // Converte o texto para número e salva no banco!
                        let formattedAmount = amount.replacingOccurrences(of: ",", with: ".")
                        if let value = Double(formattedAmount) {
                            let newContribution = Contribution(amount: value)
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
