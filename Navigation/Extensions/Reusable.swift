//
//  Reusable.swift
//  Navigation
//
//  Created by Sasha Soldatov on 05.09.2026.
//

import UIKit

protocol Reusable {
    
    static var reuseIdentifier: String { get }
    
}

extension Reusable {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}

extension UITableViewCell: Reusable {}
extension UICollectionViewCell: Reusable {}

extension UITableView {
    
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func dequeue<T: UITableViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Не зарегистрирована ячейка \(cellType.reuseIdentifier)")
        }
        return cell
    }
    
}

extension UICollectionView {
    
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func dequeue<T: UICollectionViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for:
                                                indexPath) as? T else {
            fatalError("Не зарегистрирована ячейка \(cellType.reuseIdentifier)")
        }
        return cell
    }
    
    
}
