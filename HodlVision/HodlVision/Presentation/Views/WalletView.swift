import SwiftUI

struct WalletView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "briefcase.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.orange)
                    .padding()
                Text("Minha Carteira")
                    .font(.title2).bold()
                Text("Em breve: Gestão de ativos com SwiftData")
                    .foregroundStyle(.secondary)
            }
            .navigationTitle("Carteira")
        }
    }
}
