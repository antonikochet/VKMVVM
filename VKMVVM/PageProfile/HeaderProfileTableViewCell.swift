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
}

class HeaderProfileTableViewCell: UITableViewCell {

    static let identifier = "HeaderProfileTableViewCell"
    
    private let iconImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.backgroundColor = UIColor(white: 0.8, alpha: 1)
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(statusLabel)
        
        let iconHeight = StaticSizesPageProfileCell.heigthHeaderProfileCell - 8 - 8
        iconImageView.layer.cornerRadius = iconHeight / 2
        iconImageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.widthAnchor.constraint(equalToConstant: iconHeight),
            iconImageView.heightAnchor.constraint(equalToConstant: iconHeight),
        
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor, constant: -16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            statusLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
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
    }

}
