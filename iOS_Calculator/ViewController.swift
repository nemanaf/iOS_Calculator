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

    @IBAction func actionButton(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
            print("Button pressed: \(title)")
        
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
        case "+":
            firstTitle = currentTitle
            currentOperation = .add
            isTypingNumber = false
        case "-":
            firstTitle = currentTitle
            currentOperation = .subtract
            isTypingNumber = false
        case "×":
            firstTitle = currentTitle
            currentOperation = .multiply
            isTypingNumber = false
        case "÷":
            firstTitle = currentTitle
            currentOperation = .divide
            isTypingNumber = false
        case "=":
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
                    if secondValue == 0 {
                        displayLabel.text = "Error"
                        currentTitle = "0"
                        currentOperation = nil
                        isTypingNumber = false
                        return
                    } else {
                        result = firstValue / secondValue
                    }
                }
                displayLabel.text = String(result)
                currentTitle = String(result)
                currentOperation = nil
                isTypingNumber = false
            }
        default:
            break
        }
    }
}
