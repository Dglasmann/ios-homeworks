//
//  FavouritesViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 24.06.2026.
//

import UIKit
import CoreData
 
final class FavouritesViewController: UIViewController {
 
    // MARK: - Dependencies
 
    private let viewModel: FavouritesViewModel
 
    // MARK: - Init
 
    init(viewModel: FavouritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    // MARK: - Subviews
 
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostTableViewCell.self)
        return tableView
    }()
 
    /// Показывается вместо таблицы, когда избранное пусто
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = L10n.Favourites.empty
        label.font = AppFont.body
        label.textColor = AppColor.secondaryText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
 
    // MARK: - Lifecycle
 
    override func viewDidLoad() {
        super.viewDidLoad()
 
        view.backgroundColor = AppColor.background
        title = L10n.Favourites.title
 
        setupNavigationBar()
        setupViews()
        bindViewModel()
 
        viewModel.updateState(viewInput: .viewDidLoad)
    }
 
    // MARK: - Binding
 
    private func bindViewModel() {
        viewModel.onWillChangeContent = { [weak self] in
            self?.tableView.beginUpdates()
        }
 
        viewModel.onDidChangeContent = { [weak self] in
            self?.tableView.endUpdates()
        }
 
        viewModel.onChange = { [weak self] type, indexPath, newIndexPath in
            self?.applyChange(type: type, indexPath: indexPath, newIndexPath: newIndexPath)
        }
 
        viewModel.onStateDidChange = { [weak self] state in
            DispatchQueue.main.async {
                self?.render(state: state)
            }
        }
    }
 
    private func render(state: FavouritesViewModel.State) {
        switch state {
        case .loaded:
            emptyLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
 
        case .empty:
            emptyLabel.isHidden = false
            tableView.isHidden = true
        }
    }
 
    private func applyChange(
        type: NSFetchedResultsChangeType,
        indexPath: IndexPath?,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            if let newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
 
        case .delete:
            if let indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
 
        case .update:
            if let indexPath,
               let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell,
               let post = viewModel.post(at: indexPath) {
                cell.configure(with: post)
            }
 
        case .move:
            if let indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
 
        @unknown default:
            break
        }
    }
 
    // MARK: - Setup
 
    private func setupNavigationBar() {
        let filterButton = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(showFilterAlert)
        )
 
        let clearButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark.circle"),
            style: .plain,
            target: self,
            action: #selector(clearFilter)
        )
 
        navigationItem.rightBarButtonItems = [clearButton, filterButton]
    }
 
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
 
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
 
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: AppLayout.spacingLarge
            ),
            emptyLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -AppLayout.spacingLarge
            )
        ])
    }
 
    // MARK: - Actions
 
    @objc private func showFilterAlert() {
        let alert = UIAlertController(
            title: L10n.Favourites.filterTitle,
            message: L10n.Favourites.filterMessage,
            preferredStyle: .alert
        )
 
        alert.addTextField { textField in
            textField.placeholder = L10n.Favourites.filterPlaceholder
        }
 
        let applyAction = UIAlertAction(
            title: L10n.Common.apply,
            style: .default
        ) { [weak self, weak alert] _ in
            let author = alert?.textFields?.first?.text ?? ""
            guard !author.isEmpty else { return }
            self?.viewModel.updateState(viewInput: .applyFilter(author: author))
        }
 
        alert.addAction(applyAction)
        alert.addAction(UIAlertAction(title: L10n.Common.cancel, style: .cancel))
 
        present(alert, animated: true)
    }
 
    @objc private func clearFilter() {
        viewModel.updateState(viewInput: .clearFilter)
    }
}
 
// MARK: - UITableViewDataSource
 
extension FavouritesViewController: UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(PostTableViewCell.self, for: indexPath)
        if let post = viewModel.post(at: indexPath) {
            cell.configure(with: post)
        }
        return cell
    }
}
 
// MARK: - UITableViewDelegate
 
extension FavouritesViewController: UITableViewDelegate {
 
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: L10n.Common.delete
        ) { [weak self] _, _, completion in
            self?.viewModel.updateState(viewInput: .delete(at: indexPath))
            completion(true)
        }
 
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
