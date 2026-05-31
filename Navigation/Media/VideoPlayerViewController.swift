//
//  VideoPlayerViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 29.05.2026.
//

import UIKit
import WebKit

class VideoPlayerViewController: UIViewController {
    
    private let youtubeID: String
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.scrollView.isScrollEnabled = false
        return webView
    }()
    
    init(youtubeID: String) {
        self.youtubeID = youtubeID
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "Player"
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            webView.heightAnchor.constraint(equalTo: webView.widthAnchor, multiplier: 9.0/16.0)
        ])
        
        loadVideo()
    }
    
    private func loadVideo() {
        let embedURL = "https://youtube.com/embed/\(youtubeID)?playsinline=1"
        if let url = URL(string: embedURL) {
            webView.load(URLRequest(url: url))
        }
    }
    
}
