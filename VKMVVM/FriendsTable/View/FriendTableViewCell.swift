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
        
        iconUser.anchor(top: contentView.topAnchor,
                        leading: contentView.leadingAnchor,
                        bottom: contentView.bottomAnchor,
                        trailing: nil,
                        padding: UIEdgeInsets(top: paddingIcon, left: 8, bottom: paddingIcon, right: 0))
        
        fullNameLabel.anchor(top: contentView.topAnchor,
                             leading: iconUser.trailingAnchor,
                             bottom: nil,
                             trailing: contentView.trailingAnchor,
                             padding: UIEdgeInsets(top: 4, left: 16, bottom: 0, right: 0))
        
        extraDataLabel.anchor(top: fullNameLabel.bottomAnchor,
                              leading: iconUser.trailingAnchor,
                              bottom: nil,
                              trailing: contentView.trailingAnchor,
                              padding: UIEdgeInsets(top: 4, left: 16, bottom: 0, right: 0))
        
        onlineImage.anchor(top: nil,
                           leading: nil,
                           bottom: iconUser.bottomAnchor,
                           trailing: iconUser.trailingAnchor)
        
        NSLayoutConstraint.activate([
            iconUser.widthAnchor.constraint(equalTo: contentView.heightAnchor, constant: -paddingIcon * 2),
        
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
