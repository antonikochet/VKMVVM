//
//  PhotoViewCell.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 30.01.2022.
//

import UIKit

class PhotoViewCell: UICollectionViewCell {
    
    static let identifier = "PhotoViewCell"
    
    private let imageView: WebImageView = {
        let imageView = WebImageView()
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(urlImage: String?) {
        imageView.set(imageURL: urlImage)
    }
}
