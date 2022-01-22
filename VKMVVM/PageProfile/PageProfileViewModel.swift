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
    func getFriendsResponse() -> FriendsResponse?
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
    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMM yyyy г."
        return dateFormatter
    }()
    
    init(userId: String? = nil) {
        self.userId = userId
    }
    
    private func getProfileInformation() {
        let fieldsParams = UserRequestFieldsParams.allFieldsParams
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
        var params = [FriendsRequestParams.fields.rawValue: FriendsRequestFieldsParams.params([.photo100, .online, .city]),
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
                self.delegate?.didLoadData()
            }
        }
    }
    
    private func formatterOnlineStatus(user: UserResponse?) -> String {
        if user?.isOnline ?? false {
            return "online"
        } else if let lastSeen = user?.lastSeen {
            let date = Date(timeIntervalSince1970: TimeInterval(lastSeen.time))
            let nowDate = Date()
            let dateInterval = DateInterval(start: date, end: nowDate)
            let minutes = Int(dateInterval.duration) / 60
            let sexBeginString = user?.sex == 1 ? "была " : "был "
            var endString: String
            switch minutes {
                case 1: endString = "1 минуту назад"
                case 2...4: endString = "\(minutes) минуты назад"
                case 5...59: endString = "\(minutes) минут назад"
                case 60...60*2-1: endString = "\(minutes/60) час назад"
                case 60*2...60*5-1: endString = "\(minutes/60) часа назад"
                case 60*5...60*24: endString = "\(minutes/60) часов назад"
                default: endString = dateFormatter.string(from: date)
            }
            return sexBeginString + endString
        } else {
            return "offline"
        }
    }
}

extension PageProfileViewModel: PageProfileViewModelType {
    func getHeaderProfile() -> HeaderProfileCellViewModelType? {
        guard let response = response else { return nil }
        let fullName = response.firstName + " " + response.lastName
        let headerProfile = HeaderProfileCellModel(iconUrl: response.photoUrl,
                                                   fullName: fullName,
                                                   userStatus: response.status ?? "",
                                                   onlineStatus: formatterOnlineStatus(user: response))
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
            return FriendCellViewModel(id: user.id,
                                       iconUrl: user.photoUrl,
                                       firstName: user.firstName,
                                       lastName: user.lastName,
                                       isOnline: user.isOnline,
                                       isOnlineMobile: user.isOnlineMobile)
        }
        
        let friendsListViewModel = FriendsList(countFriends: response.count, friendsList: friendsList)
        return friendsListViewModel
    }
    
    func getFriendsResponse() -> FriendsResponse? {
        return friendsResponse
    }
    
    func loadProfileInfo() {
        self.getProfileInformation()
        self.getFriends()
    }
}
