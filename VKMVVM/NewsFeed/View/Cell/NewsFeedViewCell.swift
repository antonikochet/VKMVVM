//
//  NewsFeedViewCell.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 20.12.2021.
//

import UIKit

protocol NewsFeedModelItemType {
    var topModelView: TopRecordingModelViewType { get }
    var likes: String? { get }
    var isLiked: Bool { get }
    var isChangedLike: Bool { get }
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
    func showDetailGalleryPhotos(for cell: NewsFeedViewCell, at index: Int)
    func touchLikeNewsFeedPost(for cell: NewsFeedViewCell)
}

class NewsFeedViewCell: UITableViewCell {

    static let identifier = "NewsfeedViewCell"
    
    weak var delegate: NewsFeedCellDelegate?
    
    //MARK: - topView
    private let topView: TopRecordingView = {
        let view = TopRecordingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - bottomView
    private let likesView: LikesBottomView = {
        let view = LikesBottomView()
        view.addTarget(self, action: #selector(touchLikeButton), for: .touchUpInside)
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
        
        createBottomView()
        
        addSubview(topView)
        addSubview(contentPostView)
        addSubview(bottomView)
        
        contentPostView.addGestureRecognizerForAttachment(target: self,action: #selector(showDetailPhotoPost))
        
        topView.anchor(top: topAnchor,
                       leading: leadingAnchor,
                       bottom: nil,
                       trailing: trailingAnchor,
                       padding: UIEdgeInsets(top: StaticSizesNewsFeedCell.topConstraintTopView,
                                             left: 0, bottom: 0, right: 0))
        topView.heightAnchor.constraint(equalToConstant: StaticSizesNewsFeedCell.heightTopView).isActive = true
        
        contentPostView.anchor(top: topView.bottomAnchor,
                               leading: leadingAnchor,
                               bottom: bottomView.topAnchor,
                               trailing: trailingAnchor)
        
        bottomView.anchor(top: nil,
                          leading: leadingAnchor,
                          bottom: bottomAnchor,
                          trailing: trailingAnchor)
        bottomView.heightAnchor.constraint(equalToConstant: StaticSizesNewsFeedCell.heightBottomView).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(_ viewModel: NewsFeedModelItemType) {
        topView.set(modelView: viewModel.topModelView)
        likesView.set(text: viewModel.likes, isLiked: viewModel.isLiked, isChangedLike: viewModel.isChangedLike)
        commentsView.set(text: viewModel.comments)
        repostsView.set(text: viewModel.shares)
        viewsView.set(text: viewModel.views)
        
        contentPostView.set(modelView: viewModel.contentPost)
    }
    
    //MARK: - create bottom view
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
    
    @objc func showDetailPhotoPost() {
        delegate?.showDetailGalleryPhotos(for: self, at: 0)
    }
    
    @objc func touchLikeButton() {
        delegate?.touchLikeNewsFeedPost(for: self)
    }
}

extension NewsFeedViewCell: GalleryCollectionViewDelegate {
    func showDetailPhoto(at index: Int) {
        delegate?.showDetailGalleryPhotos(for: self, at: index)
    }
}
