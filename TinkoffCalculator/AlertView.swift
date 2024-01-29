//
//  AlertView.swift
//  TinkoffCalculator
//
//  Created by Булат Камалетдинов on 29.01.2024.
//

import Foundation
import UIKit


class AlertView: UIView {
    
    var alertText: String? {
        didSet {
            label.text = alertText
        }
    }
    
    private let  label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        
        return label
    }()
    
    
    override init (frame: CGRect){
        super.init(frame:frame)
        setupUi()
    }
    
    required init? (coder: NSCoder){
        super.init(coder: coder)
        setupUi()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    func setupUi(){
        addSubview(label)
        backgroundColor = .red
        
        
        let tap = UIGestureRecognizer()
        tap.addTarget(self, action: #selector(hide))
        addGestureRecognizer(tap)
    }
    
    @objc private func hide(){
        removeFromSuperview()
    }
}
