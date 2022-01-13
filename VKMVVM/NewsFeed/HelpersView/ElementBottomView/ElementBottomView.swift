//
//  ElementBottomView.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 22.12.2021.
//

import UIKit

enum NameImageBottomView: String {
    case like = "heart"
    case comment = "bubble.left"
    case shares = "arrowshape.turn.up.right"
    case view = "eye.fill"
}

class ElementBottomView: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemGray2
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Label"
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var centerPositionSubviewsFlag: Bool
    
    init(nameImage: NameImageBottomView, centerPositionSubviewsFlag: Bool = false) {
        self.centerPositionSubviewsFlag = centerPositionSubviewsFlag
        super.init(frame: .zero)
        addSubview(imageView)
        addSubview(textLabel)
        
        let image = UIImage(systemName: nameImage.rawValue)
        image?.withRenderingMode(.alwaysOriginal)
        imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(text: String?) {
        textLabel.text = text
    }
    
    override func updateConstraints() {
        if centerPositionSubviewsFlag {
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -16).isActive = true
        } else {
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2).isActive = true
        }
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: StaticSizesNewsFeedCell.heightBottomView/2),
            imageView.widthAnchor.constraint(equalToConstant: StaticSizesNewsFeedCell.heightBottomView/2),
            
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            textLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 2),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)])
        
        super.updateConstraints()
    }
}
