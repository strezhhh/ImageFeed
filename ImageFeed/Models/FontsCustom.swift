//
//  FontsCustom.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 27.09.2026.
//

import UIKit

// Структура стиля шрифтов
struct labelFontStyle {
    let font: UIFont
    let color: UIColor
    let kern: CGFloat
}


// Кастомные шрифты
struct Fonts {
    static let nameFontSF23Regular = labelFontStyle (
        font: .systemFont(ofSize: 23),
        color: .ypWhite,
        kern: -0.08
    )
    
}
