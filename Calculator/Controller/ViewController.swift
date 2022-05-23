//
//  ViewController.swift
//  Calculator
//
//  Created by Akın Aksoy on 22.05.2022.
//

import UIKit

class ViewController: UIViewController {

    var value1 : Float = 0
    var value2 : Float = 0
    var previousValue : Float = 0
    var result : Float = 0
    var resultText : String = "0"
    var currentSign : String = ""
    var isTypedNewNumber = false
    var equalClicked = false
    
    @IBOutlet weak var ResultLabel: UILabel!
    @IBOutlet weak var divideSignButton: UIButton!
    @IBOutlet weak var multiplySignButton: UIButton!
    @IBOutlet weak var subtractionSignButton: UIButton!
    @IBOutlet weak var additionSignButton: UIButton!
    @IBOutlet weak var equalSignButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateUI(){
        ResultLabel.text = resultText
        if value1 == 0 {
          setButtonsIsSelectedFalse()
        }
        
    }
    func resultTextIsZero()-> Bool{
        if resultText == "0" {
            return true
        }else {
            return false
        }
    }
    func clearAll() {
        resultText = "0"
        value1 = 0
        value2 = 0
        previousValue = 0
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
        if currentSign == "/" {
            value2 = Float(resultText)!
            value1 = value1 / value2
        }else if currentSign == "X"{
            value2 = Float(resultText)!
            value1 = value1 * value2
        }else if currentSign == "-"{
            value2 = Float(resultText)!
            value1 = value1 - value2
        }else if currentSign == "+"{
            value2 = Float(resultText)!
            value1 = value1 + value2
        }
        previousValue = value2
        value2 = 0
        if String(value1).count > 10 {
            resultText = String(Float(value1.cleanZero)!.scentificStyle)
        }else{
            resultText = String(value1.cleanZero)
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
    
 
    @IBAction func numberOnClicked(_ sender: UIButton) {
        let number = sender.currentTitle!
         if resultTextIsZero() == true || buttonsIsSelected() == true  || equalClicked != false{
            resultText = "\(number)"
            setButtonsIsSelectedFalse()
        }else {
            resultText = "\(resultText)\(number)"
        }
        resultText = checkEnteredValue(valueToCheck: resultText)
        if equalClicked != false {equalClicked = false}
        isTypedNewNumber = true
        updateUI()
    }
    
    @IBAction func dotButtonOnClicked(_ sender: UIButton) {
        let character = "."
        if resultText.contains(".") != true {
            setButtonsIsSelectedFalse()
            resultText = "\(resultText)\(character)"
         }
        if equalClicked != false {
            resultText = "0."
            equalClicked = false
        }
        updateUI()
    }
    

    @IBAction func ResetOnClicked(_ sender: UIButton) {
        clearAll()
        updateUI()
    }
    
    @IBAction func deleteOnClicked(_ sender: UIButton) {
        if resultText.contains("e"){
            clearAll()
        }else {
            if resultTextIsZero() == true || resultText.count == 1{
                resultText = "0"
                value1 = Float(resultText)!
            }else{
                resultText.removeLast()
                if resultText.last == "."{
                    resultText.removeLast()
                }
                value1 = Float(resultText)!
            }
        }
       
        updateUI()
    }
    
    @IBAction func getPercentOnClicked(_ sender: UIButton) {
        resultText = String(Double(resultText)!/1000)
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
        
        if value1 == 0 {
            value1 = Float(resultText)!
        }else {
            if isTypedNewNumber == true {
                calculate()
                isTypedNewNumber = false
            }
            
        }
        updateUI()
        currentSign = newSign
    }
    
    @IBAction func equalOnClicked(_ sender: UIButton) {
        setButtonsIsSelectedFalse()
        equalClicked = true
        if previousValue != 0 {resultText = String(previousValue)}
        calculate()
        updateUI()
    }
    
    
   
}

extension Float {
    var cleanZero: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    struct Number {
            static var formatter = NumberFormatter()
        }
    var scentificStyle: String {
        Number.formatter.numberStyle = .scientific
        Number.formatter.positiveFormat = "0.#########E+0"
        Number.formatter.exponentSymbol = "e"
        let number = NSNumber(value: self)
        return Number.formatter.string(from :number) ?? ""
    }
}
