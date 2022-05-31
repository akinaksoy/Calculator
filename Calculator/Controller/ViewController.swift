//
//  ViewController.swift
//  Calculator
//
//  Created by Akın Aksoy on 22.05.2022.
//

import UIKit

class ViewController: UIViewController {

    private var calculator = Calculator()
    let sign = Enums.Sign.self
    let numbers = Enums.Numbers.self
    //MARK: IBOutlet
    @IBOutlet weak var ResultLabel: UILabel!
    @IBOutlet weak var divideSignButton: UIButton!
    @IBOutlet weak var multiplySignButton: UIButton!
    @IBOutlet weak var subtractionSignButton: UIButton!
    @IBOutlet weak var additionSignButton: UIButton!
    @IBOutlet weak var equalSignButton: UIButton!
    
    //MARK: IBActions
    @IBAction func numberOnClicked(_ sender: UIButton) {
        let number = sender.currentTitle!
        if resultTextIsZero() == true || buttonsIsSelected() == true  || calculator.equalClicked != false{
            // if the above conditions are met, delete the number on the screen and write a new one
            calculator.resultText = "\(number)"
            setButtonsIsSelectedFalse()
        }else {
            // If the above conditions are not met, add a new number to the end of the number on the screen.
            calculator.resultText = "\(calculator.resultText)\(number)"
        }
        calculator.resultText = checkCharacterLimitEnteredValue(valueToCheck: calculator.resultText)
        // if a new number is entered after clicking equals, deactivate clicking equals
        if calculator.equalClicked != false {calculator.equalClicked = false}
        calculator.isTypedNewNumber = true
        updateUI()
    }
    
    @IBAction func dotButtonOnClicked(_ sender: UIButton) {
        let character = "."
        if calculator.resultText.contains(character) != true {
            setButtonsIsSelectedFalse()
            calculator.resultText = "\(calculator.resultText)\(character)"
        }
        if calculator.equalClicked != false {
            calculator.resultText = "0."
            calculator.equalClicked = false
        }
        updateUI()
    }
    
    
    @IBAction func ResetOnClicked(_ sender: UIButton) {
        clearAll()
        updateUI()
    }
    
    @IBAction func deleteOnClicked(_ sender: UIButton) {
        if calculator.resultText.contains("e"){
            clearAll()
        }else {
            // If delete all characters , result text return 0
            if resultTextIsZero() == true || calculator.resultText.count == 1{
                calculator.resultText = "0"
            }else{
                calculator.resultText.removeLast()
                if calculator.resultText.last == "."{
                    calculator.resultText.removeLast()
                }
             }
            // Update storage and first values
            if calculator.firstValue == calculator.storageValue {
                guard let storageValue = Float(calculator.resultText) else {return}
                calculator.storageValue = storageValue
            }
            calculator.firstValue = Float(calculator.resultText)!
        }
        updateUI()
    }
    
    @IBAction func getPercentOnClicked(_ sender: UIButton) {
        // if sign buttons are selected, don't get percent of Value
        if buttonsIsSelected() == false {
            guard let result = Float(calculator.resultText) else {return}
            if calculator.firstValue == result{
                calculator.resultText = (result/100).CleanDecimalZero
                calculator.firstValue = result
            }else {
                calculator.resultText = (result/100).CleanDecimalZero
            }
            updateUI()
        }
    }
    
