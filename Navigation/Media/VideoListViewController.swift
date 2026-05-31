//
//  VideoListViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 29.05.2026.
//

import UIKit
class VideoListViewController: UIViewController {
    
    private struct Video {
        let title: String
        let youtubeID: String
    }
    
    private let videos: [Video] = [
        Video(title: "Video 1", youtubeID: "aqz-KE-bpKQ"),
        Video(title: "Video 2", youtubeID: "psuRGfAaju4"),
        Video(title: "Video 3", youtubeID: "0Fpyl88vDcA"),
        Video(title: "Video 4", youtubeID: "VQKMoT-6XSg"),
    ]
    
    //MARK: - Subviews
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Videos"
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

}

extension VideoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = videos[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let video = videos[indexPath.row]
        let playerVC = VideoPlayerViewController(youtubeID: video.youtubeID)
        navigationController?.pushViewController(playerVC, animated: true)
    }
}
