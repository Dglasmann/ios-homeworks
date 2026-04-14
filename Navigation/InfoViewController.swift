//
//  InfoViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 22.02.2026.
//

import UIKit

class InfoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        let button = UIButton(type: .system)
        button.setTitle("Показать Alert", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
                    button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ])
    }
        
        @objc private func showAlert() {
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

