//
//  Calculator.swift
//  Calculator
//
//  Created by Akın Aksoy on 24.05.2022.
//

import Foundation

struct Calculator {
    var firstValue : Float = 0
    var secondValue : Float = 0
    var storageValue : Float = 0
    var result : Float = 0
    var resultText : String = "0"
    var currentSign : String = ""
    var isTypedNewNumber = false
    var equalClicked = false
}
