//
//  CustomButton.swift
//  Navigation
//
//  Created by Sasha Soldatov on 05.05.2026.
//
import UIKit

class CustomButton: UIButton {
    

    private var tapAction: (() -> Void)?
    init(
        title: String,
        titleColor: UIColor = .white,
        backgroundColor: UIColor? = nil,
        backgroundImage: UIImage? = nil,
        cornerRadius: CGFloat = 10,
        font: UIFont = .systemFont(ofSize: 18, weight: .semibold),
        tapAction: (() -> Void)? = nil) {
            super.init(frame: .zero)
            setTitle(title, for: .normal)
            setTitleColor(titleColor, for: .normal)
            titleLabel?.font = font
            if let backgroundColor = backgroundColor {
                self.backgroundColor = backgroundColor
            }
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
            translatesAutoresizingMaskIntoConstraints = false
            
            self.tapAction = tapAction
            addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonTapped() {
        tapAction?()
    }
}
