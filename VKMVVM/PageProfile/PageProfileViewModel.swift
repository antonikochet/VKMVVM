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
    func getFriendsUser() -> [UserResponse]
    func getGalleryPhotos() -> PhotoListViewModelType?
    func showDetailGalleryPhotos() -> [Photo]
    func getUserResponseForDetailInfoProfile() -> UserResponse?
    func getUserId() -> String?
    var isClosed: Bool? { get }
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
    
    private var dataFetcher: DataFetcher
    private var dispatchGroup = DispatchGroup()
    
    private var userId: String?
    private var screenName: String?
    private var isClosePage: Bool?
    private var isDeactivated: Bool = false
    
    private var headerModel: HeaderProfileCellModel?
    private var briefUserInfoModel: BriefUserInfoViewModelType?
    private var friendsModel: FriendsListViewModelType?
    private var friendsUserResponse: [UserResponse] = []
    private var userPhotosModel: PhotoListViewModelType?
    private var photosUser: [Photo] = []
    private var userResponse: UserResponse?
    
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
    
    //MARK: - methods for get data from API
    private func getProfileInformation() {
        let fieldsParams = UserRequestFieldsParams.allCases
        let request = UserRequestParams(userIds: userId,
                                        fields: fieldsParams)
        dispatchGroup.enter()
        dataFetcher.getProfileInfo(parametrs: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let responseWrapper):
                    let response = responseWrapper.response.first
                    if let response = response {
                        self.isClosePage = !response.canAccessClosed
                        self.isDeactivated = response.deactivated != nil
                        self.screenName = response.screenName
                        self.userResponse = response
                        self.formatterProfileInfo(user: response)
                        self.formatterBriefUserInfo(user: response)
                    }
                case .failure(let error):
                    self.delegate?.showError(error: error)
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func getFriends() {
        let request = FriendsRequestParams(userId: userId,
                                           order: .hints,
                                           count: nil,
                                           offset: nil,
                                           fields: [.photo100, .online, .city])
        dispatchGroup.enter()
        dataFetcher.getFriends(parametrs: request) {  [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let responseWrapper):
                    self.formatterFriends(friends: responseWrapper.response)
                case .failure(let error):
                    if let deletedError = error as? ErrorResponse {
                        guard deletedError.errorCode != 18, deletedError.errorCode != 30 else {
                            self.dispatchGroup.leave()
                            return
                        }
                        self.delegate?.showError(error: error)
                    }
                    self.delegate?.showError(error: error)
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func getMainPhotosProfile() {
        let requestParams = PhotosRequestParams(ownerId: userId,
                                                photoIds: nil,
                                                albumId: .profile,
                                                extended: true)
        dataFetcher.getPhotos(parametrs: requestParams) { [weak self] result in
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
        let requestParams = GetAllPhotosRequestParams(ownerId: userId,
                                                      offset: nil,
                                                      count: 20,
                                                      extended: true,
                                                      skipHidden: false)
        dispatchGroup.enter()
        dataFetcher.getAllPhotos(parametrs: requestParams) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let responseWrapper):
                    self.formatterUserPhotos(photosResponse: responseWrapper.response)
                    self.delegate?.didLoadData()
                case .failure(let error):
                    if let deletedError = error as? ErrorResponse {
                        guard deletedError.errorCode != 18, deletedError.errorCode != 30 else {
                            self.dispatchGroup.leave()
                            return
                        }
                        self.delegate?.showError(error: error)
                    }
                    self.delegate?.showError(error: error)
            }
            self.dispatchGroup.leave()
        }
    }
    
    //MARK: - data preparation methods
    private func formatterProfileInfo(user: UserResponse) {
        let fullName = user.firstName + " " + user.lastName
        headerModel = HeaderProfileCellModel(iconUrl: user.photoUrl,
                                                   fullName: fullName,
                                                   userStatus: user.status ?? "",
                                                   onlineStatus: formatterOnlineStatus(user: user))
    }
    
    private func formatterBriefUserInfo(user: UserResponse) {
        let followes = user.followersCount != nil ? String(user.followersCount!) : ""
        briefUserInfoModel = BriefUserInfoCellModel(city: user.HomeTown,
                                                   education: user.universityName,
                                                   work: nil,
                                                   followes: followes)
    }
    
    private func formatterFriends(friends: FriendsResponse) {
        let friendsList = friends.items.map { user in
            return FriendCellViewModel(id: user.id,
                                       iconUrl: user.photoUrl,
                                       firstName: user.firstName,
                                       lastName: user.lastName,
                                       isOnline: user.isOnline,
                                       isOnlineMobile: user.isOnlineMobile)
        }
        friendsUserResponse = friends.items
        friendsModel = FriendsList(countFriends: friends.count, friendsList: friendsList)
    }
    
    private func formatterUserPhotos(photosResponse: PhotosResponse) {
        let photosModel = photosResponse.items.map { photo in
            DetailPhotoModel(id: photo.id,
                             ownerId: photo.ownerId,
                             photoUrlString: photo.srcBIG,
                             likes: photo.likes?.count.description ?? "",
                             isLiked: photo.likes?.isLiked ?? false,
                             isChangedLike: false,
                             comments: photo.comments?.count.description ?? "",
                             reposts: photo.reposts?.count.description ?? "")}
        
        photosUser = photosResponse.items
        userPhotosModel = PhotoList(countPhoto: String(photosUser.count),
                                  photoList: photosModel)
    }
    
    private func formatterOnlineStatus(user: UserResponse) -> String {
        if user.isOnline {
            return "online"
        } else if let lastSeen = user.lastSeen {
            let date = Date(timeIntervalSince1970: TimeInterval(lastSeen.time))
            let nowDate = Date()
            let dateInterval = DateInterval(start: date, end: nowDate)
            let minutes = Int(dateInterval.duration) / 60
            let sexBeginString = user.sex == 1 ? "была " : "был "
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
        return headerModel
    }
    
    func getBriefUserInfo() -> BriefUserInfoViewModelType? {
        return briefUserInfoModel
    }
    
    func getFriendsList() -> FriendsListViewModelType? {
        return friendsModel
    }
    
    func getFriendsUser() -> [UserResponse] {
        return friendsUserResponse
    }
    
    func getGalleryPhotos() -> PhotoListViewModelType? {
        guard userPhotosModel?.photoList.count != 0 else { return nil }
        return userPhotosModel
    }
    
    func showDetailGalleryPhotos() -> [Photo] {
        return photosUser
    }

    func getUserResponseForDetailInfoProfile() -> UserResponse? {
        return userResponse
    }
    
    func loadProfileInfo() {
        self.getProfileInformation()
        self.getFriends()
        self.getFullPhotosUser()
        dispatchGroup.notify(queue: .main) {
            self.delegate?.didLoadData()
        }
    }
    
    func loadPhotosProfileInfo() {
        getMainPhotosProfile()
    }
    
    func getUserId() -> String? {
        return userId
    }
    
    var isClosed: Bool? {
        return isClosePage
    }
    
    var isDeleted: Bool {
        return isDeactivated
    }
    
    var nickName: String {
        return screenName ?? ""
    }
    
    var isProfileSpecificUser: Bool {
        return (userId?.isEmpty ?? true)
    }
    
    var isEmptyPhotos: Bool {
        return (userPhotosModel?.photoList.count ?? 0) == 0
    }
}
