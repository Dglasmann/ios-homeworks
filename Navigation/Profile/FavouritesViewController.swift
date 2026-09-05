//
//  FavouritesViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 24.06.2026.
//

import UIKit
import CoreData

final class FavouritesViewController: UIViewController {
    
    private var posts: [PostModel] = []
    private var fetchedResultsController: NSFetchedResultsController<FavouritePost>!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Избранное"
        setupNavigationBar()
        setupViews()
        setupFetchedResultsController(author: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        posts = CoreDataService.shared.fetchPosts()
        tableView.reloadData()
    }
    
    private func setupFetchedResultsController(author: String?) {
        fetchedResultsController = CoreDataService.shared.makeFetchedResultsController(author: author)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print("FRC fetch error: \(error.localizedDescription)")
        }
    }
    
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
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    @objc private func showFilterAlert() {
        let alert = UIAlertController(
            title: "Поиск по автору",
            message: "Введите имя автора",
            preferredStyle: .alert
        )
        alert.addTextField { textField in
            textField.placeholder = "Автор"
        }
        
        let applyAction = UIAlertAction(title: "Применить", style: .default) { [weak self, weak alert] _ in
            guard let self = self else { return }
            let author = alert?.textFields?.first?.text ?? ""
            guard !author.isEmpty else { return }
            self.setupFetchedResultsController(author: author)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(applyAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    @objc private func clearFilter() {
        setupFetchedResultsController(author: nil)
    }
}

extension FavouritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        let favourite = fetchedResultsController.object(at: indexPath)
        cell.configure(with: posts[indexPath.row])
        return cell
    }

}

extension FavouritesViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Удалить"
        ) { [weak self] _, _, completion in
            guard let self = self else { completion(false); return }
            let favourite = self.fetchedResultsController.object(at: indexPath)
            CoreDataService.shared.deletePost(PostModel(from: favourite))
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension FavouritesViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell {
                let favourite = fetchedResultsController.object(at: indexPath)
                cell.configure(with: PostModel(from: favourite))
            }
        case .move:
            if let indexPath = indexPath { tableView.deleteRows(at: [indexPath], with: .fade) }
            if let newIndexPath = newIndexPath { tableView.insertRows(at: [newIndexPath], with: .fade) }
        @unknown default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
