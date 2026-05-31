//
//  AudioRecorderViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 29.05.2026.
//

import UIKit
import AVFoundation

class AudioRecorderViewController: UIViewController {
    
    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?
    
    private lazy var recordingURL: URL = {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return dir.appendingPathComponent("recording.m4a")
    }()
    
    private lazy var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.textAlignment = .center
        statusLabel.font = .systemFont(ofSize: 16)
        statusLabel.text = "Готов к записи"
        return statusLabel
    }()
    
    private lazy var recordButton: CustomButton = {
        CustomButton(
            title: "● Запись",
            backgroundColor: .systemRed,
            tapAction: {[weak self] in self?.recordTapped() }
        )
    }()
    
    private lazy var playButton: CustomButton = {
        let playButton = CustomButton(
            title: "▶︎ Воспроизвести",
            backgroundColor: .systemBlue,
            tapAction: {[weak self]  in self?.playTapped()}
        )
        playButton.isEnabled = false
        return playButton
    }()
    
    private lazy var isRecording = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Recorder"
        setupViews()
        setupConstraints()
        requestMicrophoneAccess()
    }
    
    private func setupViews() {
        view.addSubview(statusLabel)
        view.addSubview(recordButton)
        view.addSubview(playButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            recordButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 40),
            recordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            recordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            recordButton.heightAnchor.constraint(equalToConstant: 50),

            playButton.topAnchor.constraint(equalTo: recordButton.bottomAnchor, constant: 16),
            playButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            playButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            playButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func requestMicrophoneAccess() {
        AVAudioSession.sharedInstance().requestRecordPermission {[weak self] granted in
            DispatchQueue.main.async {
                if granted {
                    self?.statusLabel.text = "Доступ к микрофону разрешен"
                    self?.setupRecorder()
                } else {
                    self?.statusLabel.text = "Доступ к микрофону запрещен"
                    self?.recordButton.isEnabled = false
                }
            }
        }
    }
    
    private func setupRecorder() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
            
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            recorder = try AVAudioRecorder(url: recordingURL, settings: settings)
            recorder?.prepareToRecord()
        } catch {
            statusLabel.text = "Ошибка настройки рекордера"
            print(error.localizedDescription)
        }
    }
    
    private func recordTapped() {
        guard let recorder = recorder else { return }
        if isRecording {
            recorder.stop()
            isRecording = false
            recordButton.setTitle("● Запись", for: .normal)
            statusLabel.text = "Запись сохранена"
            playButton.isEnabled = true
        } else {
            recorder.record()
            isRecording = true
            recordButton.setTitle("■ Остановить запись", for: .normal)
            statusLabel.text = "Идет запись..."
            playButton.isEnabled = false
        }
    }
    
    private func playTapped() {
        do {
            player = try AVAudioPlayer(contentsOf: recordingURL)
            player?.play()
            statusLabel.text = "Воспроизведение..."
        } catch {
            statusLabel.text = "Нечего воспроизводить:("
            print(error.localizedDescription)
        }
    }
}
