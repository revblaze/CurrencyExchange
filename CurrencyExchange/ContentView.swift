//
//  ContentView.swift
//  CurrencyExchange
//
//  Created by Justin Bush on 7/3/23.
//

import SwiftUI

struct ContentView: View {
  
  let currencyOptions = [
    "AED", "ALL", "ARS", "AUD", "BAM", "BGN", "BHD", "BND", "BRL", "CAD", "CHF", "CLP", "CNY", "COP", "CZK", "DKK",
    "DZD", "EUR", "GBP", "HKD", "HUF", "IDR", "ILS", "INR", "IRR", "ISK", "JPY", "KRW", "KWD", "KZT", "LKR", "MAD", "MKD", "MUR",
    "MXN", "MYR", "NOK", "NPR", "NZD", "OMR", "PEN", "PHP", "PKR", "PLN", "QAR", "RON", "RSD", "RUB", "SAR", "SEK", "SGD",
    "THB", "TND", "TRY", "TTD", "TWD", "UAH", "USD", "UYU", "VEF", "XDR", "ZAR"
  ]
  
  @State private var selectedCurrencyIndex = 17
  @State private var dateTextField: String = ""
  @State private var resultText: String = ""
  @State private var currentExchangeRateValue: String = ""
  
  func printExchangeRate(currency: String, onDate: String) {
    if let rate = getUsdRate(currency: currency, onDate: onDate) {
      let outputString = "USD exchange rate for \(currency) on \(onDate): \(rate)"
      print(outputString)
      resultText = outputString
      currentExchangeRateValue = rate
    }
  }
  
  var body: some View {
    VStack {
      VStack {
        Picker("Currency", selection: $selectedCurrencyIndex) {
          ForEach(0..<currencyOptions.count, id: \.self) { index in
            Text(currencyOptions[index])
          }
        }
        .pickerStyle(MenuPickerStyle())
        .frame(maxWidth: .infinity)
      }
      .padding()
      .frame(alignment: .leading)
      
      VStack {
        Text("Date (YYYY-MM-DD)")
          .multilineTextAlignment(.leading)
        TextField("2023-06-22", text: $dateTextField)
          .textFieldStyle(RoundedBorderTextFieldStyle())
      }
      .padding()
      .frame(alignment: .leading)
      
      HStack {
        
        Button(action: {
          let selectedCurrency = currencyOptions[selectedCurrencyIndex]
          
          print("Currency: \(selectedCurrency)")
          print("Date: \(dateTextField)")
          
          printExchangeRate(currency: selectedCurrency, onDate: dateTextField)
        }) {
          Text("Get Conversion Rate")
            .padding()
        }
        .padding()
        
        Button(action: {
          dateTextField = ""
          currentExchangeRateValue = ""
        }) {
          Text("Clear")
            .padding()
        }
        .padding()
        
      }
      .padding()
      
      if !currentExchangeRateValue.isEmpty {
        HStack {
          Text(resultText)
            .multilineTextAlignment(.center)
          Button(action: {
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.setString(currentExchangeRateValue, forType: .string)
          }) {
            Image(systemName: "doc.on.clipboard")
          }
        }
      }
    }
    .padding()
    .frame(minWidth: 410, maxWidth: .infinity, minHeight: 350, maxHeight: .infinity)
    .frame(maxWidth: 450, maxHeight: 500) // Set maximum width and height
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
