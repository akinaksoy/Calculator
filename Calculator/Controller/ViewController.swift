//
//  ViewController.swift
//  Calculator
//
//  Created by Akın Aksoy on 22.05.2022.
//

import UIKit

class ViewController: UIViewController {

    var calculator = Calculator()
    
    @IBOutlet weak var ResultLabel: UILabel!
    @IBOutlet weak var divideSignButton: UIButton!
    @IBOutlet weak var multiplySignButton: UIButton!
    @IBOutlet weak var subtractionSignButton: UIButton!
    @IBOutlet weak var additionSignButton: UIButton!
    @IBOutlet weak var equalSignButton: UIButton!
    
    
    @IBAction func numberOnClicked(_ sender: UIButton) {
        let number = sender.currentTitle!
        if resultTextIsZero() == true || buttonsIsSelected() == true  || calculator.equalClicked != false{
            calculator.resultText = "\(number)"
            setButtonsIsSelectedFalse()
        }else {
            calculator.resultText = "\(calculator.resultText)\(number)"
        }
        calculator.resultText = checkEnteredValue(valueToCheck: calculator.resultText)
        if calculator.equalClicked != false {calculator.equalClicked = false}
        calculator.isTypedNewNumber = true
        updateUI()
    }
    
    @IBAction func dotButtonOnClicked(_ sender: UIButton) {
        let character = "."
        if calculator.resultText.contains(".") != true {
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
            if resultTextIsZero() == true || calculator.resultText.count == 1{
                calculator.resultText = "0"
                calculator.firstValue = Float(calculator.resultText)!
            }else{
                calculator.resultText.removeLast()
                if calculator.resultText.last == "."{
                    calculator.resultText.removeLast()
                }
                calculator.firstValue = Float(calculator.resultText)!
            }
        }
        updateUI()
    }
    
    @IBAction func getPercentOnClicked(_ sender: UIButton) {
        calculator.resultText = String(Double(calculator.resultText)!/1000)
        updateUI()
    }
    
    @IBAction func signButtonOnClicked(_ sender: UIButton) {
        let newSign = sender.currentTitle!
        setButtonsIsSelectedFalse()
        
        if newSign == "/" {
            divideSignButton.isSelected = true
        }else if newSign == "X"{
            multiplySignButton.isSelected = true
        }else if newSign == "-"{
            subtractionSignButton.isSelected = true
        }else if newSign == "+"{
            additionSignButton.isSelected = true
        }
        
        if calculator.firstValue == 0 {
            calculator.firstValue = Float(calculator.resultText)!
        }else {
            if calculator.isTypedNewNumber == true {
                calculate()
                calculator.isTypedNewNumber = false
            }
        }
        updateUI()
        calculator.currentSign = newSign
    }
    
    @IBAction func equalOnClicked(_ sender: UIButton) {
        calculator.equalClicked = true
        if calculator.storageValue != 0 {calculator.resultText = String(calculator.storageValue)}
        if buttonsIsSelected() == true{
            calculator.resultText = ResultLabel.text!
        }
        calculate()
        setButtonsIsSelectedFalse()
        updateUI()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateUI(){
        ResultLabel.text = calculator.resultText
        if calculator.firstValue == 0 {
          setButtonsIsSelectedFalse()
        }
        
        if ResultLabel.numberOfVisibleLines > 2 {
            ResultLabel.font = .systemFont(ofSize: 45)
        } else {
            ResultLabel.font = .systemFont(ofSize: 55)
        }
   }
    func resultTextIsZero()-> Bool{
        if calculator.resultText == "0" {
            return true
        }else {
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
        subtractionSignButton.isSelected = false
        multiplySignButton.isSelected = false
        divideSignButton.isSelected = false
    }
    
    func buttonsIsSelected()-> Bool {
        if additionSignButton.isSelected == true || subtractionSignButton.isSelected == true || multiplySignButton.isSelected == true ||  divideSignButton.isSelected == true {
            return true
        }else {
            return false
        }
    }
    
    func calculate(){
        calculator.secondValue = Float(calculator.resultText)!
        if calculator.currentSign == "/" {
            calculator.firstValue = calculator.firstValue / calculator.secondValue
        }else if calculator.currentSign == "X"{
            calculator.firstValue = calculator.firstValue * calculator.secondValue
        }else if calculator.currentSign == "-"{
            calculator.firstValue = calculator.firstValue - calculator.secondValue
        }else if calculator.currentSign == "+"{
            calculator.firstValue = calculator.firstValue + calculator.secondValue
        }
        calculator.storageValue = calculator.secondValue
        calculator.secondValue = 0
        if String(calculator.firstValue).count > 10 {
            calculator.resultText = String(Float(calculator.firstValue.cleanDecimalZero)!.scentificStyle)
        }else{
            calculator.resultText = String(calculator.firstValue.cleanDecimalZero)
        }
        
    }
    
    func checkEnteredValue(valueToCheck : String) -> String{
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

extension Float {
    var cleanDecimalZero: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    struct Number {static var formatter = NumberFormatter()}
    
    var scentificStyle: String {
        Number.formatter.numberStyle = .scientific
        Number.formatter.positiveFormat = "0.#########E+0"
        Number.formatter.exponentSymbol = "e"
        let number = NSNumber(value: self)
        return Number.formatter.string(from :number) ?? ""
    }
}
extension UILabel {
    var numberOfVisibleLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let textHeight = sizeThatFits(maxSize).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}
