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
    
    private var friendsResponse: FriendsResponse
    private var friendsCells: [FriendTableCellViewModelType] = []
    private var dataFetcher: DataFetcher?
    private var userId: String?
    
    init(_ friends: FriendsResponse?, dataFetcher: DataFetcher = NetworkDataFetcher()) {
        self.dataFetcher = dataFetcher
        userId = friends?.userId
        if let friends = friends {
            friendsResponse = friends
        } else {
            friendsResponse = FriendsResponse(count: 0, items: [], userId: nil)
        }
        viewData()
    }
    
    private func getFriends() {
        let request = FriendsRequestParams(userId: userId,
                                           order: .name,
                                           count: nil,
                                           offset: nil,
                                           fields: [.city, .online, .photo100])
        
        dataFetcher?.getFriends(parametrs: request) { result in
            switch result {
                case .success(let response):
                    self.friendsResponse = response.response
                case .failure(let error):
                    if let deletedError = error as? ErrorResponse {
                        guard deletedError.errorCode != 30 else { return }
                        self.delegate?.showError(error)
                    }
                    self.delegate?.showError(error)
            }
        }
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
        viewData()
    }
}
