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
    
    struct BasicInfoModel: BasicInfoDetailInfoProfileCellViewModelType {
        var homeTown: String?
        var language: String?
        var parents: String?
        var siblings: String?
        var children: String?
        
        var isView: Bool {
            (homeTown != nil) ||
            (language != nil) ||
            (parents != nil) ||
            (siblings != nil) ||
            (children != nil)
        }
    }
}
