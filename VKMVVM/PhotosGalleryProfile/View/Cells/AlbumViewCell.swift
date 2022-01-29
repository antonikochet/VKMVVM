//
//  AlbumViewCell.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 29.01.2022.
//

import UIKit

protocol AlbumCellViewModelType {
    var thumbUrl: String? { get }
    var nameAlbum: String { get }
    var countPhotos: String { get }
}

class AlbumViewCell: UICollectionViewCell {
    
    static let identifier = "AlbumViewCell"
    
    private let thumbImage: WebImageView = {
        let imageView = WebImageView()
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameAlbumLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countPhotosAlbumLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor(named: "briefLabelColor")!
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(thumbImage)
        addSubview(nameAlbumLabel)
        addSubview(countPhotosAlbumLabel)
        
        NSLayoutConstraint.activate([
            thumbImage.topAnchor.constraint(equalTo: topAnchor),
            thumbImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            thumbImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            thumbImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 3/4),
        
            nameAlbumLabel.topAnchor.constraint(equalTo: thumbImage.bottomAnchor, constant: 4),
            nameAlbumLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameAlbumLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            countPhotosAlbumLabel.topAnchor.constraint(equalTo: nameAlbumLabel.bottomAnchor, constant: 2),
            countPhotosAlbumLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            countPhotosAlbumLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            countPhotosAlbumLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        thumbImage.clipsToBounds = true
        thumbImage.layer.cornerRadius = 15
    }
    
    func set(viewModel: AlbumCellViewModelType) {
        thumbImage.set(imageURL: viewModel.thumbUrl)
        nameAlbumLabel.text = viewModel.nameAlbum
        countPhotosAlbumLabel.text = viewModel.countPhotos
    }
}
