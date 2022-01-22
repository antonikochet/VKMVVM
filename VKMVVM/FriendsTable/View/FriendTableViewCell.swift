//
//  FriendTableViewCell.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 21.01.2022.
//

import UIKit

protocol FriendTableCellViewModelType {
    var iconUrl: String? { get }
    var fullName: String { get }
    var extraData: String? { get }
    var isOnline: Bool { get }
    var isOnlineMobile: Bool { get }
}

class FriendTableViewCell: UITableViewCell {

    static let identifier = "FriendTableViewCell"
    
    private let iconUser: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .blue
        return imageView
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let extraDataLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(named: "briefLabelColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let onlineImage: OnlineImageView = {
        let view = OnlineImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .gray
        
        contentView.addSubview(iconUser)
        contentView.addSubview(fullNameLabel)
        contentView.addSubview(extraDataLabel)
        contentView.addSubview(onlineImage)
        
        let paddingIcon: CGFloat = 2
        NSLayoutConstraint.activate([
            iconUser.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            iconUser.topAnchor.constraint(equalTo: contentView.topAnchor, constant: paddingIcon),
            iconUser.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -paddingIcon),
            iconUser.widthAnchor.constraint(equalTo: contentView.heightAnchor, constant: -paddingIcon * 2),
        
            fullNameLabel.leadingAnchor.constraint(equalTo: iconUser.trailingAnchor, constant: 16),
            fullNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            fullNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            extraDataLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 4),
            extraDataLabel.leadingAnchor.constraint(equalTo: iconUser.trailingAnchor, constant: 16),
            extraDataLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            onlineImage.trailingAnchor.constraint(equalTo: iconUser.trailingAnchor),
            onlineImage.bottomAnchor.constraint(equalTo: iconUser.bottomAnchor),
            onlineImage.heightAnchor.constraint(equalToConstant: 15),
            onlineImage.widthAnchor.constraint(equalToConstant: 15)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconUser.clipsToBounds = true
        iconUser.layer.cornerRadius = iconUser.frame.height / 2
    }

    func set(viewModel: FriendTableCellViewModelType) {
        iconUser.set(imageURL: viewModel.iconUrl)
        fullNameLabel.text = viewModel.fullName
        extraDataLabel.text = viewModel.extraData
        onlineImage.set(online: viewModel.isOnline, has_phone: viewModel.isOnlineMobile)
    }
}
