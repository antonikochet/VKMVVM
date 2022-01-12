//
//  TopRecordingView.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 07.01.2022.
//

import UIKit

protocol TopRecordingModelViewType {
    var iconUrlString: String { get }
    var name: String { get }
    var date: String { get }
}

class TopRecordingView: UIView {

    private let iconImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.backgroundColor = .blue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray2
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iconImageView)
        addSubview(nameLabel)
        addSubview(dateLabel)
        
        iconImageView.layer.cornerRadius = StaticSizesNewsFeedCell.heightTopView/2
        iconImageView.clipsToBounds = true
        let topConstraintNameLabel: CGFloat = 2
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: StaticSizesNewsFeedCell.heightTopView),
            
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: topConstraintNameLabel),
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            nameLabel.heightAnchor.constraint(equalToConstant: StaticSizesNewsFeedCell.heightTopView/2 - topConstraintNameLabel),
            
            dateLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            dateLabel.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(modelView: TopRecordingModelViewType) {
        iconImageView.set(imageURL: modelView.iconUrlString)
        nameLabel.text = modelView.name
        dateLabel.text = modelView.date
    }
}
