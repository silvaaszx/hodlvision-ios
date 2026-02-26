import SwiftUI

struct HomeView: View {
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
                            Text("$ 100,000.00")
                                .font(.system(size: 38, weight: .heavy, design: .rounded))
                                .foregroundStyle(.white)
                            
                            Text("+ 2.4%")
                                .font(.headline)
                                .foregroundStyle(.green)
                                .padding(.bottom, 5)
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
                        print("Chamando API...")
                    }) {
                        HStack {
                            Image(systemName: "arrow.triangle.2.circlepath")
                            Text("Atualizar Cotação")
                        }
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(uiColor: .systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    Spacer()
                }
            }
            .background(Color.black.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}

// COMPONENTE REUTILIZÁVEL: Mostra a sua habilidade em componentizar a UI
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
