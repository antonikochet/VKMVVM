//
//  ClosedTableViewCell.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 24.01.2022.
//

import UIKit

class ClosedTableViewCell: UITableViewCell {

    static let identifier = "ClosedTableViewCell"
    
    private let lockImageView: UIImageView = {
        let image = UIImage(systemName: "lock")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .systemGray3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = "Это закрытый профиль"
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let deletedLabel: UILabel = {
        let label = UILabel()
        label.text = "Профиль удален!"
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.addSubview(lockImageView)
        contentView.addSubview(warningLabel)
        contentView.addSubview(deletedLabel)
        
        contentView.backgroundColor = UIColor(named: "NewsFeedView")
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.fillSuperview(padding: UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15))
        
        lockImageView.anchor(top: contentView.topAnchor,
                             leading: contentView.leadingAnchor,
                             bottom: nil,
                             trailing: nil, padding: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 0))
        
        warningLabel.anchor(top: contentView.topAnchor,
                            leading: lockImageView.trailingAnchor,
                            bottom: nil,
                            trailing: contentView.trailingAnchor,
                            padding: UIEdgeInsets(top: 16, left: 8, bottom: 0, right: 0))
        
        NSLayoutConstraint.activate([
            lockImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            lockImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
        
            deletedLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            deletedLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        contentView.layer.cornerRadius = 15
    }
    
    func set(isDeleted: Bool) {
        if isDeleted {
            lockImageView.isHidden = true
            warningLabel.isHidden = true
            deletedLabel.isHidden = false
        } else {
            lockImageView.isHidden = false
            warningLabel.isHidden = false
            deletedLabel.isHidden = true
        }
    }
}
