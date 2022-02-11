//
//  FriendsTableViewModel.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 21.01.2022.
//

import Foundation

protocol FriendsTableViewModelDelegate: AnyObject {
    func didLoadData()
    func showError(_ error: Error)
}

protocol FriendsTableViewModelType{
    var count: Int { get }
    func getItem(by index: Int) -> FriendTableCellViewModelType
    func refreshFriends()
}

class FriendsTableViewModel {
    weak var delegate: FriendsTableViewModelDelegate?
    
    private var dataFetcher: DataFetcher
    
    private var friendsCells: [FriendTableCellViewModelType] = []
    private var userId: String?
    
    init(_ friendsUser: [UserResponse]?, userId: String?, dataFetcher: DataFetcher = NetworkDataFetcher()) {
        self.dataFetcher = dataFetcher
        self.userId = userId
        if let friendsUser = friendsUser, !friendsUser.isEmpty {
            viewData(friendsUser: friendsUser)
        } else {
            getFriends()
        }
    }
    
    private func getFriends() {
        let request = FriendsRequestParams(userId: userId,
                                           order: .name,
                                           count: nil,
                                           offset: nil,
                                           fields: [.city, .online, .photo100])
        
        dataFetcher.getFriends(parametrs: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let response):
                    self.viewData(friendsUser: response.response.items)
                case .failure(let error):
                    if let deletedError = error as? ErrorResponse {
                        guard deletedError.errorCode != 30 else { return }
                        self.delegate?.showError(error)
                    }
                    self.delegate?.showError(error)
            }
        }
    }
    
    private func viewData(friendsUser: [UserResponse]) {
        friendsCells = friendsUser.map { user in
            let fullName = user.firstName + " " + user.lastName
            let extraData: String? = gettingExtraData(user: user)
                 
            return FriendTableCellModel(id: user.id,
                                        iconUrl: user.photoUrl,
                                        fullName: fullName,
                                        extraData: extraData,
                                        isOnline: user.isOnline,
                                        isOnlineMobile: user.isOnlineMobile)
        }
        delegate?.didLoadData()
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
    
    func refreshFriends() {
        getFriends()
    }
}
