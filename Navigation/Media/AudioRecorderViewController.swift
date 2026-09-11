//
//  AudioRecorderViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 29.05.2026.
//

import UIKit
import AVFoundation

final class AudioRecorderViewController: UIViewController {
    
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
        statusLabel.font = AppFont.counter
        statusLabel.textColor = AppColor.primaryText
        statusLabel.text = L10n.Media.readyToRecord
        return statusLabel
    }()
    
    private lazy var recordButton: CustomButton = {
        CustomButton(
            title: "● \(L10n.Media.record)",
            backgroundColor: .systemRed,
            tapAction: { [weak self] in self?.recordTapped() }
        )
    }()

    private lazy var playButton: CustomButton = {
        let playButton = CustomButton(
            title: "▶︎ \(L10n.Media.playRecording)",
            backgroundColor: AppColor.accent,
            tapAction: { [weak self]  in self?.playTapped() }
        )
        playButton.isEnabled = false
        return playButton
    }()
    
    private lazy var isRecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background
        title = L10n.Media.recorder
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
                    self?.statusLabel.text = L10n.Media.microphoneGranted
                    self?.setupRecorder()
                } else {
                    self?.statusLabel.text = L10n.Media.microphoneDenied
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
            statusLabel.text = L10n.Media.recorderSetupFailed
            print(error.localizedDescription)
        }
    }
    
    private func recordTapped() {
        guard let recorder = recorder else { return }
        if isRecording {
            recorder.stop()
            isRecording = false
            recordButton.setTitle("● \(L10n.Media.record)", for: .normal)
            statusLabel.text = L10n.Media.recordingSaved
            playButton.isEnabled = true
        } else {
            recorder.record()
            isRecording = true
            recordButton.setTitle("■ \(L10n.Media.stopRecording)", for: .normal)
            statusLabel.text = L10n.Media.recording
            playButton.isEnabled = false
        }
    }
    
    private func playTapped() {
        do {
            player = try AVAudioPlayer(contentsOf: recordingURL)
            player?.play()
            statusLabel.text = L10n.Media.playingBack
        } catch {
            statusLabel.text = L10n.Media.nothingToPlay
            print(error.localizedDescription)
        }
    }
}
