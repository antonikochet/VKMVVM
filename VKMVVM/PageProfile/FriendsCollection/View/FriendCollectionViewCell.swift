//
//  FriendCollectionViewCell.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 20.01.2022.
//

import UIKit

protocol FriendCellViewModelType {
    var iconUrl: String? { get }
    var firstName: String { get }
    var lastName: String { get }
    var isOnline: Bool { get }
    var isOnlineMobile: Bool { get }
}

class FriendCollectionViewCell: UICollectionViewCell {
    static let identifier = "FriendCollectionViewCell"
    
    private let iconImage: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let firstNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.text = "Имя"
        label.textColor = UIColor(named: "briefLabelColor")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lastNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.text = "Фамилия"
        label.textColor = UIColor(named: "briefLabelColor")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let onlineImage: OnlineImageView = {
        let imageView = OnlineImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iconImage)
        addSubview(firstNameLabel)
        addSubview(lastNameLabel)
        addSubview(onlineImage)
        
        iconImage.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         bottom: nil,
                         trailing: trailingAnchor,
                         padding: UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0))
        iconImage.heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        firstNameLabel.anchor(top: iconImage.bottomAnchor,
                              leading: leadingAnchor,
                              bottom: nil,
                              trailing: trailingAnchor,
                              padding: UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0))
        
        lastNameLabel.anchor(top: firstNameLabel.topAnchor,
                             leading: leadingAnchor,
                             bottom: bottomAnchor,
                             trailing: trailingAnchor,
                             padding: UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0))
       
        onlineImage.anchor(top: nil,
                           leading: nil,
                           bottom: iconImage.bottomAnchor,
                           trailing: iconImage.trailingAnchor,
                           size: CGSize(width: 15, height: 15))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImage.clipsToBounds = true
        iconImage.layer.cornerRadius = iconImage.frame.height / 2
    }
    
    func set(viewModel: FriendCellViewModelType) {
        iconImage.set(imageURL: viewModel.iconUrl)
        firstNameLabel.text = viewModel.firstName
        lastNameLabel.text = viewModel.lastName
        onlineImage.set(online: viewModel.isOnline, has_phone: viewModel.isOnlineMobile)
    }
}
