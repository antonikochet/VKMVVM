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
    var onlineStatus: String
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

struct FriendCellViewModel: FriendCellViewModelType {
    var id: Int
    
    var iconUrl: String?
    var firstName: String
    var lastName: String
    var isOnline: Bool
    var isOnlineMobile: Bool
}

struct PhotoList: PhotoListViewModelType {
    var countPhoto: String
    var photoList: [DetailPhotoViewModelType]
}
