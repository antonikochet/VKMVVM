//
//  NewsFeedViewCell.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 20.12.2021.
//

import UIKit

protocol NewsFeedModelItemType {
    var iconUrlString: String { get }
    var name: String { get }
    var date: String { get }
    var likes: String? { get }
    var comments: String? { get }
    var shares: String? { get }
    var views: String? { get }
    var contentPost: ContentModelViewType { get }
}

protocol NewsFeedCellPhotoAttachementViewModelType {
    var photoURLString: String? { get }
    var width: Int { get }
    var height: Int { get }
}

protocol NewsFeedCellDelegate: AnyObject {
    func revealPost(for cell: NewsFeedViewCell)
}

class NewsFeedViewCell: UITableViewCell {

    static let identifier = "NewsfeedViewCell"
    
    weak var delegate: NewsFeedCellDelegate?
    
    //MARK: - topView
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
    
    //MARK: - bottomView
    private let likesView: ElementBottomView = {
        let view = ElementBottomView(nameImage: .like)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let commentsView: ElementBottomView = {
        let view = ElementBottomView(nameImage: .comment)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let repostsView: ElementBottomView = {
        let view = ElementBottomView(nameImage: .shares)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewsView: ElementBottomView = {
        let view = ElementBottomView(nameImage: .view)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - contentView
    
    private let contentPostView: NewsFeedContentPostView = {
        let view = NewsFeedContentPostView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTargetMoreTextButton(self, selector: #selector(moreTextButtonTouch))
        return view
    }()
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        sendSubviewToBack(contentView)
        
        let topView = createTopView()
        createBottomView()
        
        addSubview(topView)
        addSubview(contentPostView)
        addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: topAnchor, constant: StaticSizesNewsFeedCell.topConstraintTopView),
            topView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: StaticSizesNewsFeedCell.heightTopView),
        
            contentPostView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentPostView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentPostView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            contentPostView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: StaticSizesNewsFeedCell.heightBottomView),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(_ viewModel: NewsFeedModelItemType) {
        iconImageView.set(imageURL: viewModel.iconUrlString)
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.date
        likesView.set(text: viewModel.likes)
        commentsView.set(text: viewModel.comments)
        repostsView.set(text: viewModel.shares)
        viewsView.set(text: viewModel.views)
        
        contentPostView.set(modelView: viewModel.contentPost)
    }
    
    //MARK: - create top and bottom views
    private func createTopView() -> UIView {
        let topView = UIView()
        topView.addSubview(iconImageView)
        topView.addSubview(nameLabel)
        topView.addSubview(dateLabel)
        topView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.layer.cornerRadius = StaticSizesNewsFeedCell.heightTopView/2
        iconImageView.clipsToBounds = true
        let topConstraintNameLabel: CGFloat = 2
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 8),
            iconImageView.topAnchor.constraint(equalTo: topView.topAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: StaticSizesNewsFeedCell.heightTopView),
            
            nameLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: topConstraintNameLabel),
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8),
            nameLabel.heightAnchor.constraint(equalToConstant: StaticSizesNewsFeedCell.heightTopView/2 - topConstraintNameLabel),
            
            dateLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -2),
            dateLabel.heightAnchor.constraint(equalToConstant: 14)
        ])

        return topView
    }
    
    private func createBottomView() {
        bottomView.addSubview(likesView)
        bottomView.addSubview(commentsView)
        bottomView.addSubview(repostsView)
        bottomView.addSubview(viewsView)
        
        NSLayoutConstraint.activate([
            likesView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            likesView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 8),
            likesView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
            likesView.widthAnchor.constraint(equalToConstant: StaticSizesNewsFeedCell.widthElementBottomView),
            
            commentsView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            commentsView.leadingAnchor.constraint(equalTo: likesView.trailingAnchor),
            commentsView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
            commentsView.widthAnchor.constraint(equalToConstant: StaticSizesNewsFeedCell.widthElementBottomView),
            
            repostsView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            repostsView.leadingAnchor.constraint(equalTo: commentsView.trailingAnchor),
            repostsView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
            repostsView.widthAnchor.constraint(equalToConstant: StaticSizesNewsFeedCell.widthElementBottomView),

            viewsView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            viewsView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            viewsView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
            viewsView.widthAnchor.constraint(equalToConstant: StaticSizesNewsFeedCell.widthElementBottomView)])
    }
    
    @objc func moreTextButtonTouch() {
        delegate?.revealPost(for: self)
    }
}
