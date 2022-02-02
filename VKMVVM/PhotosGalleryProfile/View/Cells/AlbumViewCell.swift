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
        
        thumbImage.anchor(top: topAnchor,
                          leading: leadingAnchor,
                          bottom: nil,
                          trailing: trailingAnchor,
                          padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        thumbImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 3/4).isActive = true
        
        nameAlbumLabel.anchor(top: thumbImage.bottomAnchor,
                              leading: leadingAnchor,
                              bottom: nil,
                              trailing: trailingAnchor,
                              padding: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0))
        
        countPhotosAlbumLabel.anchor(top: nameAlbumLabel.bottomAnchor,
                                     leading: leadingAnchor,
                                     bottom: bottomAnchor,
                                     trailing: trailingAnchor, padding: UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0))
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
