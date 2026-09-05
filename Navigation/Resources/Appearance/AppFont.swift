//
//  AppFont.swift
//  Navigation
//
//  Created by Sasha Soldatov on 05.09.2026.
//  Типографика приложения. Все шрифты только отсюда
//

import UIKit

enum AppFont {
    
    static let sectionTitle = scaled(.systemFont(ofSize: 25, weight: .bold), style: .title2)
    
    static let userName = scaled(.systemFont(ofSize: 18, weight: .bold), style: .headline)

    static let postAuthor = scaled(.systemFont(ofSize: 20, weight: .bold), style: .title3)
    
    static let body = scaled(.systemFont(ofSize: 14, weight: .regular), style: .subheadline)
    
    static let counter = scaled(.systemFont(ofSize: 16, weight: .regular), style: .callout)
    
    static let textField = scaled(.systemFont(ofSize: 16, weight: .regular), style: .callout)
    
    static let button = scaled(.systemFont(ofSize: 18, weight: .semibold), style: .headline)
    
    static let caption = scaled(.systemFont(ofSize: 14, weight: .semibold), style: .caption1)
    
    private static func scaled(_ font: UIFont, style: UIFont.TextStyle) ->  UIFont {
       UIFontMetrics(forTextStyle: style).scaledFont(for: font)
    }
}
