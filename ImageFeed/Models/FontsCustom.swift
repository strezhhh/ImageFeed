//
//  FontsCustom.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 27.09.2026.
//

import UIKit

// Структура стиля шрифтов
struct LabelFontStyle {
    let font: UIFont
    let color: UIColor
    let kern: CGFloat
}


// Кастомные шрифты
struct Fonts {
    static let nameFontSF23Regular = LabelFontStyle (
        font: .systemFont(ofSize: 23),
        color: .ypWhite,
        kern: -0.08
    )
    
    static let usernameFontSF13RegularYPWhite50 = LabelFontStyle (
        font: .systemFont(ofSize: 13),
        color: .ypWhiteAlpha50,
        kern: 0
    )
    
    static let statusFontSF13RegularYPWhite = LabelFontStyle (
        font: .systemFont(ofSize: 13),
        color: .ypWhite,
        kern: 0
    )
    
    static let screenFontSF17BoldYPBlack = LabelFontStyle (
        font: .boldSystemFont(ofSize: 17),
        color: .ypBlack,
        kern: 0
    )
}
