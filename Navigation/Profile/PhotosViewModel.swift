//
//  PhotosViewModel.swift
//  Navigation
//
//  Created by Sasha Soldatov on 10.09.2026.
//

import UIKit
import iOSIntPackage

final class PhotosViewModel: ViewModelProtocol {
    
    enum State {
        case loading
        case loaded([UIImage])
    }
    
    enum ViewInput {
        case viewDidLoad
    }
    
    var onStateDidChange: ((State) -> Void)?
    
    private(set) var state: State = .loading {
        didSet {
            onStateDidChange?(state)
        }
    }
    
    private let photoService: PhotoServiceProtocol
    private let imageProcessor = ImageProcessor()
    
    init(photoService: PhotoServiceProtocol) {
        self.photoService = photoService
    }
    
    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .viewDidLoad:
            applyFilter()
        }
    }
    
    
    // Применяет сепию ко всем фотографиям в фоне
    private func applyFilter() {
        state = .loading
        let source = photoService.photos()
        
        imageProcessor.processImagesOnThread(
            sourceImages: source,
            filter: .sepia(intensity: 1),
            qos: .userInitiated) { [weak self] cgImages in
                let processed = cgImages.compactMap { $0 }.map { UIImage(cgImage: $0) }
                DispatchQueue.main.async {
                    self?.state = .loaded(processed)
                }
            }
    }
}
    

