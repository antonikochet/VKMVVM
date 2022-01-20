//
//  DetailInfoView.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 16.01.2022.
//

import UIKit

enum ContentDetailInfoView: String {
    case city = "house"
    case followers = "dot.radiowaves.up.forward"
    case education = "graduationcap"
    case work = "case"
    case information = "exclamationmark.circle.fill"
    
    var beginText: String {
        var text: String
        switch self {
            case .city:
                text = "Город"
            case .followers:
                text = "Подписчики"
            case .education:
                text = "Образование"
            case .work:
                text = "Работа"
            case .information:
                return "Подробная инофрмация"
        }
        return text + ": "
    }
}

class DetailInfoButton: UIControl {
    private var typeItem: ContentDetailInfoView
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(typeItem: ContentDetailInfoView, color: UIColor) {
        self.typeItem = typeItem
        super.init(frame: .zero)
        addSubview(imageView)
        addSubview(titleLabel)
        
        imageView.tintColor = color
        titleLabel.textColor = color
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: StaticSizesPageProfileCell.heightBriefUserLabel * 0.8),
            imageView.widthAnchor.constraint(equalToConstant: StaticSizesPageProfileCell.heightBriefUserLabel * 0.8),
            
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(text: String?) {
        let image = UIImage(systemName: typeItem.rawValue)?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        titleLabel.text = typeItem.beginText + (text ?? "")
    }
}
