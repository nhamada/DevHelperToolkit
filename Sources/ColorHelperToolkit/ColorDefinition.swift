//
//  ColorDefinition.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/09/05.
//
//

struct ColorDefinition {
    let name: String
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
    
    init(name: String, red: Double, green: Double, blue: Double, alpha: Double) {
        self.name = name
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    init(name: String, colorValue: ColorValue) {
        self.init(name: name, red: colorValue.red, green: colorValue.green, blue: colorValue.blue, alpha: colorValue.alpha)
    }
}
