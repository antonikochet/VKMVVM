//
//  PageProfileViewModel.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 15.01.2022.
//

import Foundation

protocol PageProfileViewModelType {
    func loadProfileInfo()
    func getHeaderProfile() -> HeaderProfileCellViewModelType?
    func getBriefUserInfo() -> BriefUserInfoViewModelType?
    func getFriendsList() -> FriendsListViewModelType?
}

protocol PageProfileViewModelDelegate: AnyObject {
    func didLoadData()
    func showError(error: Error)
}

class PageProfileViewModel {
    weak var delegate: PageProfileViewModelDelegate?
    
    private var response: UserResponse?
    private var friendsResponse: FriendsResponse?
    private var userId: String?
    
    init(userId: String? = nil) {
        self.userId = userId
    }
    
    private func getProfileInformation() {
        let fieldsParams = UserRequestFieldsParams.params(.birthdayData, .HomeTown, .photo100, .screenName, .sex, .followersCount, .education)
        var params = [UserRequestParams.fields.rawValue: fieldsParams]
        if let userId = userId {
            params[UserRequestParams.userIds.rawValue] = userId
        }
        APIManager.shader.request(path: .getUsers, params: params) { data, error in
            guard error == nil else {
                self.delegate?.showError(error: error!)
                return
            }
            if let data = data {
                let response = try! JSONDecoder().decode(UserResponseWrapper.self, from: data)
                self.response = response.response.first
                self.delegate?.didLoadData()
            }
        }
    }
    
    private func getFriends() {
        var params = [FriendsRequestParams.fields.rawValue: FriendsRequestFieldsParams.params(.photo100),
                      FriendsRequestParams.order.rawValue: FriendsRequestOrderParams.hints.rawValue]
        if let userId = userId {
            params[FriendsRequestParams.userId.rawValue] = userId
        }
        APIManager.shader.request(path: .getFriends, params: params) { data, error in
            guard error == nil else {
                self.delegate?.showError(error: error!)
                return
            }
            if let data = data {
                let response = try! JSONDecoder().decode(FriendsResponseWrapper.self, from: data)
                self.friendsResponse = response.response
            }
        }
    }
}

extension PageProfileViewModel: PageProfileViewModelType {
    func getHeaderProfile() -> HeaderProfileCellViewModelType? {
        guard let response = response else { return nil }
        let fullName = response.firstName + " " + response.lastName
        let headerProfile = HeaderProfileCellModel(iconUrl: response.photoUrl,
                                                   fullName: fullName,
                                                   userStatus: response.status ?? "")
        return headerProfile
    }
    
    func getBriefUserInfo() -> BriefUserInfoViewModelType? {
        guard let response = response else { return nil }
        let followes = response.followersCount != nil ? String(response.followersCount!) : ""
        let briefUserInfo = BriefUserInfoCellModel(city: response.HomeTown,
                                                   education: response.universityName,
                                                   work: nil,
                                                   followes: followes)
        return briefUserInfo
    }
    
    func getFriendsList() -> FriendsListViewModelType? {
        guard let response = friendsResponse else { return nil }
        let friendsList = response.items.map { user in
            return FriendCellViewModel(iconUrl: user.photoUrl,
                                       firstName: user.firstName,
                                       lastName: user.lastName)
        }
        
        let friendsListViewModel = FriendsList(countFriends: response.count, friendsList: friendsList)
        return friendsListViewModel
    }
    
    func loadProfileInfo() {
        self.getProfileInformation()
        self.getFriends()
    }
}
