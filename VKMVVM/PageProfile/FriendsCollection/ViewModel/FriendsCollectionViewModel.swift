//
//  FriendsCollectionViewModel.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 20.01.2022.
//

import Foundation

protocol FriendsCollectionViewModelType: AnyObject {
    var count: Int { get }
    func getItem(by index: Int) -> FriendCellViewModelType
}

class FriendsCollectionViewModel {
    private let friends: [FriendCellViewModelType]
    
    init(_ friendsList: [FriendCellViewModelType]) {
        friends = friendsList
    }
}
extension FriendsCollectionViewModel: FriendsCollectionViewModelType {
    var count: Int {
        return friends.count
    }
    
    func getItem(by index: Int) -> FriendCellViewModelType {
        return friends[index]
    }
}

