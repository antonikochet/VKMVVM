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
        
        NSLayoutConstraint.activate([
            lockImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            lockImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            lockImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            lockImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
        
            warningLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            warningLabel.leadingAnchor.constraint(equalTo: lockImageView.trailingAnchor, constant: 8),
            warningLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
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
