//
//  NewsFeedModelView.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 15.12.2021.
//

import Foundation

protocol NewsFeedModelViewType {
    var count: Int { get }
    func getItem(by index: Int) -> NewsFeedModelItemType?
    func updateData()
    func revealPost(_ id: Int)
}

protocol NewsFeedModelViewDelegate: AnyObject {
    func willLoadData()
    func didLoadData()
    func showError(_ error: Error)
}

class NewsFeedModelView {
    
    weak var delegate: NewsFeedModelViewDelegate?
    
    private var cells: [NewsFeedModelItemType] = []
    private var responseData: NewsFeedResponse?
    
    private var revealPosts: [Int] = []
    
    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMM 'b' HH:mm"
        return dateFormatter
    }()
    
    private func getFeed() {
        let params = [NewsFeedFiltersParams.name: NewsFeedFiltersParams.params(.phone, .post)]
        APIManager.shader.request(path: .getNewsFeed, params: params) { data, error in
            self.delegate?.willLoadData()
            guard error == nil else {
                self.delegate?.showError(error!)
                return
            }
            if let data = data {
                let response = try! JSONDecoder().decode(NewsFeedResponseWrapped.self, from: data)
                self.responseData = response.response
                self.viewData()
                self.delegate?.didLoadData()
            }
        }

    }
    
    private func viewData() {
        guard let items = responseData?.items,
              let profiles = responseData?.profiles,
              let groups = responseData?.groups else { return }
        cells = items.map({ item in
            cellViewModel(from: item, profiles: profiles, groups: groups)
        })
    }
    
    private func cellViewModel(from item: NewsFeedItem, profiles: [Profile], groups: [Group]) -> NewsFeedModelItemType {
        let profile = getProfile(for: item.sourceId, profiles: profiles, groups: groups)
        let date = Date(timeIntervalSince1970: item.date)
        let dateTitle = dateFormatter.string(from: date)
        
        let postPhotos = photoAttachments(item: item)
        let isFullSized = revealPosts.contains(item.postId)
        
        let sizeContent = FeedCellCalculatorContentView().sizesContentView(post: item.text, photoAttachments: postPhotos, isFullSizedPost: isFullSized)
        
        let contentPost = NewsFeedContentPostModel(text: item.text, photos: postPhotos, sizes: sizeContent)
        
        return NewsFeedModel(postId: item.postId,
                             iconUrlString: profile.photo,
                             name: profile.name,
                             date: dateTitle,
                             likes: String(item.likes?.count ?? 0),
                             comments: String(item.comments?.count ?? 0),
                             shares: String(item.reposts?.count ?? 0),
                             views: String(item.views?.count ?? 0),
                             contentPost: contentPost)
                            
    }
    
    private func getProfile(for sourseId: Int, profiles: [Profile], groups: [Group]) -> ProfileRepresenatable {
        let profilesOrGroups: [ProfileRepresenatable] = sourseId >= 0 ? profiles : groups
        let normalSourseId = sourseId >= 0 ? sourseId : -sourseId
        let profileRepresenatable = profilesOrGroups.first { $0.id == normalSourseId }
        return profileRepresenatable!
    }
    
    private func photoAttachment(item: NewsFeedItem) -> NewsFeedCellPhotoAttachementViewModelType? {
        guard let photos = item.attachments?.compactMap({ (attachment) in
            attachment.photo
        }), let firstPhoto = photos.first else {
            return nil
        }
        return NewsFeedCellPhotoAttachmentModel(photoURLString: firstPhoto.srcBIG, width: firstPhoto.width, height: firstPhoto.height)
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

extension NewsFeedModelView: NewsFeedModelViewType {
    var count: Int {
        return cells.count
    }
    
    func getItem(by index: Int) -> NewsFeedModelItemType? {
        return index >= 0 && index < cells.count ? cells[index] : nil
    }
    
    func updateData() {
        getFeed()
    }
    
    func revealPost(_ id: Int) {
        revealPosts.append(id)
        viewData()
        delegate?.didLoadData()
    }
    
}
