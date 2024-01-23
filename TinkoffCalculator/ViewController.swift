//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Илья on 21/01/24.
//

import UIKit

class ViewController: UIViewController {
    
    

    @IBOutlet weak var labelText: UILabel!
    var calculations:[Calculation] = []
    let calculationHistoryStorage = CalculationHistoryStorage()
    private let alertView: AlertView = {
        let screenBounds = UIScreen.main.bounds
        let alertHeight: CGFloat = 100
        let alertWight = screenBounds.width - 40
        let x:CGFloat = screenBounds.width/2 - alertWight/2
        let y:CGFloat = screenBounds.height/2 - alertHeight/2
        let alertFrame = CGRect(x: x, y: y, width: alertWight, height: alertHeight)
        let alertView = AlertView(frame: alertFrame)
        return alertView
    }()
    
    
    @IBAction func buttonPrassed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else{return}
        if labelText.text?.contains(".") == true && buttonText == "."{return}
        
        print(buttonText)
        if labelText.text == "0"{
            labelText.text = buttonText
        } else {
            labelText.text?.append(buttonText)
        }
        
        if labelText.text == "3.141592"{
            animateAlert()
        }
        
        sender.animateTap()
        
        
    }
    
    @IBAction func operationButtonPrassed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle,
              let buttonOperation = Operation(rawValue: buttonText)
              else {return}
        guard let labeltext = labelText.text,
              let number = numberFormater.number(from: labeltext)?.doubleValue
              else {return}
        
//        labelText.text = buttonText
        
        calculationHistory.append(.numeber(number))
        calculationHistory.append(.operation(buttonOperation))
        
        defaultTextLabel()
    }
    
    @IBAction func buttonResult(_ sender: UIButton) {
        guard let labeltext = labelText.text,
              let number = numberFormater.number(from: labeltext)?.doubleValue
              else {return}
        
        do {
            calculationHistory.append(.numeber(number))
            let result = try calculate()
            labelText.text = numberFormater.string(from: NSNumber(value: result))
            let newCalculation = Calculation(expression: calculationHistory, result: result)
            calculations.append(newCalculation)
            calculationHistoryStorage.setHistory(calculation: calculations)
        } catch {
            labelText.text = "Error"
            labelText.shake()
        }
    }
    @IBAction func buttonClear(_ sender: UIButton) {
        calculationHistory.removeAll()
        defaultTextLabel()
    }
    
    
    var calculationHistory:[CalculationItem] = []
    
    enum Operation: String, Codable {
        case add = "+"
        case substract = "-"
        case multiply  = "x"
        case devide = "/"
        
        
        func calculate(_ a: Double, _ b: Double) throws -> Double{
            switch self{
            case .add:
                return a + b
            case .substract:
                return a - b
            case .devide:
                if b == 0 { throw CalculationError.devideByZero}
                return a/b
            case .multiply:
                return a*b
            }
        }
        
    }
    
    enum CalculationItem: Codable{
        case numeber(Double)
        case operation(Operation)
    }
    
    
    enum CalculationError: Error{
        case devideByZero
        
    }
    
    
    lazy var numberFormater: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "en_US")
        
        return numberFormatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        defaultTextLabel()
        
        calculations = calculationHistoryStorage.loadHistory()
        view.addSubview(alertView)
        alertView.alpha = 0
        alertView.alertText = "Вы нашли пасхалку!"
        view.subviews.forEach {
            if type(of: $0)  == UIButton.self {
                $0.layer.cornerRadius = 0
            }
        }
    }

    
    
    func calculate() throws  ->  Double {
        guard case CalculationItem.numeber(let firstNumber) = calculationHistory[0] else {return 0}
        
        var currentResult = firstNumber
         
        for index in stride(from: 1, through: calculationHistory.count - 1 , by: 2){
            guard
                case .operation(let operation) = calculationHistory[index],
                case .numeber(let number) = calculationHistory[index + 1]
            else{break}
            
            
            currentResult = try operation.calculate(currentResult, number)
        }
        
        return currentResult
    }

    func defaultTextLabel() {
        labelText.text = "0"
    }
    
    
// Навигация
//    Сегвеии
//    @IBAction func unwindAction (inwindSeque: UIStoryboardSegue){
//        
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard segue.identifier == "CALCULATION_LIST",
//              let calculationListVC = segue.destination as? CalculationListViewController else {return}
//        calculationListVC.result  = labelText.text
//    }
    
    
//    Навигация через код
    
     
    @IBAction func showCalculateList(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let calculateLicVC = sb.instantiateViewController(withIdentifier: "CalculationListController")
        
        if let secondVC = calculateLicVC as? CalculationListViewController {
            secondVC.calculations = calculations
        }
        
        show(calculateLicVC, sender: self)
        
    }
    
    func animateAlert(){
        UIView.animate(withDuration: 0.5) {
            self.alertView.alpha = 1
        } completion: { (_) in
            UIView.animate(withDuration: 0.5) {
                var newCenter = self.labelText.center
                newCenter.y -= self.alertView.bounds.height
                self.alertView.center = newCenter
            }
        }
    }
}

extension UILabel {
    func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.5
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 5, y: center.y ))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + 5, y: center.y ))
        
        layer.add(animation, forKey: "position")
    }
}


extension UIButton {
    func animateTap(){
        let scaleAnimation  = CAKeyframeAnimation(keyPath: "tranform.scale")
        scaleAnimation.values = [1,0.9,1]
        scaleAnimation.keyTimes = [0,0.2,1]
        
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.values = [0.4, 0.8, 1]
        opacityAnimation.keyTimes = [0, 0.2, 1]
        
        let animationGroup =  CAAnimationGroup()
        animationGroup.duration  = 1.5
        animationGroup.animations = [scaleAnimation, opacityAnimation]
        
        layer.add(animationGroup, forKey: "groupAnimation")
    }
}

