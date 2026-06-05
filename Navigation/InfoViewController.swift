//
//  InfoViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 22.02.2026.
//

import UIKit

class InfoViewController: UIViewController {
    
    private var residents : [Resident] = []
    
    private lazy var alertButton = CustomButton(
        title: "Показать Alert",
        backgroundColor: .systemGreen,
        tapAction: {
            [weak self] in self?.showAlert()
        }
    )
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Загрузка..."
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        return titleLabel
    }()
    
    private lazy var orbitalPeriodLabel: UILabel = {
        let orbitalPeriodLabel = UILabel()
        orbitalPeriodLabel.translatesAutoresizingMaskIntoConstraints = false
        orbitalPeriodLabel.text = "Загрузка orbital_period..."
        orbitalPeriodLabel.numberOfLines = 0
        orbitalPeriodLabel.textAlignment = .center
        return orbitalPeriodLabel
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        fetchTitle()
        fetchPlanet()
    }
    
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        
        view.addSubview(alertButton)
        view.addSubview(titleLabel)
        view.addSubview(orbitalPeriodLabel)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            orbitalPeriodLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            orbitalPeriodLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            orbitalPeriodLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            alertButton.topAnchor.constraint(equalTo: orbitalPeriodLabel.bottomAnchor, constant: 32),
            alertButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            tableView.topAnchor.constraint(equalTo: alertButton.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    
        ])
    }
    
    private func showAlert() {
        let alertController = UIAlertController(
            title: "Внимание!!",
            message: "Это тестовое сообщение",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("Вы тыкнули кнопку OK")
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in
            print("Вы тыкнули кнопку Отмена")
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func fetchTitle() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            if let error {
                print("Задание 1. Ошибка \(error.localizedDescription)")
                return
            }
            
            guard let data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let dict = json as? [String: Any],
                      let title = dict["title"] as? String else { return }
                
                DispatchQueue.main.async {
                    self?.titleLabel.text = title
                }
            } catch {
                print("Задание 1. Ошибка JSON \(error.localizedDescription)")
            }
            
        }
        task.resume()
    }
    
    
    private func fetchPlanet() {
        let url = URL(string: "https://swapi.info/api/planets/1")!
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error {
                print("Задание 2. Ошибка \(error.localizedDescription)")
                return
            }
            
            guard let data else { return }
            
            do {
                let planet = try JSONDecoder().decode(Planet.self, from: data)
                DispatchQueue.main.async {
                    self?.orbitalPeriodLabel.text = "Период обращения Татуина: \(planet.orbitalPeriod)"
                }
                self?.fetchResidents(from: planet.residents)
            } catch {
                print("Задание 2. Ошибка декодирования: \(error.localizedDescription)")
    
            }
        }
        task.resume()
    }
    
    private func fetchResidents(from urls: [String]) {
        for urlString in urls {
            guard let url = URL(string: urlString) else { continue }
            
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let error {
                    print("Задание 3. Ошибка: \(error.localizedDescription)")
                    return
                }
                
                guard let data else { return }
                
                do {
                    let resident = try JSONDecoder().decode(Resident.self, from: data)
                    DispatchQueue.main.async {
                        self?.residents.append(resident)
                        self?.tableView.reloadData()
                    }
                } catch {
                    print("Задание 3. Ошибка декодирования \(error.localizedDescription)")
                }
                
            }
            task.resume()
        }
    }
}

extension InfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        residents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = residents[indexPath.row].name
        return cell
    }
}
