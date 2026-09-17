//
//  FeedViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 22.02.2026.
//

import UIKit

final class FeedViewController: UIViewController {

    private let viewModel: FeedViewModel

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = AppColor.background
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
        tableView.register(FeedPostCell.self)
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private lazy var errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.font = AppFont.body
        errorLabel.textColor = AppColor.secondaryText
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        return errorLabel
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    @objc private func refresh() {
        viewModel.updateState(viewInput: .refresh)
    }

    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background
        title = L10n.Feed.title
        setupUI()
        bindViewModel()
        viewModel.updateState(viewInput: .viewDidLoad)
    }

    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)
        tableView.refreshControl = refreshControl
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppLayout.spacing),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppLayout.spacing)
            
        ])
    }

    private func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            DispatchQueue.main.async {
                self?.render(state: state)
            }
        }
    }
    
    private func render(state: FeedViewModel.State) {
        switch state {
        case .loading:
            errorLabel.isHidden = true
            if !refreshControl.isRefreshing { activityIndicator.startAnimating() }
        case .loaded:
            activityIndicator.stopAnimating()
            refreshControl.endRefreshing()
            errorLabel.isHidden = true
            tableView.reloadData()
        case .error(let message):
            activityIndicator.stopAnimating()
            refreshControl.endRefreshing()
            errorLabel.text = message
            errorLabel.isHidden = false
        }
    }
}

// MARK: - UITableViewDataSource

extension FeedViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(FeedPostCell.self, for: indexPath)
        guard let post = viewModel.post(at: indexPath.row) else { return cell }
        cell.configure(with: post, isLiked: false, isSaved: viewModel.isSaved(at: indexPath.row))
        cell.onBookmark = { [weak self] in
            self?.viewModel.updateState(viewInput: .toggleSave(index: indexPath.row))
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FeedViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.updateState(viewInput: .openPost(index: indexPath.row))
    }
}
