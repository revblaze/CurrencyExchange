//
//  getUsdRate.swift
//  CurrencyExchange
//
//  Created by Justin Bush on 7/3/23.
//

import Cocoa
import SQLite

func getUsdRate(currency: String, onDate: String) -> String? {
    // SQLite database path
    guard let dbPath = Bundle.main.path(forResource: "exchange_rates", ofType: "db") else {
        print("Database file not found!")
        return nil
    }
    
    // Create a connection to the SQLite database
    guard let db = try? Connection(dbPath) else {
        print("Failed to connect to the database.")
        return nil
    }
    
    // Table and column names
    let table = Table("exchange_rates")
    let dateColumn = Expression<String>("Date")
    let currencyColumn = Expression<String?>(currency)
    
    // Query the database for the currency value on the specified date
    let query = table.filter(dateColumn == onDate)
    guard let row = try? db.pluck(query) else {
        print("No data found for the specified date.")
        return nil
    }
    
    // Retrieve the currency value for the specified currency code
    guard let rate = row[currencyColumn] else {
        print("Currency value is null for the specified currency code.")
        return nil
    }
    
    // Return the currency value
    return rate
}
