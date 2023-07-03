//
//  listCurrencyCodes.swift
//  CurrencyExchange
//
//  Created by Justin Bush on 7/3/23.
//

import SQLite
import Foundation

func listCurrencyCodes() {
    // SQLite database path
    guard let dbPath = Bundle.main.path(forResource: "exchange_rates", ofType: "db") else {
        print("Database file not found!")
        return
    }
    
    // Create a connection to the SQLite database
    guard let db = try? Connection(dbPath) else {
        print("Failed to connect to the database.")
        return
    }
    
    // Execute the PRAGMA statement to retrieve column names
    do {
        let columnNames = try db.prepare("PRAGMA table_info(exchange_rates);").map { row in
            return row[1] as! String
        }
        
        // Filter out the 'Date' column
        let currencyCodes = columnNames.filter { $0 != "Date" }
        
        // Print the currency codes
        print("Currency Codes:")
        for code in currencyCodes {
            print(code)
        }
    } catch {
        print("Error retrieving column names: \(error)")
    }
}

// Call the function to list the currency codes

