//
//  PhotosGalleryProfileViewCell.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 26.01.2022.
//

import UIKit

protocol PhotoListViewModelType {
    var countPhoto: String { get }
    var photoList: [DetailPhotoViewModelType] { get }
}

class PhotosGalleryProfileViewCell: UITableViewCell {

    static let identifier = "PhotosGalleryProfileViewCell"
    
    private var viewModel: PhotoListViewModelType? {
        didSet {
            photosCollectionView.reloadData()
        }
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "ФОТОГРАФИИ"
        label.translatesAutoresizingMaskIntoConstraints  = false
        label.font = StaticSizesPageProfileCell.fontCellsLabel
        return label
    }()
    
    private let countPhotosLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collView.showsHorizontalScrollIndicator = false
        collView.showsVerticalScrollIndicator = false
        collView.isScrollEnabled = false
        collView.translatesAutoresizingMaskIntoConstraints = false
        return collView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.addSubview(label)
        contentView.addSubview(countPhotosLabel)
        contentView.addSubview(photosCollectionView)
        
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        
        let paddingCollView = StaticSizesPageProfileCell.paddingPhotoCollectionView
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: StaticSizesPageProfileCell.topConstantLabelInCollectionView),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            countPhotosLabel.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8),
            countPhotosLabel.centerYAnchor.constraint(equalTo: label.centerYAnchor),

            photosCollectionView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: paddingCollView.top),
            photosCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: paddingCollView.left),
            photosCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -paddingCollView.right),
            photosCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -paddingCollView.bottom)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(viewModel: PhotoListViewModelType) {
        countPhotosLabel.text = viewModel.countPhoto
        self.viewModel = viewModel
    }
}

extension PhotosGalleryProfileViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photoList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        if let photoViewModel = viewModel?.photoList[indexPath.row] {
            cell.set(imageURL: photoViewModel.photoUrlString)
        }
        return cell
    }
}

extension PhotosGalleryProfileViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CalculatorSizes.calculateSizeCellPhoto(widthSuperView: frame.width - (StaticSizesPageProfileCell.paddingPhotoCollectionView.left + StaticSizesPageProfileCell.paddingPhotoCollectionView.right))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return StaticSizesPageProfileCell.paddingPhotoGallery.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return StaticSizesPageProfileCell.paddingPhotoGallery
    }
}
