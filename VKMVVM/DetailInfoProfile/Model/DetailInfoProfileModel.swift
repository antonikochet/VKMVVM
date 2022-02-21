//
//  DetailInfoProfileModel.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 12.02.2022.
//

import Foundation

struct DetailInfoProfileModel {
    struct StatusCellModel: StatusDetailInfoProfileCellViewModelType {
        var status: String
    }
    
    struct BriefCellModel: BriefDetailInfoProfileCellViewModelType {
        var birthday: String?
        var city: String?
        var familyStatus: String?
        var followers: String?
    }
}
