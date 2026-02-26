import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Mercado", systemImage: "chart.xyaxis.line")
                }
            
            Text("Minha Carteira (Em breve)")
                .tabItem {
                    Label("Carteira", systemImage: "briefcase.fill")
                }
            
            Text("Ajustes (Em breve)")
                .tabItem {
                    Label("Ajustes", systemImage: "gearshape.fill")
                }
        }
        .tint(.orange) // Cor de destaque baseada no Bitcoin
    }
}

#Preview {
    MainTabView()
        .preferredColorScheme(.dark)
}
