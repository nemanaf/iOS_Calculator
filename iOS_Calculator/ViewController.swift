//
//  ViewController.swift
//  iOS_Calculator
//
//  Created by Manaf A. on 31.05.25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var expressionLabel: UILabel!
    
    private var brain = CalculatorBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayLabel.adjustsFontSizeToFitWidth = true
        displayLabel.minimumScaleFactor = 0.3
        
        expressionLabel.adjustsFontSizeToFitWidth = true
        expressionLabel.minimumScaleFactor = 0.2
        
        updateUI()
    }
    
    @IBAction func actionButton(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        
        switch title {
        case "0"..."9":
            brain.inputDigit(title)
        case ",":
            brain.inputDecimal()
        case "+":
            brain.setOperation(.add)
        case "-":
            brain.setOperation(.sub)
        case "×":
            brain.setOperation(.mul)
        case "÷":
            brain.setOperation(.div)
        case "=":
            brain.calculate()
        case "%":
            brain.percent()
        case "±":
            brain.toggleSign()
        case "C":
            brain.clearEntry()
        case "AC":
            brain.clearAll()
        default:
            break
        }
        updateUI()
    }
    
    private func updateUI() {
        displayLabel.text = brain.display
        expressionLabel.text = brain.expression
    }
}
