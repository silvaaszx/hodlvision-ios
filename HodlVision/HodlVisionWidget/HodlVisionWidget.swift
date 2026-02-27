import WidgetKit
import SwiftUI

// 1. O Modelo de Dados do Widget
struct BitcoinEntry: TimelineEntry {
    let date: Date
    let price: String
}

// 2. O Provedor de Dados (A inteligência que busca o preço)
struct HodlVisionProvider: TimelineProvider {
    // O que mostra enquanto está carregando
    func placeholder(in context: Context) -> BitcoinEntry {
        BitcoinEntry(date: Date(), price: "$ --,---.--")
    }

    // O que mostra na galeria de Widgets do iOS
    func getSnapshot(in context: Context, completion: @escaping (BitcoinEntry) -> ()) {
        let entry = BitcoinEntry(date: Date(), price: "$ 67,401.00")
        completion(entry)
    }

    // A linha do tempo real (Bate na API em background)
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let url = URL(string: "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            var currentPrice = "$ --,---.--"
            
            if let data = data {
                do {
                    // Estrutura rápida para decodificar o JSON aqui dentro
                    struct CoinGeckoWidgetResponse: Codable { let bitcoin: [String: Double] }
                    let result = try JSONDecoder().decode(CoinGeckoWidgetResponse.self, from: data)
                    
                    if let usdPrice = result.bitcoin["usd"] {
                        let formatter = NumberFormatter()
                        formatter.numberStyle = .currency
                        formatter.currencyCode = "USD"
                        formatter.maximumFractionDigits = 2
                        currentPrice = formatter.string(from: NSNumber(value: usdPrice)) ?? currentPrice
                    }
                } catch {
                    print("Erro no decodificador do Widget")
                }
            }
            
            let entry = BitcoinEntry(date: Date(), price: currentPrice)
            // Política da Apple: Atualiza o widget a cada 15 minutos para poupar bateria
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            
            completion(timeline)
        }.resume()
    }
}

// 3. O Visual do Widget na Tela Inicial
struct HodlVisionWidgetEntryView : View {
    var entry: HodlVisionProvider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "bitcoinsign.circle.fill")
                    .foregroundStyle(.orange)
                    .font(.title2)
                Text("HodlVision")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                Spacer()
            }
            
            Spacer()
            
            Text("Preço Atual")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
            
            Text(entry.price)
                .font(.system(size: 22, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
                .minimumScaleFactor(0.5) // Diminui a fonte se o número ficar gigante
        }
        // Fundo com o nosso gradiente premium
        .containerBackground(
            LinearGradient(
                colors: [Color.orange.opacity(0.8), Color.black.opacity(0.9)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            for: .widget
        )
    }
}

// 4. A Configuração Principal
@main
struct HodlVisionWidget: Widget {
    let kind: String = "HodlVisionWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HodlVisionProvider()) { entry in
            HodlVisionWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Cotação Bitcoin")
        .description("Acompanhe o preço do BTC na sua tela inicial.")
        .supportedFamilies([.systemSmall]) // Tamanho quadrado pequeno clássico
    }
}
