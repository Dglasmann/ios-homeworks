//
//  InfoViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 22.02.2026.
//

import UIKit
 
final class InfoViewController: UIViewController {
 
    // MARK: - Dependencies
 
    private let networkService: NetworkServiceProtocol
 
    // MARK: - Data
 
    private var residents: [Resident] = []
 
    // MARK: - Init
 
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    // MARK: - Subviews
 
    private lazy var alertButton = CustomButton(
        title: L10n.Info.showAlert,
        backgroundColor: .systemGreen,
        tapAction: { [weak self] in self?.showAlert() }
    )
 
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = L10n.Info.loadingTitle
        label.font = AppFont.body
        label.textColor = AppColor.primaryText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
 
    private lazy var orbitalPeriodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = L10n.Info.loadingPeriod
        label.font = AppFont.body
        label.textColor = AppColor.primaryText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
 
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.backgroundColor = AppColor.background
        tableView.register(UITableViewCell.self)
        return tableView
    }()
 
    // MARK: - Lifecycle
 
    override func viewDidLoad() {
        super.viewDidLoad()
 
        setupUI()
 
        fetchTitle()
        fetchPlanet()
    }
 
    // MARK: - Setup
 
    private func setupUI() {
        view.backgroundColor = AppColor.background
 
        view.addSubview(titleLabel)
        view.addSubview(orbitalPeriodLabel)
        view.addSubview(alertButton)
        view.addSubview(tableView)
 
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: AppLayout.spacing
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: AppLayout.spacing
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -AppLayout.spacing
            ),
 
            orbitalPeriodLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: AppLayout.spacing
            ),
            orbitalPeriodLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: AppLayout.spacing
            ),
            orbitalPeriodLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -AppLayout.spacing
            ),
 
            alertButton.topAnchor.constraint(
                equalTo: orbitalPeriodLabel.bottomAnchor,
                constant: AppLayout.spacingLarge
            ),
            alertButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertButton.heightAnchor.constraint(equalToConstant: AppLayout.controlHeight),
 
            tableView.topAnchor.constraint(
                equalTo: alertButton.bottomAnchor,
                constant: AppLayout.spacingLarge
            ),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
 
        alertButton.widthAnchor.constraint(
            lessThanOrEqualToConstant: AppLayout.maxContentWidth
        ).isActive = true
    }
 
    // MARK: - Networking
 
    private func fetchTitle() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else {
            return
        }
 
        networkService.request(url, as: Todo.self) { [weak self] result in
            switch result {
            case .success(let todo):
                self?.titleLabel.text = todo.title
            case .failure(let error):
                self?.showAlert(message: error.localizedDescription)
            }
        }
    }
 
    /// Загружает данные о планете и запускает загрузку жителей
    private func fetchPlanet() {
        guard let url = URL(string: "https://swapi.info/api/planets/1") else { return }
 
        networkService.request(url, as: Planet.self) { [weak self] result in
            switch result {
            case .success(let planet):
                self?.orbitalPeriodLabel.text = L10n.Info.orbitalPeriod(planet.orbitalPeriod)
                self?.fetchResidents(from: planet.residents)
            case .failure(let error):
                self?.showAlert(message: error.localizedDescription)
            }
        }
    }
 
    /// Загружает жителей планеты
    private func fetchResidents(from urls: [String]) {
        for urlString in urls {
            guard let url = URL(string: urlString) else { continue }
 
            networkService.request(url, as: Resident.self) { [weak self] result in
                guard let self, case .success(let resident) = result else { return }
 
                self.residents.append(resident)
                self.tableView.reloadData()
            }
        }
    }
 
    // MARK: - Actions
 
    private func showAlert() {
        let alert = UIAlertController(
            title: L10n.Info.alertTitle,
            message: L10n.Info.alertMessage,
            preferredStyle: .alert
        )
 
        alert.addAction(UIAlertAction(title: L10n.Common.ok, style: .default))
        alert.addAction(UIAlertAction(title: L10n.Common.cancel, style: .cancel))
 
        present(alert, animated: true)
    }
 
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: L10n.Common.error,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: L10n.Common.ok, style: .default))
        present(alert, animated: true)
    }
}
 
// MARK: - UITableViewDataSource
 
extension InfoViewController: UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        residents.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(UITableViewCell.self, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = residents[indexPath.row].name
        content.textProperties.font = AppFont.body
        content.textProperties.color = AppColor.primaryText
        cell.contentConfiguration = content
        cell.backgroundColor = AppColor.background
 
        return cell
    }
}
