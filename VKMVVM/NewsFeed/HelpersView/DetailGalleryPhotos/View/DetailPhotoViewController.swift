//
//  DetailPhotoViewController.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 12.01.2022.
//

import UIKit

protocol DetailPhotoViewModelType {
    var photoUrlString: String? { get }
    var likes: String { get }
    var isLiked: Bool { get }
    var isChangedLike: Bool { get }
    var comments: String { get }
    var reposts: String { get }
}

class DetailPhotoViewController: UIViewController {
    var modelView: DetailPhotoViewModelType? {
        didSet {
            set()
        }
    }
    
    var pageNumber: Int = 0

    private let imageView: WebImageView = {
        let imageView = WebImageView()
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    private func set() {
        imageView.set(imageURL: modelView?.photoUrlString)
    }
}
