//
//  ViewController.swift
//  iOS_Calculator
//
//  Created by Manaf A. on 31.05.25.
//

import UIKit

class ViewController: UIViewController {
    
    var currentTitle: String = "0"
    var firstTitle: String = ""
    var currentOperation: Operation? = nil
    var isTypingNumber: Bool = false
    
    enum Operation {
        case add
        case subtract
        case multiply
        case divide
    }

    @IBOutlet weak var displayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayLabel.text = "0"
        }
    
    func setOperation(_ operation: Operation) {
        firstTitle = currentTitle
        currentOperation = operation
        isTypingNumber = false
    }
    
    func calculate() {
        if let firstValue = Double(firstTitle),
           let secondValue = Double(currentTitle),
           let operation = currentOperation {
            
            var result: Double = 0
            
            switch operation {
            case .add:
                result = firstValue + secondValue
            case .subtract:
                result = firstValue - secondValue
            case .multiply:
                result = firstValue * secondValue
            case .divide:
                guard secondValue != 0 else {
                    displayLabel.text = "Error: Division by zero"
                    currentTitle = "0"
                    currentOperation = nil
                    isTypingNumber = false
                    return
                }
                result = firstValue / secondValue
            }
            displayLabel.text = String(result)
            currentTitle = String(result)
            currentOperation = nil
            isTypingNumber = false
        }
    }

    @IBAction func actionButton(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        
        if "0"..."9" ~= title {
            if isTypingNumber {
                currentTitle += title
            } else {
                currentTitle = title
                isTypingNumber = true
            }
            displayLabel.text = currentTitle
            return
        }
        
        switch title {
        case "+": setOperation(.add)
        case "-": setOperation(.subtract)
        case "×": setOperation(.multiply)
        case "÷": setOperation(.divide)
        case "=": calculate()
        case "C":
            if currentTitle.count > 1 {
                currentTitle.removeLast()
            } else {
                currentTitle = "0"
                isTypingNumber = false
            }
            displayLabel.text = currentTitle
        default:
            break
        }
    }
}
