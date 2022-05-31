//
//  Extensions.swift
//  Calculator
//
//  Created by Akın Aksoy on 31.05.2022.
//

import Foundation
import UIKit


extension Float {
    var CleanDecimalZero: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    struct number {static var formatter = NumberFormatter()}
    
    var ScentificStyle: String {
        number.formatter.numberStyle = .scientific
        number.formatter.positiveFormat = "0.#########E+0"
        number.formatter.exponentSymbol = "e"
        let numberType = NSNumber(value: self)
        return number.formatter.string(from :numberType) ?? ""
    }
}
extension UILabel {
    var NumberOfVisibleLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let textHeight = sizeThatFits(maxSize).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}
extension UIButton {
  func SetBackgroundColor(_ color: UIColor, forState controlState: UIControl.State) {
    let colorImage = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { _ in
      color.setFill()
      UIBezierPath(rect: CGRect(x: 0, y: 0, width: 1, height: 1)).fill()
    }
    setTitleColor(.white, for: controlState)
    setBackgroundImage(colorImage, for: controlState)
  }
}
