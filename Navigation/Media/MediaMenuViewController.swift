//
//  MediaMenuViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 29.05.2026.
//
import UIKit

class MediaMenuViewController: UIViewController {
    
    private lazy var audioButton: CustomButton = {
        CustomButton(
            title: "Аудиоплеер",
            backgroundColor: .systemBlue,
            tapAction: {[weak self] in
                self?.navigationController?.pushViewController(
                    AudioPlayerViewController(),
                    animated: true)
            }
        )
    }()
    
    private lazy var videoButton: CustomButton = {
        CustomButton(
            title: "Видеоплеер",
            backgroundColor: .systemBlue,
            tapAction: {[weak self] in
                self?.navigationController?.pushViewController(
                    VideoListViewController(),
                    animated: true)
            }
        )
    }()
    private lazy var recorderButton: CustomButton = {
        CustomButton(
            title: "Запись аудио",
            backgroundColor: .systemBlue,
            tapAction: {[weak self] in
                self?.navigationController?.pushViewController(
                    AudioRecorderViewController(),
                    animated: true)
            }
        )
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Медиа"
        
        let stack = UIStackView(arrangedSubviews: [audioButton, videoButton, recorderButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            audioButton.heightAnchor.constraint(equalToConstant: 60),
            videoButton.heightAnchor.constraint(equalToConstant: 60),
            recorderButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    
}
