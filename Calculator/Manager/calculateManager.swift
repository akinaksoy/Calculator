//
//  calculateManager.swift
//  Calculator
//
//  Created by Akın Aksoy on 31.05.2022.
//

import Foundation
struct calculateManager {
    
    static let shared = calculateManager()
    let sign = Enums.Sign.self
    let numbers = Enums.Numbers.self
    
    func calculate(calculatorModel : Calculator) -> Calculator{
        var calculator = calculatorModel
        guard let result = Float(calculator.resultText) else {return calculator}
        calculator.secondValue = result
        switch calculator.currentSign {
        case sign.Divide.rawValue:
            calculator.firstValue = calculator.firstValue / calculator.secondValue
        case sign.multiply.rawValue:
            calculator.firstValue = calculator.firstValue * calculator.secondValue
        case sign.Minus.rawValue:
            calculator.firstValue = calculator.firstValue - calculator.secondValue
        case sign.Plus.rawValue:
            calculator.firstValue = calculator.firstValue + calculator.secondValue
        default:
            return calculator
        }
        calculator.storageValue = calculator.secondValue
        calculator.secondValue = 0
        // if value more than 10 character, convert value to scentificStyle(4,xxxe+16)
        if String(calculator.firstValue).count > 10 {
            guard let firstValueWithScentific = Float(calculator.firstValue.CleanDecimalZero)?.ScentificStyle else {return calculator}
            calculator.resultText = String(firstValueWithScentific)
        }else{
            calculator.resultText = String(calculator.firstValue.CleanDecimalZero)
        }
        return calculator
    }
    func clearAll(calculatorModel : Calculator)-> Calculator{
        var calculator = calculatorModel
        calculator.resultText = "0"
        calculator.firstValue = 0
        calculator.secondValue = 0
        calculator.storageValue = 0
        return calculator
    }
    func resultTextIsZero(calculatorModel : Calculator)-> Bool{
        switch calculatorModel.resultText {
        case numbers.Zero.rawValue :
            return true
        default:
            return false
        }
    }
    func checkCharacterLimitEnteredValue(valueToCheck : String) -> String{
        var newValue = valueToCheck
        if newValue.contains(".") == true{
            if newValue.count > 10 {
                newValue.removeLast()
            }
        }else {
            if newValue.count > 9 {
                newValue.removeLast()
            }
        }
        return newValue
    }
}
