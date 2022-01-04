//
//  NewsFeedCellLayoutCalculator.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 28.12.2021.
//

import UIKit

class FeedCellCalculatorContentView {
    struct NewsFeedContentSizes: NewsFeedCellContentSizesType {
        var postLabelFrame: CGRect
        var moreTextButtonFrame: CGRect
        var attachmentFrame: CGRect
        var totalHeight: CGFloat
    }
    
    func sizesContentView(post: String?, photoAttachments: [NewsFeedCellPhotoAttachementViewModelType], isFullSizedPost: Bool) -> NewsFeedCellContentSizesType {
        let screenWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        var showMoreTextButton = false
        
        // MARK: Работа с postLabelFrame
        
        var postLabelFrame: CGRect = CGRect(origin: CGPoint(x: StaticSizesNewsFeedCell.postLabelInsets.left,
                                                            y: StaticSizesNewsFeedCell.postLabelInsets.top),
                                            size: CGSize.zero)
        
        if let text = post, !text.isEmpty {
            let width = screenWidth - StaticSizesNewsFeedCell.postLabelInsets.left - StaticSizesNewsFeedCell.postLabelInsets.right
            var height = text.height(width: width, font: StaticSizesNewsFeedCell.postLabelFont)
            
            let limitHeight = StaticSizesNewsFeedCell.postLabelFont.lineHeight * StaticSizesNewsFeedCell.minimumLimitLinesForMoreTextButton
            
            if !isFullSizedPost && height > limitHeight {
                height = StaticSizesNewsFeedCell.postLabelFont.lineHeight * StaticSizesNewsFeedCell.minimumLinesForMoreTextButton
                showMoreTextButton = true
            }
            
            postLabelFrame.size = CGSize(width: width, height: height)
        }

        // MARK: Работа с moreTextButtonFrame
        
        var moreTextButtonSize = CGSize.zero
        
        if showMoreTextButton {
            moreTextButtonSize = StaticSizesNewsFeedCell.moreTextButtonSize
        }
        
        let moreTextButtonOrigin = CGPoint(x: StaticSizesNewsFeedCell.moreTextButtonInsets.left, y: postLabelFrame.maxY)
        
        let moreTextButtonFrame = CGRect(origin: moreTextButtonOrigin, size: moreTextButtonSize)
        
        // MARK: Работа с attachmentFrame
        
        let attachmentTop = postLabelFrame.size == CGSize.zero ? StaticSizesNewsFeedCell.postLabelInsets.top : StaticSizesNewsFeedCell.postLabelInsets.top + postLabelFrame.height + moreTextButtonFrame.height + StaticSizesNewsFeedCell.postLabelInsets.bottom

        var attachementFrame: CGRect = CGRect(origin: CGPoint(x: 0, y: attachmentTop),
                                              size: CGSize.zero)
        
        if let attachment = photoAttachments.first {
            let photoHeight: Float = Float(attachment.height)
            let photoWidth: Float = Float(attachment.width)
            let ratio = CGFloat(photoHeight / photoWidth)
            
            if photoAttachments.count == 1 {
                attachementFrame.size = CGSize(width: screenWidth, height: screenWidth * ratio)
            } else if photoAttachments.count > 1 {
                attachementFrame.size = CGSize(width: screenWidth, height: screenWidth * ratio)
            }
        }
        
        let totalHeight =   StaticSizesNewsFeedCell.topConstraintTopView +
                            StaticSizesNewsFeedCell.heightTopView +
                            attachmentTop +
                            attachementFrame.height +
                            (photoAttachments.first != nil ? StaticSizesNewsFeedCell.bottomConstraintContentView : 0) +
                            StaticSizesNewsFeedCell.heightBottomView
        
        return FeedCellCalculatorContentView.NewsFeedContentSizes(postLabelFrame: postLabelFrame,
                                                                  moreTextButtonFrame: moreTextButtonFrame,
                                                                  attachmentFrame: attachementFrame,
                                                                  totalHeight: totalHeight)
    }
}
