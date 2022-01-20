//
//  FriendsViewCell.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 19.01.2022.
//

import UIKit

protocol FriendsListViewModelType {
    var countFriends: Int { get }
    var friendsList: [FriendCellViewModelType] { get }
}

class FriendsViewCell: UITableViewCell {

    static let identifier = "FriendsViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "ДРУЗЬЯ"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let countFriendsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let collectionView = FriendsCollectionView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.addSubview(label)
        contentView.addSubview(countFriendsLabel)
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            countFriendsLabel.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8),
            countFriendsLabel.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 4),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(viewModel: FriendsListViewModelType) {
        countFriendsLabel.text = viewModel.countFriends.description
        let collViewModel = FriendsCollectionViewModel(viewModel.friendsList)
        collectionView.viewModel = collViewModel
    }
}
