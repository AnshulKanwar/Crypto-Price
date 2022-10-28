//
//  ModelData.swift
//  Crypto Price
//
//  Created by Anshul Kanwar on 28/10/22.
//

import Foundation

func getPrice(symbol: String) async throws -> ResponseBody {
    guard let url = URL(string: "https://api.binance.com/api/v3/ticker/24hr?symbol=\(symbol)") else {
        fatalError("Missing URL")
    }
    
    let urlRequest = URLRequest(url: url)
    
    let (data, _) = try await URLSession.shared.data(for: urlRequest)
    
    let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
    
    return decodedData
}

struct ResponseBody: Decodable {
    var symbol: String
    var price: Float
    var priceChangePercent: Float
    
    enum CodingKeys: CodingKey {
        case symbol
        case lastPrice
        case priceChangePercent
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.symbol = try container.decode(String.self, forKey: .symbol)
        
        let priceString = try container.decode(String.self, forKey: .lastPrice)
        self.price = Float(priceString)!
        
        let priceChangePercentString = try container.decode(String.self, forKey: .priceChangePercent)
        self.priceChangePercent = Float(priceChangePercentString)!
    }
}
