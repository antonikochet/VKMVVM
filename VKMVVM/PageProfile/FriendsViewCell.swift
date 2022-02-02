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

protocol FriendsViewCellDelegate: AnyObject {
    func showFriend(by id: Int)
}

class FriendsViewCell: UITableViewCell {

    static let identifier = "FriendsViewCell"
    
    weak var delegate: FriendsViewCellDelegate?
    
    private var viewModel: FriendsListViewModelType? {
        didSet {
            friendsCollectionView.reloadData()
        }
    }
    
    private let headerView: HeaderCell = {
        let view = HeaderCell(title: "ДРУЗЬЯ")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let friendsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collView.register(FriendCollectionViewCell.self, forCellWithReuseIdentifier: FriendCollectionViewCell.identifier)
        collView.showsHorizontalScrollIndicator = false
        collView.showsVerticalScrollIndicator = false
        collView.translatesAutoresizingMaskIntoConstraints = false
        return collView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.addSubview(headerView)
        contentView.addSubview(friendsCollectionView)
        
        friendsCollectionView.delegate = self
        friendsCollectionView.dataSource = self
        
        headerView.setupConstraints(superView: contentView)
        friendsCollectionView.anchor(top: headerView.bottomAnchor,
                                     leading: contentView.leadingAnchor,
                                     bottom: contentView.bottomAnchor,
                                     trailing: contentView.trailingAnchor,
                                     padding: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(viewModel: FriendsListViewModelType) {
        headerView.set(count: String(viewModel.countFriends))
        self.viewModel = viewModel
    }
}

extension FriendsViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.countFriends ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendCollectionViewCell.identifier, for: indexPath) as! FriendCollectionViewCell
        if let friendViewModel = viewModel?.friendsList[indexPath.row] {
            cell.set(viewModel: friendViewModel)
        }
        return cell
    }
}

extension FriendsViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let friendViewModel = viewModel?.friendsList[indexPath.row] as? FriendCellViewModel {
            delegate?.showFriend(by: friendViewModel.id)
        }
    }
}

extension FriendsViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 5, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
