//
//  FriendsTableViewModel.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 21.01.2022.
//

import Foundation

protocol FriendsTableViewModelDelegate: AnyObject {
    func didLoadData()
}

protocol FriendsTableViewModelType{
    var count: Int { get }
    func getItem(by index: Int) -> FriendTableCellViewModelType
}

class FriendsTableViewModel {
    weak var delegate: FriendsTableViewModelDelegate?
    
    private var friendsResponse: FriendsResponse
    private var friendsCells: [FriendTableCellViewModelType] = []
    
    init(_ friends: FriendsResponse?) {
        if let friends = friends {
            friendsResponse = friends
        } else {
            friendsResponse = FriendsResponse(count: 0, items: [])
        }
        viewData()
    }
    
    private func viewData() {
        friendsCells = friendsResponse.items.map { user in
            let fullName = user.firstName + " " + user.lastName
            let extraData: String? = gettingExtraData(user: user)
             
            return FriendTableCellModel(id: user.id,
                                        iconUrl: user.photoUrl,
                                        fullName: fullName,
                                        extraData: extraData,
                                        isOnline: user.isOnline,
                                        isOnlineMobile: user.isOnlineMobile)
        }
    }

    private func gettingExtraData(user: UserResponse) -> String? {
        if !(user.universityName?.isEmpty ?? true) {
            return user.universityName
        } else if !(user.city?.title.isEmpty ?? true) {
            return user.city?.title
        } else {
            return nil
        }
    }
}

extension FriendsTableViewModel: FriendsTableViewModelType {
    var count: Int {
        return friendsCells.count
    }
    
    func getItem(by index: Int) -> FriendTableCellViewModelType {
        return friendsCells[index]
    }
    
    
}
