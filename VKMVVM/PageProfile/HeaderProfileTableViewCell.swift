//
//  HeaderProfileTableViewCell.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 16.01.2022.
//

import UIKit

protocol HeaderProfileCellViewModelType {
    var iconUrl: String? { get }
    var fullName: String { get }
    var userStatus: String { get }
    var onlineStatus: String { get }
}

protocol HeaderProfileCellDelegate: AnyObject {
    func showProfilePhotosGallery()
}

class HeaderProfileTableViewCell: UITableViewCell {

    static let identifier = "HeaderProfileTableViewCell"
    
    weak var delegate: HeaderProfileCellDelegate?
    
    private let iconImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.backgroundColor = UIColor(white: 0.8, alpha: 1)
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Status"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 1
        return label
    }()
    
    private let onlineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 1
        label.textColor = UIColor(named: "briefLabelColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(onlineLabel)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showGalleryMainPhoto))
        iconImageView.addGestureRecognizer(gesture)
        
        let iconHeight = StaticSizesPageProfileCell.heigthHeaderProfileCell - 8 - 8
        iconImageView.layer.cornerRadius = iconHeight / 2
        iconImageView.clipsToBounds = true
        
        iconImageView.anchor(top: contentView.topAnchor,
                             leading: contentView.leadingAnchor,
                             bottom: nil,
                             trailing: nil,
                             padding: UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 0),
                             size: CGSize(width: iconHeight, height: iconHeight))
        
        onlineLabel.anchor(top: statusLabel.bottomAnchor,
                           leading: iconImageView.trailingAnchor,
                           bottom: nil,
                           trailing: contentView.trailingAnchor,
                           padding: UIEdgeInsets(top: 4, left: 16, bottom: 0, right: 8))
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor, constant: -16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            statusLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            statusLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor, constant: 8),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(viewModel: HeaderProfileCellViewModelType) {
        iconImageView.set(imageURL: viewModel.iconUrl)
        nameLabel.text = viewModel.fullName
        statusLabel.text = viewModel.userStatus
        onlineLabel.text = viewModel.onlineStatus
    }

    @objc private func showGalleryMainPhoto() {
        delegate?.showProfilePhotosGallery()
    }
}
