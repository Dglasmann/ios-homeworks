//
//  UIImage+Alpha.swift
//  Navigation
//
//  Created by Sasha Soldatov on 05.09.2026.
//

import UIKit


extension UIImage {
    func withAlpha(_ alpha: CGFloat) -> UIImage {
        
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            draw(at: .zero, blendMode: .normal, alpha: alpha)
        }
        
    }
}
