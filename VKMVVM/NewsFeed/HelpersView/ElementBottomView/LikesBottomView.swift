//
//  LikesBottomView.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 10.02.2022.
//

import UIKit

class LikesBottomView: ElementBottomView {
    
    init(centerPositionSubviewsFlag: Bool = false) {
        super.init(nameImage: .like, centerPositionSubviewsFlag: centerPositionSubviewsFlag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(text: String?, isLiked: Bool, isChangedLike: Bool = false) {
        super.set(text: text)
        setupLikeImage(isLiked: isLiked, isChangedLike: isChangedLike)
    }
    
    private func setupLikeImage(isLiked: Bool, isChangedLike: Bool) {
        if isLiked {
            if isChangedLike {
                UIView.animateKeyframes(withDuration: 1.2, delay: 0, options: []) {
                    self.iconImageView.alpha = 0.0
                    self.putLike()
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.4) {
                        self.iconImageView.alpha = 1.0
                    }
                    UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.4) {
                        self.iconImageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    }
                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                        self.iconImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }
                }
            } else {
                putLike()
            }
        } else {
            if isChangedLike {
                UIView.transition(with: iconImageView, duration: 0.3, options: [.allowAnimatedContent, .transitionCrossDissolve]) {
                    self.unlike()
                }
            } else {
                unlike()
            }
        }
    }
    
    private func putLike() {
        iconImageView.tintColor = .red
        let image = UIImage(systemName: NameImage.fillLike.rawValue)?.withRenderingMode(.alwaysTemplate)
        iconImageView.image = image
    }
    
    private func unlike() {
        iconImageView.tintColor = .systemGray2
        let image = UIImage(systemName: NameImage.like.rawValue)?.withRenderingMode(.alwaysTemplate)
        iconImageView.image = image
    }
}

