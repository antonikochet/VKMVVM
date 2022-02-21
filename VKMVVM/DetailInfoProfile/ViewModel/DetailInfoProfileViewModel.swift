//
//  DetailInfoProfileViewModel.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 12.02.2022.
//

import Foundation

class DetailInfoProfileViewModel {
    
    private var statusUser: StatusDetailInfoProfileCellViewModelType?
    private var briefInfoUser: BriefDetailInfoProfileCellViewModelType?
    
    init(_ user: UserResponse) {
        formatterData(user: user)
    }
    
    private func formatterData(user: UserResponse) {
        if let status = user.status, !status.isEmpty {
            statusUser = DetailInfoProfileModel.StatusCellModel(status: status)
        }
        briefInfoUser = DetailInfoProfileModel.BriefCellModel(birthday: user.birthdayData, //TODO: добавить метод изменения строки вывода на экран
                                                              city: user.city?.title,
                                                              familyStatus: user.relation?.getStatus(sex: user.sex),
                                                              followers: String(user.followersCount ?? 0))
    }
}

extension DetailInfoProfileViewModel: DetailInfoProfileViewModelType {
    var count: Int {
        var count = 0
        count += statusUser != nil ? 1 : 0
        count += briefInfoUser != nil ? 1 : 0
        return count
    }
    
    func getDataForCell(at index: Int) -> DetailInfoProfileCell {
        switch index {
            case 0:
                return statusUser != nil ? .status(statusUser) : .briefInfo(briefInfoUser)
            case 1:
                return statusUser != nil ? .briefInfo(briefInfoUser) : .none
            default:
                return .none
        }
    }
}

