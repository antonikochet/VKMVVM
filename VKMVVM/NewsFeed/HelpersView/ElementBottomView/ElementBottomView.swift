//
//  ElementBottomView.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 22.12.2021.
//

import UIKit

class ElementBottomView: UIButton {

    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemGray2
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Label"
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var centerPositionSubviewsFlag: Bool
    
    init(nameImage: NameImage, centerPositionSubviewsFlag: Bool = false) {
        self.centerPositionSubviewsFlag = centerPositionSubviewsFlag
        super.init(frame: .zero)
        addSubview(iconImageView)
        addSubview(textLabel)
        
        let image = UIImage(systemName: nameImage.rawValue)
        image?.withRenderingMode(.alwaysOriginal)
        iconImageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(text: String?) {
        textLabel.text = text
    }
    
    override func updateConstraints() {
        if centerPositionSubviewsFlag {
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -16).isActive = true
        } else {
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2).isActive = true
        }
        
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: StaticSizesNewsFeedCell.heightBottomView/2),
            iconImageView.widthAnchor.constraint(equalToConstant: StaticSizesNewsFeedCell.heightBottomView/2),
            
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            textLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 2),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)])
        
        super.updateConstraints()
    }
}

extension ElementBottomView {
    enum NameImage: String {
        case like = "heart"
        case comment = "bubble.left"
        case shares = "arrowshape.turn.up.right"
        case view = "eye.fill"
        case fillLike = "heart.fill"
    }
}
