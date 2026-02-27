import Foundation

// Mapeamento de possíveis erros de rede
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkService {
    // Padrão Singleton para usar o mesmo serviço no app todo
    static let shared = NetworkService()
    private init() {}
    
    // Função assíncrona que busca os dados na CoinGecko
    func fetchBitcoinPrice() async throws -> BitcoinData {
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd&include_24hr_change=true"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        // Faz a requisição na internet de forma nativa e assíncrona
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Verifica se o servidor respondeu com sucesso (Status 200)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.noData
        }
        
        // Transforma o JSON no nosso modelo BitcoinData
        do {
            let decodedResponse = try JSONDecoder().decode(CoinGeckoResponse.self, from: data)
            return decodedResponse.bitcoin
        } catch {
            throw NetworkError.decodingError
        }
    }
}
