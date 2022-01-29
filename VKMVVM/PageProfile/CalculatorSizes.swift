//
//  BriefUserInfoCalculatorSizes.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 17.01.2022.
//

import UIKit

struct CalculatorSizes {
    static func calculateSizeBriefUserInfo(viewModel: BriefUserInfoViewModelType) -> CGFloat {
        var count: CGFloat = 0
        count += viewModel.city != nil && !viewModel.city!.isEmpty ? 1 : 0
        count += viewModel.education != nil && !viewModel.education!.isEmpty ? 1 : 0
        count += viewModel.work != nil && !viewModel.work!.isEmpty ? 1 : 0
        count += viewModel.followes != nil && !viewModel.followes!.isEmpty ? 1 : 0
        
        let briefInfoButton = StaticSizesPageProfileCell.heightBriefUserLabel + StaticSizesPageProfileCell.spacingBriefUserLabel
        let paddingStackView = StaticSizesPageProfileCell.paddingBriefUserStack
        let height = paddingStackView.top + count * StaticSizesPageProfileCell.heightBriefUserLabel + paddingStackView.bottom + (count - 1) * StaticSizesPageProfileCell.spacingBriefUserLabel + briefInfoButton
        return height
    }
    
    static func calculateSizePhotosGalleryCell(widthSuperView: CGFloat) -> CGFloat {
        let heightCell = (StaticSizesPageProfileCell.topConstantLabelInCollectionView +
                          StaticSizesPageProfileCell.fontCellsLabel.lineHeight +
                          StaticSizesPageProfileCell.paddingPhotoCollectionView.top +
                          StaticSizesPageProfileCell.paddingPhotoCollectionView.bottom)
        
        let sizeCell = calculateSizeCellPhoto(widthSuperView: widthSuperView)
        
        let itemsInColomn = StaticSizesPageProfileCell.itemsInColumnPhotosCollectionView
        let paddingSpaceColomn = StaticSizesPageProfileCell.paddingPhotoGallery.top * (itemsInColomn + 1)
        let heightColomn = sizeCell.height * itemsInColomn + paddingSpaceColomn
        
        return heightCell + heightColomn
    }
    
    static func calculateSizeCellPhoto(widthSuperView: CGFloat) -> CGSize {
        let itemsPerRow = StaticSizesPageProfileCell.itemsPerRowInPhotosCollectionView
        let paddingSpace = StaticSizesPageProfileCell.paddingPhotoGallery.left * (itemsPerRow + 1)
        let availableWidth = widthSuperView - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}
