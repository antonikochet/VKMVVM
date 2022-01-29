//
//  StaticSizesPageProfileCell.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 17.01.2022.
//

import UIKit

struct StaticSizesPageProfileCell {
    static let heigthHeaderProfileCell: CGFloat = 90
    static let heightBriefUserLabel: CGFloat = 30
    static let paddingBriefUserStack: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    static let spacingBriefUserLabel: CGFloat = 8
    static let heightFriendsCell: CGFloat = 160
    static let heightClosedCell: CGFloat = 120
    
    //MARK: - property view photos gallery profile 
    static let paddingPhotoGallery: UIEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    static let fontCellsLabel: UIFont = UIFont.systemFont(ofSize: 18, weight: .bold)
    static let paddingPhotoCollectionView: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    static let topConstantLabelInCollectionView: CGFloat = 4
    static let itemsPerRowInPhotosCollectionView: CGFloat = 3
    static let itemsInColumnPhotosCollectionView: CGFloat = 2
}
