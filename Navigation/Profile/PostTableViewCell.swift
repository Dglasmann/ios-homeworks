//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by Sasha Soldatov on 09.03.2026.
//


import UIKit
class PostTableViewCell: UITableViewCell {
    
    
    //MARK: - Subviews
    private let authorLabel : UILabel = {
        let authorLabel = UILabel()
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        authorLabel.textColor = .black
        authorLabel.numberOfLines = 2
        return authorLabel
    }()
    
    
    private let postImageView: UIImageView = {
        let postImageView = UIImageView()
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        postImageView.contentMode = .scaleAspectFit
        postImageView.backgroundColor = .black
        postImageView.clipsToBounds = true
        return postImageView
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = .systemGray
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    
    private let likesLabel: UILabel = {
        let likesLabel = UILabel()
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        likesLabel.textColor = .black
        return likesLabel
    }()
    
    private let viewsLabel: UILabel = {
        let viewsLabel = UILabel()
        viewsLabel.translatesAutoresizingMaskIntoConstraints = false
        viewsLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        viewsLabel.textColor = .black
        viewsLabel.textAlignment = .right
        return viewsLabel
    }()
    
    
    //MARK: - Double tap
    
    var onDoubleTap: (() -> Void)?
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier:String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        setupDoubleTap()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Setup
    private func setupViews() {
        selectionStyle = .none
        contentView.addSubview(authorLabel)
        contentView.addSubview(postImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(likesLabel)
        contentView.addSubview(viewsLabel)
    }
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            //заголовок - сверху 16, слева и справа 16
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            //изображение - под заголовком 16, на всю ширину и квадратное (height=width=screenWidth)
            postImageView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 16),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor),
            
            //описание - под картинкой 16, слева и справа 16
            descriptionLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            //лайки - под описанием 16, слева и снизу 16
            likesLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            likesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            likesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            //просмотры - под описанием 16, справа и снизу 16
            viewsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            viewsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            viewsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
        
    }
    
    private func setupDoubleTap() {
        let doubleTap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleDoubleTap)
        )
        doubleTap.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(doubleTap)
    }
    
    @objc private func handleDoubleTap() {
        onDoubleTap?()
    }
    
    
    func configure(with post: PostModel) {
        authorLabel.text = post.author
        postImageView.image = post.image
        descriptionLabel.text = post.description
        likesLabel.text = "Likes: \(post.likes)"
        viewsLabel.text = "Views: \(post.views)"
    }
    
}
