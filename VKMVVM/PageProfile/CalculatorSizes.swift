//
//  BriefUserInfoCalculatorSizes.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 17.01.2022.
//

import UIKit

struct CalculatorSizes {
    static func calculateSizeBriefUserInfo(viewModel: BriefUserInfoViewModelType) -> Int {
        var count: CGFloat = 0
        count += viewModel.city != nil && !viewModel.city!.isEmpty ? 1 : 0
        count += viewModel.education != nil && !viewModel.education!.isEmpty ? 1 : 0
        count += viewModel.work != nil && !viewModel.work!.isEmpty ? 1 : 0
        count += viewModel.followes != nil && !viewModel.followes!.isEmpty ? 1 : 0
        
        let briefInfoButton = StaticSizesPageProfileCell.heightBriefUserLabel + StaticSizesPageProfileCell.spacingBriefUserLabel
        let paddingStackView = StaticSizesPageProfileCell.paddingBriefUserStack
        let height = paddingStackView.top + count * StaticSizesPageProfileCell.heightBriefUserLabel + paddingStackView.bottom + (count - 1) * StaticSizesPageProfileCell.spacingBriefUserLabel + briefInfoButton
        return Int(height)
    }
}
