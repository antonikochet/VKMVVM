//
//  FollowerTableViewCell.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 25.01.2022.
//

import UIKit

protocol FollowerTableCellViewModelType {
    var iconUrl: String? { get }
    var fullName: String { get }
}

class FollowerTableViewCell: UITableViewCell {

    static let identifier = "FollowerTableViewCell"
    
    private let iconFollowerImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.backgroundColor = UIColor(named:"ColorVK")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameFollowerlabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.addSubview(iconFollowerImageView)
        contentView.addSubview(nameFollowerlabel)
        
        let paddingIcon: CGFloat = 2
        NSLayoutConstraint.activate([
            iconFollowerImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: paddingIcon),
            iconFollowerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: paddingIcon),
            iconFollowerImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -paddingIcon * 2),
            iconFollowerImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, constant: -paddingIcon * 2),
        
            nameFollowerlabel.leadingAnchor.constraint(equalTo: iconFollowerImageView.trailingAnchor, constant: 8),
            nameFollowerlabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameFollowerlabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconFollowerImageView.clipsToBounds = true
        iconFollowerImageView.layer.cornerRadius = iconFollowerImageView.frame.height / 2
    }
    func set(viewModel: FollowerTableCellViewModelType) {
        iconFollowerImageView.set(imageURL: viewModel.iconUrl)
        nameFollowerlabel.text = viewModel.fullName
    }
}
