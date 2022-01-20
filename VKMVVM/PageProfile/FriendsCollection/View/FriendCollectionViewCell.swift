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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iconImage)
        addSubview(firstNameLabel)
        addSubview(lastNameLabel)
        
        NSLayoutConstraint.activate([
            iconImage.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            iconImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            iconImage.heightAnchor.constraint(equalTo: widthAnchor),
        
            firstNameLabel.topAnchor.constraint(equalTo: iconImage.bottomAnchor, constant: 2),
            firstNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            firstNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            lastNameLabel.topAnchor.constraint(equalTo: firstNameLabel.topAnchor, constant: 2),
            lastNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            lastNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            lastNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)])
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
    }
}
