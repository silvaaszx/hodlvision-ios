import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    private let cacheKey = "cachedBtcPrice"
    private let cacheTimeKey = "cachedBtcTime"
    
    func fetchBitcoinData() async throws -> BitcoinPrice {
        // 1. TENTA O CACHE (Válido por 5 minutos para poupar a rede)
        if let cachedTime = UserDefaults.standard.object(forKey: cacheTimeKey) as? Date,
           Date().timeIntervalSince(cachedTime) < 300,
           let cachedData = UserDefaults.standard.data(forKey: cacheKey),
           let decoded = try? JSONDecoder().decode(BitcoinPrice.self, from: cachedData) {
            return decoded
        }
        
        // 2. TENTA A API PRINCIPAL (CoinGecko)
        do {
            return try await fetchFromCoinGecko()
        } catch {
            print("CoinGecko falhou. Acionando Fallback da Binance...")
            // 3. FALLBACK PARA A BINANCE
            do {
                return try await fetchFromBinance()
            } catch {
                // 4. ÚLTIMO RECURSO: Retorna o cache antigo se estiver sem internet
                if let oldData = UserDefaults.standard.data(forKey: cacheKey),
                   let oldDecoded = try? JSONDecoder().decode(BitcoinPrice.self, from: oldData) {
                    return oldDecoded
                }
                throw error
            }
        }
    }
    
    private func fetchFromCoinGecko() async throws -> BitcoinPrice {
        let url = URL(string: "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd&include_market_cap=true&include_24hr_change=true")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        struct CGResponse: Codable { let bitcoin: [String: Double] }
        let result = try JSONDecoder().decode(CGResponse.self, from: data)
        
        let btcData = BitcoinPrice(
            price: result.bitcoin["usd"] ?? 0,
            priceChange24h: result.bitcoin["usd_24h_change"] ?? 0,
            marketCap: result.bitcoin["usd_market_cap"] ?? 0
        )
        
        saveCache(data: btcData)
        return btcData
    }
    
    private func fetchFromBinance() async throws -> BitcoinPrice {
        let url = URL(string: "https://api.binance.com/api/v3/ticker/24hr?symbol=BTCUSDT")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        struct BinanceResponse: Codable {
            let lastPrice: String
            let priceChangePercent: String
        }
        let result = try JSONDecoder().decode(BinanceResponse.self, from: data)
        
        let price = Double(result.lastPrice) ?? 0
        let btcData = BitcoinPrice(
            price: price,
            priceChange24h: Double(result.priceChangePercent) ?? 0,
            // A Binance não envia market cap nesta rota. Estimativa baseada em ~19.6M BTC minerados
            marketCap: price * 19_600_000
        )
        
        saveCache(data: btcData)
        return btcData
    }
    
    private func saveCache(data: BitcoinPrice) {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: cacheKey)
            UserDefaults.standard.set(Date(), forKey: cacheTimeKey)
        }
    }
}
