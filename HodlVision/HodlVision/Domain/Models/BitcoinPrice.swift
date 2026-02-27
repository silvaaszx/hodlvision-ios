import Foundation

// A estrutura principal que a API devolve
struct CoinGeckoResponse: Codable {
    let bitcoin: BitcoinData
}

// Os dados do Bitcoin que realmente importam para nós
struct BitcoinData: Codable {
    let usd: Double
    let usd24hChange: Double
    
    enum CodingKeys: String, CodingKey {
        case usd
        case usd24hChange = "usd_24h_change"
    }
}
