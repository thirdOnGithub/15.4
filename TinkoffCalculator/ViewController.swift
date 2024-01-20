//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Илья on 21/01/24.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func buttonPrassed(_ sender: UIButton) {
        print("hello")
        guard let buttonText = sender.currentTitle else{return}
        
        
        
        print(buttonText)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("hello")
    }


}

