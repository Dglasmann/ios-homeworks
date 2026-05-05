//
//  InfoViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 22.02.2026.
//

import UIKit

class InfoViewController: UIViewController {
    
    private lazy var alertButton = CustomButton(
        title: "Показать Alert",
        backgroundColor: .systemGreen,
        tapAction: {
            [weak self] in self?.showAlert()
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        
        view.addSubview(alertButton)
        
        NSLayoutConstraint.activate([
                    alertButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    alertButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ])
    }
        
        private func showAlert() {
            let alertController = UIAlertController(
                title: "Внимание!!",
                message: "Это тестовое сообщение",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                print("Вы тыкнули кнопку OK")
            }
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in
                print("Вы тыкнули кнопку Отмена")
            }
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }

