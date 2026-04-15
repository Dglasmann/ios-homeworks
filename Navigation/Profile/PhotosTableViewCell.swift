//
//  PhotosTableViewCell.swift
//  Navigation
//
//  Created by Sasha Soldatov on 15.03.2026.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {
    
    //MARK: - Subviews
    
    
    //заголовок Photos, 24 шрифт, bold, black
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Photos"
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        titleLabel.textColor = .black
        return titleLabel
    }()
    
    //стрелка вправо
    private let rightArrowImageView: UIImageView = {
        let rightArrowImageView = UIImageView()
        rightArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        rightArrowImageView.image = UIImage(systemName: "arrow.right")
        rightArrowImageView.tintColor = .black
        rightArrowImageView.contentMode = .scaleAspectFit
        return rightArrowImageView
    }()
    
    //стек с фотками, spacing 8
    private let photosStackView: UIStackView = {
        let photosStackView = UIStackView()
        photosStackView.translatesAutoresizingMaskIntoConstraints = false
        photosStackView.axis = .horizontal
        photosStackView.alignment = .center
        photosStackView.spacing = 8
        photosStackView.distribution = .fillEqually
        return photosStackView
    }()
    
    private var photoImageViews: [UIImageView] = []
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    
    private func setupViews() {
        selectionStyle = .none
        accessoryType = .none
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(rightArrowImageView)
        contentView.addSubview(photosStackView)
        
        for _ in 0..<4 {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 6
            photosStackView.addArrangedSubview(imageView)
            photoImageViews.append(imageView)
        }
    }
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            //photos - 12 сверху и слева
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            //стрелка - 12 справа, centerY = titleLabel.centerY
            rightArrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            rightArrowImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            rightArrowImageView.widthAnchor.constraint(equalToConstant: 24),
            rightArrowImageView.heightAnchor.constraint(equalToConstant: 24),
            
            //стек с фотками - 12 под заголовком, слева, справа и снизу
            photosStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            photosStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            photosStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            photosStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            //высота каждой фотки = ее ширине
            photoImageViews[0].heightAnchor.constraint(equalTo: photoImageViews[0].widthAnchor),
            photoImageViews[1].heightAnchor.constraint(equalTo: photoImageViews[1].widthAnchor),
            photoImageViews[2].heightAnchor.constraint(equalTo: photoImageViews[2].widthAnchor),
            photoImageViews[3].heightAnchor.constraint(equalTo: photoImageViews[3].widthAnchor),
        
        ])
    }
    
    func configure(with photos: [String]) {
        for (index, imageView) in photoImageViews.enumerated() {
            if index < photos.count {
                imageView.image = UIImage(named: photos[index])
            }
        }
    }
}
