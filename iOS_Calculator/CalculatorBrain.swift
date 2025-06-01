//
//  CalculatorBrain.swift
//  iOS_Calculator
//
//  Created by Manaf A. on 01.06.25.
//

import Foundation

struct CalculatorBrain {
    private(set) var display = "0"
    private(set) var expression = ""
    
    private var firstOperand = ""
    private var currentOperand = "0"
    private var pendingOp: Operation?
    private var wasJustCalculated = false
    private let digitLimit = 15
    
    enum Operation: String {
        case add = "+"
        case sub = "-"
        case mul = "×"
        case div = "÷"
    }
    
    mutating func inputDigit(_ d: String) {
        guard "0"..."9" ~= d else { return }
        
        let digits = currentOperand.replacingOccurrences(of: ",", with: "").count
        
        guard digits < digitLimit else { return }
        
        if wasJustCalculated { clearExpression() }
        if currentOperand == "0" && !currentOperand.contains(",") {
            if d == "0" {
                return
            } else {
                currentOperand = d
                if expression.isEmpty || "+-×÷".contains(expression.last!) {
                    expression += d
                } else {
                    expression.removeLast()
                    expression += d
                }
            }
        } else {
            currentOperand += d
            expression     += d
        }
        display = currentOperand
    }
    
    mutating func calculate() {
        guard let op = pendingOp,
              let first  = Double(formatForCalc(firstOperand)),
              let second = Double(formatForCalc(currentOperand))
        else { return }

        if let last = expression.last, "+-×÷".contains(last) {
            expression += currentOperand
        }

        var result: Double = 0
        switch op {
        case .add: result = first + second
        case .sub: result = first - second
        case .mul: result = first * second
        case .div:
            guard second != 0 else { display = "Error"; return }
            result = first / second
        }
        currentOperand      = formattedValue(result)
        display             = currentOperand
        pendingOp           = nil
        wasJustCalculated   = true
    }
    
    mutating func backspace() {
        if wasJustCalculated {
            clearAll()
            return
        }
        
        if currentOperand.count > 1 {
            currentOperand.removeLast()
            if !expression.isEmpty { expression.removeLast() }
        } else {
            currentOperand = "0"
            if !expression.isEmpty { expression.removeLast() }
            if let last = expression.last, "+-×÷".contains(last) {
                expression.removeLast()
                pendingOp = nil
            }
        }
        display = currentOperand
    }
    
    mutating func clearAll() {
        firstOperand = ""
        currentOperand = "0"
        pendingOp = nil
        expression = ""
        display = "0"
        wasJustCalculated = false
    }
    
    private mutating func clearExpression() {
        expression = ""
        currentOperand = "0"
        wasJustCalculated = false
    }
    
    mutating func inputDecimal() {
        if wasJustCalculated { clearExpression() }
        if !currentOperand.contains(",") {
            currentOperand += currentOperand == "0" ? "0," : ","
            expression += currentOperand == ",0" ? "0," : ","
            display = currentOperand
        }
    }
    
    mutating func toggleSign() {
        let oldLen = currentOperand.count

        if currentOperand.hasPrefix("-") {
            currentOperand.removeFirst()
        } else if currentOperand != "0" {
            currentOperand = "-" + currentOperand
        }
        display = currentOperand

        if !expression.isEmpty,
           let last = expression.last,
           ("0123456789,").contains(last) {
            expression.removeLast(oldLen)
            expression += currentOperand
        } else if expression.isEmpty {
            expression = currentOperand
        }
        if wasJustCalculated {
            expression = currentOperand
            wasJustCalculated = false
        }
    }
    
    mutating func percent() {
        guard let val = Double(formatForCalc(currentOperand)) else { return }
        
        let oldLen = currentOperand.count
        
        currentOperand = formattedValue(val / 100)
        display = currentOperand
        
        if !expression.isEmpty,
           let last = expression.last,
           ("0123456789,").contains(last) {
            expression.removeLast(oldLen)
            expression += currentOperand
        } else if expression.isEmpty {
            expression = currentOperand
        }
        if wasJustCalculated {
            expression = currentOperand
            wasJustCalculated = false
        }
    }
    
    mutating func setOperation(_ op: Operation) {
        if wasJustCalculated {
            firstOperand = currentOperand
            expression   = currentOperand
            wasJustCalculated = false
        }
        if expression.last.map({ "+-×÷".contains($0) }) == true {
            expression.removeLast()
        } else {
            firstOperand = currentOperand
        }
        pendingOp = op
        currentOperand = "0"
        expression += op.rawValue
        display = currentOperand
        wasJustCalculated = false
    }

    private func formatForCalc(_ s: String) -> String {
        s.replacingOccurrences(of: ",", with: ".")
    }

    private func formattedValue(_ value: Double) -> String {
        let absValue = abs(value)
        if absValue >= 1e15 || (absValue != 0 && absValue < 1e-15) {
            return makeFormatter(style: .scientific, maxFrac: 6, scientific: true).string(from: NSNumber(value: value)) ?? "\(value)"
        }
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(value))
        } else {
            return makeFormatter(style: .decimal).string(from: NSNumber(value: value)) ?? "\(value)"
        }
    }

    private func makeFormatter(style: NumberFormatter.Style, maxFrac: Int = 10, scientific: Bool = false) -> NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = style
        f.minimumFractionDigits = 0
        f.maximumFractionDigits = maxFrac
        f.decimalSeparator = ","
        f.usesGroupingSeparator = false
        if scientific {
            f.exponentSymbol = "e"
        }
        return f
    }
}
