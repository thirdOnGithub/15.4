//
//  CalculationListViewController.swift
//  TinkoffCalculator
//
//  Created by Илья on 22/01/24.
//

import UIKit

class CalculationListViewController: UIViewController{
    
    var result: String?
    @IBOutlet weak var calculationLabel: UILabel!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    func initialize(){
        modalPresentationStyle = .fullScreen
        
    }
//    Создание навигаиии между VC через код
    @IBAction func dismissVC(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        guard let result else {return}
        calculationLabel.text = result
        
    }
}
