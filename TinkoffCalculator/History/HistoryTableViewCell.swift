//
//  HistoryTableViewCell.swift
//  TinkoffCalculator
//
//  Created by Булат Камалетдинов on 29.01.2024.
//

import Foundation
import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var operationLabel: UILabel!
    @IBOutlet weak var resultLable: UILabel!
    
    func configure(with expression: String, result: String) {
        operationLabel.text = expression
        resultLable.text = result
    }
}
