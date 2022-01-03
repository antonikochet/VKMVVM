//
//  ContentView.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 31.12.2021.
//

import UIKit

protocol ContentModelViewType {
    var text: String? { get }
    var photo: NewsFeedCellPhotoAttachementViewModelType? { get }
    var sizes: NewsFeedCellContentSizesType { get }
}

protocol NewsFeedCellContentSizesType {
    var postLabelFrame: CGRect { get }
    var moreTextButtonFrame: CGRect { get }
    var attachmentFrame: CGRect { get }
    var totalHeight: CGFloat { get }
}

class NewsFeedContentPostView: UIView {

    private let postLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = StaticSizesNewsFeedCell.postLabelFont
        label.textColor = .black
        return label
    }()
    
    private let postImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(modelView: ContentModelViewType) {
        postLabel.text = modelView.text
        
        postLabel.frame = modelView.sizes.postLabelFrame
        postImageView.frame = modelView.sizes.attachmentFrame
        moreTextButton.frame = modelView.sizes.moreTextButtonFrame
        
        if let photoAttachment = modelView.photo {
            postImageView.set(imageURL: photoAttachment.photoURLString)
            postImageView.isHidden = false
        } else {
            postImageView.isHidden = true
        }
    }
    
    func addTargetMoreTextButton(_ target: Any?, selector: Selector) {
        moreTextButton.addTarget(target, action: selector, for: .touchUpInside)
    }
}
