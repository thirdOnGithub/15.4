//
//  Storage.swift
//  TinkoffCalculator
//
//  Created by Илья on 23/01/24.
//

import Foundation

struct Calculation {
//    var calculations:[(
    let expression: [ViewController.CalculationItem]
    let  result: Double
    
}



extension Calculation: Codable{}

extension ViewController.CalculationItem {
    enum CodingKeys: String, CodingKey{
        case number
        case operation
    }
    
    func encode(to encoder: Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .numeber(let value):
            try container.encode(value, forKey: CodingKeys.number)
        case .operation(let value):
            try container.encode(value.rawValue, forKey: CodingKeys.operation)
        }
    }
    
    enum CalculationItemError: Error {
        case itemNotFound
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let  number = try  container.decodeIfPresent(Double.self, forKey: .number){
            self = .numeber(number)
            return
        }
        
        if let  rawOperation = try container.decodeIfPresent(String.self, forKey: .operation),
           let operation = ViewController.Operation(rawValue: rawOperation){
            self = .operation(operation)
            return
        }
        
        
        throw CalculationItemError.itemNotFound
    }
}
    
    
class CalculationHistoryStorage {
        static let calculationHistoryKey = "calculationHistoryKey"
        
        func setHistory(calculation: [Calculation]){
            if let encoded = try? JSONEncoder().encode(calculation){
                UserDefaults.standard.setValue(encoded, forKey: CalculationHistoryStorage.calculationHistoryKey)
            }
        }
        
        func loadHistory() -> [Calculation]{
            if let  data = UserDefaults.standard.data(forKey: CalculationHistoryStorage.calculationHistoryKey) {
                return (try? JSONDecoder().decode([Calculation].self, from: data)) ?? []
            }
            
            return []
        }
}
    
    

