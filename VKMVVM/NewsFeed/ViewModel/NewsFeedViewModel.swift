//
//  NewsFeedModelView.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 15.12.2021.
//

import Foundation

protocol NewsFeedViewModelType {
    var count: Int { get }
    func getItem(by index: Int) -> NewsFeedModelItemType?
    func getFirstData()
    func updateData()
    func getNextBatchNews()
    func revealPost(_ id: Int)
    func getPhotosFromItems(by index: Int) -> [Photo]
    func changedLikePost(by index: Int)
    
    var didLoadData: (() -> Void)? { get set }
    var changeLike: ((NewsFeedModelItemType, Int) -> Void)? { get set }
    var showError: ((String) -> Void)? { get set }
}

class NewsFeedViewModel {
    private var cells: [NewsFeedModelItemType] = []
    private var responseData: NewsFeedResponse?
    private var dataFetcher: DataFetcher
    private var newFromInProcess: String?
    
    private var revealPosts: [Int] = []
    
    var didLoadData: (() -> Void)?
    var changeLike: ((NewsFeedModelItemType, Int) -> Void)?
    var showError: ((String) -> Void)?
    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMM 'b' HH:mm"
        return dateFormatter
    }()
    
    init(dataFetcher: DataFetcher = NetworkDataFetcher()) {
        self.dataFetcher = dataFetcher
    }
    
    private func getNewsFeed(_ startFrom: String?) {
        let request = NewsFeedParams(filters: [.post, .phone],
                                        startFrom: startFrom)

        dataFetcher.getNewsFeed(parametrs: request) { result in
            switch result {
                case .success(let response):
                    self.updateResponseData(response.response)
                    self.viewData()
                    self.didLoadData?()
                case .failure(let error):
                    self.showError?(error.localizedDescription)
            }
        }
    }
    
    private func changeLikePost(ownerId: Int, itemId: Int, isLiked: Bool) {
        let request = LikesRequestParams(type: .post,
                                         ownerId: ownerId,
                                         itemId: itemId)
        let typeMethod: LikesTypeMethod = isLiked ? .delete : .add
        dataFetcher.handlingLike(type: typeMethod ,parametrs: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let responseWrapper):
                    let indexCell = self.cells.firstIndex(where: { ($0 as! NewsFeedModel).postId == itemId })
                    if let indexCell = indexCell {
                        var viewModel = self.cells[indexCell] as! NewsFeedModel
                        viewModel.likes = String(responseWrapper.response.likes)
                        viewModel.isLiked = !viewModel.isLiked
                        self.cells[indexCell] = viewModel
                        viewModel.isChangedLike = true
                        self.changeLike?(viewModel, indexCell)
                    }
                case .failure(let error):
                    self.showError?(error.localizedDescription)
            }
        }
    }
    
    private func updateResponseData(_ newResponse: NewsFeedResponse?) {
        if responseData == nil {
            responseData = newResponse
            newFromInProcess = newResponse?.nextFrom
        } else {
            guard newResponse?.nextFrom != responseData?.nextFrom, let newResponse = newResponse else { return }
            responseData?.items.append(contentsOf: newResponse.items)
        
            var profiles = newResponse.profiles
            if let oldProfiles = self.responseData?.profiles {
                let oldProfilesFiltered = oldProfiles.filter { oldProfile in
                    !newResponse.profiles.contains { $0.id == oldProfile.id } }
                profiles.append(contentsOf: oldProfilesFiltered)
            }
            responseData?.profiles = profiles
            
            var groups = newResponse.groups
            if let oldGroups = self.responseData?.groups {
                let oldGroupsFiltered = oldGroups.filter { oldGroup in
                    !newResponse.profiles.contains { $0.id == oldGroup.id } }
                groups.append(contentsOf: oldGroupsFiltered)
            }
            responseData?.groups = groups
            
            responseData?.nextFrom = newResponse.nextFrom
            newFromInProcess = newResponse.nextFrom
        }
        
    }
    
    private func viewData() {
        guard let items = responseData?.items,
              let profiles = responseData?.profiles,
              let groups = responseData?.groups else { return }
        cells = items.map({ item in
            cellViewModel(from: item, profiles: profiles, groups: groups)
        }).filter {
            $0.contentPost.photos.count != 0 && !$0.contentPost.text!.isEmpty
        }
    }
    
    private func cellViewModel(from item: NewsFeedItem, profiles: [Profile], groups: [Group]) -> NewsFeedModelItemType {
        let profile = getProfile(for: item.sourceId, profiles: profiles, groups: groups)
        let date = Date(timeIntervalSince1970: item.date)
        let dateTitle = dateFormatter.string(from: date)
        
        let topModelView = TopRecordingModel(iconUrlString: profile.photo, name: profile.name, date: dateTitle)
        
        let postPhotos = photoAttachments(item: item)
        let isFullSized = revealPosts.contains(item.postId)
        
        let sizeContent = FeedCellCalculatorContentView().sizesContentView(post: item.text, photoAttachments: postPhotos, isFullSizedPost: isFullSized)
        
        let contentPost = NewsFeedContentPostModel(text: item.text, photos: postPhotos, sizes: sizeContent)
        
        return NewsFeedModel(postId: item.postId,
                             ownerId: item.sourceId,
                             topModelView: topModelView,
                             likes: formatterCounter(item.likes?.count),
                             isLiked: item.likes?.isLiked ?? false,
                             isChangedLike: false,
                             comments: formatterCounter(item.comments?.count),
                             shares: formatterCounter(item.reposts?.count),
                             views: formatterCounter(item.views?.count),
                             contentPost: contentPost)
                            
    }
    
    private func formatterCounter(_ counter: Int?) -> String? {
        guard let counter = counter else { return nil }
        var counterString = String(counter)
        if 4...6 ~= counterString.count {
            counterString = String(counterString.dropLast(3)) + "K"
        } else if counterString.count > 6 {
            counterString = String(counterString.dropLast(6)) + "M"
        }
        return counterString
    }
    
    private func getProfile(for sourseId: Int, profiles: [Profile], groups: [Group]) -> ProfileRepresenatable {
        let profilesOrGroups: [ProfileRepresenatable] = sourseId >= 0 ? profiles : groups
        let normalSourseId = sourseId >= 0 ? sourseId : -sourseId
        let profileRepresenatable = profilesOrGroups.first { $0.id == normalSourseId }
        return profileRepresenatable!
    }
    
    private func photoAttachments(item: NewsFeedItem) -> [NewsFeedCellPhotoAttachementViewModelType] {
        guard let attachments = item.attachments else { return [] }
        
        return attachments.compactMap { (attachment) -> NewsFeedCellPhotoAttachementViewModelType? in
            guard let photo = attachment.photo else { return nil }
            return NewsFeedCellPhotoAttachmentModel(photoURLString: photo.srcBIG,
                                                    width: photo.width,
                                                    height: photo.height)
        }
    }
}

