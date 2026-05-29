//
//  AudioPlayerViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 29.05.2026.
//

import UIKit
import AVFoundation

class AudioPlayerViewController: UIViewController {
    private var player: AVAudioPlayer?
    
    private struct Track {
        let fileName: String
        let title: String
    }
    
    private let tracks: [Track] = [
        Track(fileName: "track1", title: "Track 1"),
        Track(fileName: "track2", title: "Track 2"),
        Track(fileName: "track3", title: "Track 3"),
        Track(fileName: "track4", title: "Track 4"),
        Track(fileName: "track5", title: "Track 5"),
    ]
    
    private var currentIndex = 0
    
    //MARK: - Subviews
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .label
        return titleLabel
    }()
    
    private lazy var playPauseButton: CustomButton = {
        CustomButton(
            title: "▶︎ Play",
            backgroundColor: .systemBlue,
            tapAction: {[weak self] in self?.playPauseTapped()
            })
    }()
    
    private lazy var stopButton: CustomButton = {
        CustomButton(
            title: "■ Stop",
            backgroundColor: .systemBlue,
            tapAction: {[weak self] in self?.stopTapped()
            })
    }()
    
    private lazy var previousButton: CustomButton = {
        CustomButton(
            title: "⏮ Prev",
            backgroundColor: .systemBlue,
            tapAction: {[weak self] in self?.previousTapped()
            })
    }()
    
    private lazy var nextButton: CustomButton = {
        CustomButton(
            title: "Next ⏭",
            backgroundColor: .systemBlue,
            tapAction: {[weak self] in self?.nextTapped()
            })
    }()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Audio player"
        setupViews()
        setupConstraints()
        setupAudioSession()
        prepareTrack(at: currentIndex)
    }
    
    
    //MARK: - Setup
    
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(playPauseButton)
        view.addSubview(stopButton)
        view.addSubview(previousButton)
        view.addSubview(nextButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            playPauseButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            playPauseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            playPauseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            playPauseButton.heightAnchor.constraint(equalToConstant: 50),

            stopButton.topAnchor.constraint(equalTo: playPauseButton.bottomAnchor, constant: 16),
            stopButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stopButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stopButton.heightAnchor.constraint(equalToConstant: 50),

            previousButton.topAnchor.constraint(equalTo: stopButton.bottomAnchor, constant: 16),
            previousButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            previousButton.widthAnchor.constraint(equalTo: nextButton.widthAnchor),
            previousButton.heightAnchor.constraint(equalToConstant: 50),

            nextButton.topAnchor.constraint(equalTo: stopButton.bottomAnchor, constant: 16),
            nextButton.leadingAnchor.constraint(equalTo: previousButton.trailingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    
    private func prepareTrack(at index: Int) {
        let track = tracks[index]
        guard let path = Bundle.main.path(forResource: track.fileName, ofType: "mp3") else {
            titleLabel.text = "Файл \(track.fileName) не найден"
            return
        }
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            titleLabel.text = track.title
            updatePlayPauseTitle()
        } catch {
            titleLabel.text = "Ошибка при загрузке трека"
            print(error.localizedDescription)
        }
    }
    
    private func playPauseTapped() {
        guard let player = player else { return }
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
        updatePlayPauseTitle()
        
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session error: \(error.localizedDescription)")
        }
    }
    
    private func stopTapped() {
        guard let player = player else { return }
        player.stop()
        player.currentTime = 0
        updatePlayPauseTitle()
    }
    
    private func previousTapped() {
        currentIndex = (currentIndex - 1 + tracks.count) % tracks.count
        prepareTrack(at: currentIndex)
        player?.play()
        updatePlayPauseTitle()
    }
    
    private func nextTapped() {
        currentIndex = (currentIndex + 1) % tracks.count
        prepareTrack(at: currentIndex)
        player?.play()
        updatePlayPauseTitle()
    }
    
    private func updatePlayPauseTitle() {
        let isPlaying = player?.isPlaying ?? false
        let label = isPlaying ? "Pause" : "▶︎ Play"
        playPauseButton.setTitle(label, for: .normal)
    }
}
