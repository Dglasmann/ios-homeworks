//
//  AppColor.swift
//  Navigation
//
//  Created by Sasha Soldatov on 05.09.2026.
//  Единые цвета приложения, все цвета берутся только отсюда
//

import UIKit

enum AppColor {
    
    //MARK: - Main colors
    
    static let accent = UIColor(named: "AccentColor") ?? .systemBlue
    
    /// Фон основной кнопки действия
    static let buttonBackground = UIColor(named: "ButtonBackground") ?? accent
    
    //MARK: - Background
    
    /// Фон экрана (белый/чёрный)
    static let background = UIColor.systemBackground
    
    /// Фон карточек, ячеек и контейнеров полей ввода
    static let secondaryBackground = UIColor.secondarySystemBackground
    
    /// Затемнение
    static let overlay = UIColor.black
    
    
    //MARK: - Text
    
    /// Основной текст
    static let primaryText = UIColor.label
    
    /// Второстепенный текст
    static let secondaryText = UIColor.secondaryLabel
    
    static let textOnAccent = UIColor.white
    
    //MARK: - Others
    
    /// Разделители
    static let separator = UIColor.separator
    
    /// Обводка аватара и полей ввода
    static let border = UIColor.systemGray4
}
