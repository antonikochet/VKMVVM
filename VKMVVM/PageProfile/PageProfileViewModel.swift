//
//  PageProfileViewModel.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 15.01.2022.
//

import Foundation

protocol PageProfileViewModelType {
    func loadProfileInfo()
    func loadPhotosProfileInfo()
    func getHeaderProfile() -> HeaderProfileCellViewModelType?
    func getBriefUserInfo() -> BriefUserInfoViewModelType?
    func getFriendsList() -> FriendsListViewModelType?
    func getFriendsResponse() -> FriendsResponse?
    func getGalleryPhotos() -> PhotoListViewModelType?
    var isClosed: Bool { get }
    var isDeleted: Bool { get }
    var nickName: String { get }
    var isProfileSpecificUser: Bool { get }
    var isEmptyPhotos: Bool { get }
}

protocol PageProfileViewModelDelegate: AnyObject {
    func didLoadData()
    func didPhotosProfile(photos: [Photo])
    func showError(error: Error)
}

class PageProfileViewModel {
    weak var delegate: PageProfileViewModelDelegate?
    
    private var response: UserResponse?
    private var friendsResponse: FriendsResponse?
    private var photosUserResponse: PhotosResponse?
    private var dataFetcher: DataFetcher
    
    private var userId: String?
    private var isClosePage: Bool = true
    private var isDeactivated: Bool = false
    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMM yyyy г."
        return dateFormatter
    }()
    
    init(userId: String? = nil, dataFetcher: DataFetcher = NetworkDataFetcher()) {
        self.userId = userId
        self.dataFetcher = dataFetcher
    }
    
    private func getProfileInformation() {
        let fieldsParams = UserRequestFieldsParams.allCases
        
        dataFetcher.getProfileInfo(userId: userId, fieldsParams: fieldsParams) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let response):
                    self.response = response.response.first
                    if let response = self.response {
                        self.isClosePage = !response.canAccessClosed
                        self.isDeactivated = response.deactivated != nil
                    }

                    self.delegate?.didLoadData()
                case .failure(let error):
                    self.delegate?.showError(error: error)
            }
        }
    }
    
    private func getFriends() {
        dataFetcher.getFriends(userId: userId, fieldsParams: [.photo100, .online, .city], orderParams: .hints) {  [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let response):
                    self.friendsResponse = response.response
                    self.friendsResponse?.userId = self.userId
                    self.delegate?.didLoadData()
                case .failure(let error):
                    if let deletedError = error as? ErrorResponse {
                        guard deletedError.errorCode != 18, deletedError.errorCode != 30 else { return }
                        self.delegate?.showError(error: error)
                    }
                    self.delegate?.showError(error: error)
            }
        }
    }
    
    private func getMainPhotosProfile() {
        dataFetcher.getPhotos(ownerId: userId, photoIds: nil, albumId: .profile, extended: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let response):
                    let photos = Array(response.response.items.reversed())
                    self.delegate?.didPhotosProfile(photos: photos)
                case .failure(let error):
                    self.delegate?.showError(error: error)
            }
        }
    }
    
    private func getFullPhotosUser() {
        dataFetcher.getAllPhotos(ownerId: userId, extended: true, count: nil) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let response):
                    self.photosUserResponse = response.response
                    self.delegate?.didLoadData()
                case .failure(let error):
                    self.delegate?.showError(error: error)
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
    
    func getGalleryPhotos() -> PhotoListViewModelType? {
        guard photosUserResponse?.count != 0 else { return nil }
        let photos = photosUserResponse?.items.map { photo in
            return DetailPhotoModel(photoUrlString: photo.srcBIG,
                                    likes: photo.likes?.count.description ?? "",
                                    comments: photo.comments?.count.description ?? "",
                                    reposts: photo.reposts?.count.description ?? "")} ?? []
        
        let photoList = PhotoList(countPhoto: photosUserResponse?.count.description ?? "",
                                  photoList: photos)
        
        return photoList
    }
    
    func loadProfileInfo() {
        self.getProfileInformation()
        self.getFriends()
        self.getFullPhotosUser()
    }
    
    func loadPhotosProfileInfo() {
        getMainPhotosProfile()
    }
    
    var isClosed: Bool {
        return isClosePage
    }
    
    var isDeleted: Bool {
        return isDeactivated
    }
    
    var nickName: String {
        return response?.screenName ?? ""
    }
    
    var isProfileSpecificUser: Bool {
        return (userId?.isEmpty ?? true)
    }
    
    var isEmptyPhotos: Bool {
        return (photosUserResponse?.count ?? 0) == 0 
    }
}
