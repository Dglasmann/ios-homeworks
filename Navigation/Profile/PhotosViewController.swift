//
//  PhotosViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 15.03.2026.
//

import UIKit
import iOSIntPackage

class PhotosViewController: UIViewController {
    
    //MARK: - Data
    private var photos: [UIImage] = []
    private var facade = ImagePublisherFacade()
    
    //MARK: - Subviews
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "PhotosCollectionViewCell")
        return collectionView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Photo Gallery"
        facade.subscribe(self)
        let myImages = (1...20).compactMap { UIImage(named: "photo\($0)") }
        facade.addImagesWithTimer(time: 0.5, repeat: 20, userImages: myImages)
        setupViews()
        setupConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
        facade.removeSubscription(for: self)
    }
    
    //MARK: - Setup
    private func setupViews() {
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
//MARK: - Extensions
extension PhotosViewController: UICollectionViewDataSource {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCollectionViewCell", for: indexPath) as? PhotosCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: photos[indexPath.item])
        return cell
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    
    //все отступы по 8
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    //три ячейки в ряд
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 8
        let insets: CGFloat = 8 * 2
        let totalSpacing = spacing * 2 + insets
        let width = (collectionView.frame.width - totalSpacing) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

extension PhotosViewController: ImageLibrarySubscriber {
    func receive(images: [UIImage]) {
        photos = images
        collectionView.reloadData()
        
        let item = IndexPath(item: images.count - 1, section: 0)
        collectionView.scrollToItem(at: item, at: .bottom, animated: true)
        
    }
    
}
