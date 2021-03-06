//
//  NewsFeedModel.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 22.12.2021.
//

import Foundation

struct NewsFeedModel: NewsFeedModelItemType {
    var postId: Int
    var ownerId: Int
    
    var topModelView: TopRecordingModelViewType
    var likes: String?
    var isLiked: Bool
    var isChangedLike: Bool
    var comments: String?
    var shares: String?
    var views: String?
    var contentPost: ContentModelViewType
}

struct NewsFeedContentPostModel: ContentModelViewType {
    var text: String?
    var photos: [NewsFeedCellPhotoAttachementViewModelType]
    var sizes: NewsFeedCellContentSizesType
}

struct NewsFeedCellPhotoAttachmentModel: NewsFeedCellPhotoAttachementViewModelType {
    var photoURLString: String?
    var width: Int
    var height: Int
}


