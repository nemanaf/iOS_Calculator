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
    var expression: String = ""
    var wasJustCalculated: Bool = false
    
    enum Operation {
        case add
        case subtract
        case multiply
        case divide
    }
    
    func formattedValue(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(value))
        } else {
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 10
            formatter.numberStyle = .decimal
            formatter.decimalSeparator = ","
            formatter.usesGroupingSeparator = false
            return formatter.string(from: NSNumber(value: value)) ?? String(value)
        }
    }

    @IBOutlet weak var displayLabel: UILabel!
    
    @IBOutlet weak var expressionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayLabel.adjustsFontSizeToFitWidth = true
        displayLabel.minimumScaleFactor = 0.3
        
        expressionLabel.adjustsFontSizeToFitWidth = true
        expressionLabel.minimumScaleFactor = 0.5
        }
    
    func setOperation(_ operation: Operation) {
        firstTitle = currentTitle
        currentOperation = operation
        isTypingNumber = false
    }
    
    func stringForCalculation(_ str: String) -> String {
        return str.replacingOccurrences(of: ",", with: ".")
    }
    
    func calculate() {
        let firstValueStr = stringForCalculation(firstTitle)
        let secondValueStr = stringForCalculation(currentTitle)
        if let firstValue = Double(firstValueStr),
           let secondValue = Double(secondValueStr),
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
            let formatted = formattedValue(result)
            currentTitle = formatted
            displayLabel.text = formatted
            currentOperation = nil
            isTypingNumber = false
        }
    }

    @IBAction func actionButton(_ sender: UIButton) {
        
        let haptic = UIImpactFeedbackGenerator(style: .light)
        haptic.impactOccurred()
        
        guard let title = sender.currentTitle else { return }
        
        if "0"..."9" ~= title {
            if wasJustCalculated {
                currentTitle = title
                expression = title
                wasJustCalculated = false
                isTypingNumber = true
            } else if isTypingNumber {
                currentTitle += title
                expression += title
            } else {
                currentTitle = title
                expression += title
                isTypingNumber = true
            }
            displayLabel.text = currentTitle
            expressionLabel.text = expression
            return
        }
        
        switch title {
        case "+", "–", "×", "÷":
            if wasJustCalculated {
                expression = currentTitle
                wasJustCalculated = false
            }
            setOperation(title == "+" ? .add :
                            title == "–" ? .subtract :
                            title == "×" ? .multiply : .divide)
            if let last = expression.last, "+–×÷".contains(last) {
                expression.removeLast()
            }
            expression += title
            expressionLabel.text = expression
        case "=":
            calculate()
            expressionLabel.text = "\(expression) = \(displayLabel.text ?? "")"
            wasJustCalculated = true
        case "C":
            if wasJustCalculated {
                currentTitle = "0"
                expression = ""
                isTypingNumber = false
                wasJustCalculated = false
            } else if currentTitle.count > 1 {
                currentTitle.removeLast()
                if !expression.isEmpty {
                    expression.removeLast()
                }
            } else {
                if !expression.isEmpty {
                    expression.removeLast()
                }
                currentTitle = "0"
                isTypingNumber = false
            }
            displayLabel.text = currentTitle
            expressionLabel.text = expression
        case "AC":
            currentTitle = "0"
            firstTitle = ""
            currentOperation = nil
            isTypingNumber = false
            expression = ""
            displayLabel.text = currentTitle
            expressionLabel.text = expression
            wasJustCalculated = false
        case "%":
            let valueStr = stringForCalculation(currentTitle)
            if let value = Double(valueStr) {
                let percentage = value / 100
                let formatted = formattedValue(percentage)
                currentTitle = formatted
                displayLabel.text = formatted
                isTypingNumber = false
            }
        case "±":
            let valueStr = stringForCalculation(currentTitle)
            if let value = Double(valueStr) {
                let toggled = -value
                let formatted = formattedValue(toggled)
                currentTitle = formatted
                displayLabel.text = formatted
                isTypingNumber = true
            }
        case ",", ".":
            if !currentTitle.contains(",") {
                if !isTypingNumber || currentTitle == "0" {
                    currentTitle = "0,"
                    expression += "0,"
                    isTypingNumber = true
                } else {
                    currentTitle += ","
                    expression += ","
                }
                displayLabel.text = currentTitle
                expressionLabel.text = expression
            }
        default:
            break
        }
    }
}
