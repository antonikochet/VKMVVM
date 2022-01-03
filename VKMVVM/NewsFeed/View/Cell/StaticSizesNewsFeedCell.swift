//
//  SizesNewsFeedCell.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 31.12.2021.
//

import UIKit

struct StaticSizesNewsFeedCell {
    //MARK: -  constant top view
    static let heightTopView: CGFloat = 36
    static let topConstraintTopView: CGFloat = 8
    
    //MARK: - constant content view
    static let postLabelFont = UIFont.systemFont(ofSize: 15)
    static let postLabelInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
    static let minimumLinesForMoreTextButton: CGFloat = 5
    static let minimumLimitLinesForMoreTextButton: CGFloat = 7
    static let moreTextButtonSize = CGSize(width: 170, height: 30)
    static let moreTextButtonInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    
    //MARK: - constant bottom view
    static let bottomConstraintContentView: CGFloat = 8
    static let heightBottomView: CGFloat = 44
    static let widthElementBottomView: CGFloat = 80
}