extension NewsFeedViewModel: NewsFeedViewModelType {
    var count: Int {
        return cells.count
    }
    
    func getItem(by index: Int) -> NewsFeedModelItemType? {
        return index >= 0 && index < cells.count ? cells[index] : nil
    }
    
    func updateData() {
        newFromInProcess = nil
        responseData = nil
        getNewsFeed(nil)
    }
    
    func revealPost(_ id: Int) {
        revealPosts.append(id)
        viewData()
        didLoadData?()
    }
    
    func getFirstData() {
        getNewsFeed(nil)
    }
    
    func getNextBatchNews() {
        getNewsFeed(newFromInProcess)
    }
    
    func getPhotosFromItems(by index: Int) -> [Photo] {
        guard let cell = cells[index] as? NewsFeedModel,
              let item = responseData?.items.first(where: { return $0.postId == cell.postId }),
              let photos = item.attachments?.compactMap({ return $0.photo }) else { return [] }
        return photos
    }
    
    func changedLikePost(by index: Int) {
        guard let cell = cells[index] as? NewsFeedModel else { return }
        let isLiked = cell.isLiked
        let ownerId = cell.ownerId
        let itemId = cell.postId
        changeLikePost(ownerId: ownerId, itemId: itemId, isLiked: isLiked)
    }
}
