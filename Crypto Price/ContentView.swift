//
//  ContentView.swift
//  Crypto Price
//
//  Created by Anshul Kanwar on 28/10/22.
//

import SwiftUI

struct PriceChangePercentView: View {
    var priceChangePercent: Float
    
    var body: some View {
        HStack {
            
            if priceChangePercent >= 0 {
                Image(systemName: "arrowtriangle.up.fill")
                    .foregroundColor(.green)
            } else {
                Image(systemName: "arrowtriangle.down.fill")
                    .foregroundColor(.red)
            }
            
            Text(String(priceChangePercent) + "%")
        }
        .font(.title2)
    }
}

struct ContentView: View {
    @State private var text = ""
    @State var response: ResponseBody?
    @State private var isError: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                TextField("Enter Symbol", text: $text)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                
                if isError {
                    Text("An error occured. Make sure the symbol is correct")
                        .multilineTextAlignment(.center)
                } else {
                    if let response = response {
                        HStack {
                            Text("$" + String(format: "%.2f", response.price))
                                .font(.largeTitle)
                            
                            Spacer()
                            
                            PriceChangePercentView(priceChangePercent: response.priceChangePercent)
                        }
                        .frame(width: 300)
                    }
                }
            }
            
            Spacer()
            
            Button("Fetch") {
                Task {
                    do {
                        response = try await getPrice(symbol: text)
                        isError = false
                    } catch {
                        isError = true
                    }
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(height: 200)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
