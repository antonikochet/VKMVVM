//
//  NewsFeedModel.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 22.12.2021.
//

import Foundation

struct NewsFeedModel: NewsFeedModelItemType {
    var postId: Int
    
    var iconUrlString: String
    var name: String
    var date: String
    var text: String?
    var likes: String?
    var comments: String?
    var shares: String?
    var views: String?
    var contentPost: ContentModelViewType
    var photoAttachement: NewsFeedCellPhotoAttachementViewModelType?
}

struct NewsFeedContentPostModel: ContentModelViewType {
    var text: String?
    var photo: NewsFeedCellPhotoAttachementViewModelType?
    var sizes: NewsFeedCellContentSizesType
}

struct NewsFeedCellPhotoAttachmentModel: NewsFeedCellPhotoAttachementViewModelType {
    var photoURLString: String?
    var width: Int
    var height: Int
}


