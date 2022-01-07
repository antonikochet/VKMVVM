//
//  ContentView.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 31.12.2021.
//

import UIKit

protocol ContentModelViewType {
    var text: String? { get }
    var photos: [NewsFeedCellPhotoAttachementViewModelType] { get }
    var sizes: NewsFeedCellContentSizesType { get }
}

protocol NewsFeedCellContentSizesType {
    var postLabelFrame: CGRect { get }
    var moreTextButtonFrame: CGRect { get }
    var attachmentFrame: CGRect { get }
    var totalHeight: CGFloat { get }
}

class NewsFeedContentPostView: UIView {

    private let postLabel: UITextView = {
        let textView = UITextView()
        textView.font = StaticSizesNewsFeedCell.postLabelFont
        textView.isScrollEnabled = false
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        
        let padding = textView.textContainer.lineFragmentPadding
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
        textView.dataDetectorTypes = UIDataDetectorTypes.all
        return textView
    }()
    
    private let postImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    
    private let galleryCollectionView = GalleryCollectionView()
    
    private let moreTextButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(UIColor(red: 102/255, green: 159/255, blue: 212/255, alpha: 1), for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .left
        button.setTitle("Показать полностью...", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(postLabel)
        addSubview(moreTextButton)
        addSubview(postImageView)
        addSubview(galleryCollectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(modelView: ContentModelViewType) {
        postLabel.text = modelView.text
        
        postLabel.frame = modelView.sizes.postLabelFrame
        moreTextButton.frame = modelView.sizes.moreTextButtonFrame
        
        if let photoAttachment = modelView.photos.first, modelView.photos.count == 1 {
            postImageView.set(imageURL: photoAttachment.photoURLString)
            postImageView.isHidden = false
            galleryCollectionView.isHidden = true
            postImageView.frame = modelView.sizes.attachmentFrame
            
        } else if modelView.photos.count > 1 {
            let galleryModelView = GalleryModelView(modelView.photos)
            galleryCollectionView.modelView = galleryModelView
            postImageView.isHidden = true
            galleryCollectionView.isHidden = false
            galleryCollectionView.frame = modelView.sizes.attachmentFrame
        } else {
            postImageView.isHidden = true
            galleryCollectionView.isHidden = true
        }
    }
    
    func addTargetMoreTextButton(_ target: Any?, selector: Selector) {
        moreTextButton.addTarget(target, action: selector, for: .touchUpInside)
    }
}