    @IBAction func signButtonOnClicked(_ sender: UIButton) {
        guard let newSign = sender.currentTitle else {return}
        setButtonsIsSelectedFalse()
        
        switch newSign {
        case sign.Plus.rawValue:
            additionSignButton.isSelected = true
            additionSignButton.SetBackgroundColor(.orange, forState: .selected)
        case sign.Minus.rawValue:
            subtractionSignButton.isSelected = true
            subtractionSignButton.SetBackgroundColor(.orange, forState: .selected)
        case sign.Divide.rawValue:
            divideSignButton.isSelected = true
            divideSignButton.SetBackgroundColor(.orange, forState: .selected)
        case sign.multiply.rawValue:
            multiplySignButton.isSelected = true
            multiplySignButton.SetBackgroundColor(.orange, forState: .selected)
        default:
            return
        }
        // If equal is not clicked before this step, calculate with new values
        if calculator.equalClicked == false {
            if calculator.firstValue == 0 {
                // If no value has been entered before , do not calculate . set the entered value as first value
                guard let result = Float(calculator.resultText) else {return}
                calculator.firstValue = result
            }else {
                // Calculate only after typed new numbers.(Don't calculate after clicked equal,percent buttons)
                if calculator.isTypedNewNumber == true {
                    calculate()
                    calculator.isTypedNewNumber = false
                }
            }
        }
        updateUI()
        calculator.currentSign = newSign
    }
    
    @IBAction func equalOnClicked(_ sender: UIButton) {
        calculator.equalClicked = true
        // If there is a storage value, assign it to resulttext for calculate again with screen text.
        if calculator.storageValue != 0 {calculator.resultText = String(calculator.storageValue)}
        if buttonsIsSelected() == true{
            guard let resultLabelText = ResultLabel.text else {return}
            calculator.resultText = resultLabelText
        }
        calculate()
        setButtonsIsSelectedFalse()
        updateUI()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //MARK: General Functions
    func updateUI(){
        ResultLabel.text = calculator.resultText
        if calculator.firstValue == 0 {
          setButtonsIsSelectedFalse()
        }
        // If numbers doesn't fit to result screen(1 line), font size will decrased.
        if ResultLabel.NumberOfVisibleLines > 2 {
            ResultLabel.font = .systemFont(ofSize: 45)
            if ResultLabel.NumberOfVisibleLines > 2 {
                ResultLabel.font = .systemFont(ofSize: 35)
                if ResultLabel.NumberOfVisibleLines > 2 {
                    ResultLabel.font = .systemFont(ofSize: 30)
                }
            }
        } else {
            ResultLabel.font = .systemFont(ofSize: 52)
        }
   }
    func resultTextIsZero()-> Bool{
        switch calculator.resultText {
        case numbers.Zero.rawValue :
            return true
        default:
            return false
        }
    }
    func clearAll() {
        calculator.resultText = "0"
        calculator.firstValue = 0
        calculator.secondValue = 0
        calculator.storageValue = 0
    }
    func setButtonsIsSelectedFalse() {
        additionSignButton.isSelected = false
        additionSignButton.SetBackgroundColor(UIColor(named: "ButtonColor")!, forState: .normal)
        subtractionSignButton.isSelected = false
        subtractionSignButton.SetBackgroundColor(UIColor(named: "ButtonColor")!, forState: .normal)
        multiplySignButton.isSelected = false
        multiplySignButton.SetBackgroundColor(UIColor(named: "ButtonColor")!, forState: .normal)
        divideSignButton.isSelected = false
        divideSignButton.SetBackgroundColor(UIColor(named: "ButtonColor")!, forState: .normal)
    }
    
    func buttonsIsSelected()-> Bool {
        if additionSignButton.isSelected == true || subtractionSignButton.isSelected == true || multiplySignButton.isSelected == true ||  divideSignButton.isSelected == true {
            return true
        }else {
            return false
        }
    }
    
    func calculate(){
        guard let result = Float(calculator.resultText) else {return}
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
            return
        }
        calculator.storageValue = calculator.secondValue
        calculator.secondValue = 0
        // if value more than 10 character, convert value to scentificStyle(4,xxxe+16)
        if String(calculator.firstValue).count > 10 {
            guard let firstValueWithScentific = Float(calculator.firstValue.CleanDecimalZero)?.ScentificStyle else {return}
            calculator.resultText = String(firstValueWithScentific)
        }else{
            calculator.resultText = String(calculator.firstValue.CleanDecimalZero)
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
