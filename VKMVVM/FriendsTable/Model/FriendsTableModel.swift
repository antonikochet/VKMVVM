//
//  FriendsTableModel.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 21.01.2022.
//

import Foundation

struct FriendTableCellModel: FriendTableCellViewModelType {
    var id: Int
    
    var iconUrl: String?
    var fullName: String
    var extraData: String?
    var isOnline: Bool
    var isOnlineMobile: Bool
}
