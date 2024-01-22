//
//  CalculationListViewController.swift
//  TinkoffCalculator
//
//  Created by Илья on 22/01/24.
//

import UIKit

class CalculationListViewController: UIViewController{
    
    @IBOutlet weak var calculationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var calculations:[Calculation] = []
    
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
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let nib = UINib(nibName: "HistoryTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HistoryTableViewCell")
        
    }
    
    private func expressionToString(_ expression: [ViewController.CalculationItem]) -> String{
        var result = ""
        
        for operand in expression {
            switch operand{
            case let.numeber(value):
                result += String(value) + " "
                
            case let.operation(value):
                result +=  value.rawValue + "  "
            }
        }
        
        return result
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.navigationItem.titleView = "История"
        
//        navigationController?.navigationItem.rightBarButtonItem?.title = ""
//        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}




extension CalculationListViewController: UITableViewDataSource, UITableViewDelegate{
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        calculations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        let historyItems = calculations[indexPath.row]
        cell.configure(with: expressionToString(historyItems.expression), result: String(historyItems.result))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    
}
