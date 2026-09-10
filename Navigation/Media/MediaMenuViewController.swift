//
//  MediaMenuViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 29.05.2026.
//
import UIKit

class MediaMenuViewController: UIViewController {
    
    weak var coordinator: MediaCoordinator?
    
    private lazy var audioButton: CustomButton = {
        CustomButton(
            title: L10n.Media.audioPlayer,
            backgroundColor: AppColor.accent,
            tapAction: {[weak self] in
                self?.coordinator?.showAudioPlayer()
            }
        )
    }()
    
    private lazy var videoButton: CustomButton = {
        CustomButton(
            title: L10n.Media.videoPlayer,
            backgroundColor: AppColor.accent,
            tapAction: {[weak self] in
                self?.coordinator?.showVideoList()
            }
        )
    }()
    private lazy var recorderButton: CustomButton = {
        CustomButton(
            title: L10n.Media.recorder,
            backgroundColor: AppColor.accent,
            tapAction: {[weak self] in
                self?.coordinator?.showAudioRecorder()
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
