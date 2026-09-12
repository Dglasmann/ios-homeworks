//
//  PhotosViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 15.03.2026.
//

import UIKit
import iOSIntPackage

final class PhotosViewController: UIViewController {
    
    // MARK: - Data
    private var photos: [UIImage] = []
    private let imageProcessor = ImageProcessor()
    private let viewModel: PhotosViewModel
    
    init(viewModel: PhotosViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    // MARK: - Subviews
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = AppColor.background
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "PhotosCollectionViewCell")
        return collectionView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
        }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background
        title = L10n.Profile.gallery

        setupViews()
        setupConstraints()
        bindViewModel()
        
        viewModel.updateState(viewInput: .viewDidLoad)
    }

    override func viewWillTransition(
        to size: CGSize,
        with coordinator: any UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate { [weak self] _ in
            self?.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    // MARK: - Bindings
    
    private func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            DispatchQueue.main.async {
                self?.render(state: state)
            }
            
        }
    }
    
    private func render(state: PhotosViewModel.State) {
        switch state {
        case .loading:
            activityIndicator.startAnimating()
        case .loaded(let images):
            activityIndicator.stopAnimating()
            photos = images
            collectionView.reloadData()
        }
    }
    
    // MARK: - Setup
    private func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}
// MARK: - Extensions
extension PhotosViewController: UICollectionViewDataSource {
 
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        photos.count
    }
 
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeue(PhotosCollectionViewCell.self, for: indexPath)
        cell.configure(with: photos[indexPath.item])
        return cell
    }
}
 
// MARK: - UICollectionViewDelegateFlowLayout
 
extension PhotosViewController: UICollectionViewDelegateFlowLayout {
 
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: AppLayout.spacingSmall,
            left: AppLayout.spacingSmall,
            bottom: AppLayout.spacingSmall,
            right: AppLayout.spacingSmall
        )
    }
 
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let spacing = AppLayout.spacingSmall
        let itemsPerRow = CGFloat(traitCollection.horizontalSizeClass == .regular ? 6 : 3)
        let totalSpacing = spacing * (itemsPerRow + 1)
        let width = ((collectionView.bounds.width - totalSpacing) / itemsPerRow).rounded(.down)
        return CGSize(width: width, height: width)
    }
 
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        AppLayout.spacingSmall
    }
 
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        AppLayout.spacingSmall
    }
}
