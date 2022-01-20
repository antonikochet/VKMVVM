//
//  PageProfileModel.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 16.01.2022.
//

import Foundation

struct HeaderProfileCellModel: HeaderProfileCellViewModelType {
    var iconUrl: String?
    var fullName: String
    var userStatus: String
}

struct BriefUserInfoCellModel: BriefUserInfoViewModelType {
    var city: String?
    var education: String?
    var work: String?
    var followes: String?
}

struct FriendsList: FriendsListViewModelType {
    var countFriends: Int
    var friendsList: [FriendCellViewModelType]
}
