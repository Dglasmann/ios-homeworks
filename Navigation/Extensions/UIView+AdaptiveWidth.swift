//
//  UIView+AdaptiveWidth.swift
//  Navigation
//
//  Created by Sasha Soldatov on 05.09.2026.
//  Ограничивает ширину контента на широких экранах (iPad или ландшафт),
//  оставляя его по центру.
//

import UIKit

extension UIView {
    
    func constrainWidth(
        to container: UIView,
        inset: CGFloat = AppLayout.spacing,
        maxWidth: CGFloat = AppLayout.maxContentWidth
    ) {
        let width = widthAnchor.constraint(equalToConstant: maxWidth)
        width.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: inset),
            trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -inset),
            centerXAnchor.constraint(equalTo: container.centerXAnchor)
            
        ])
    }
}
