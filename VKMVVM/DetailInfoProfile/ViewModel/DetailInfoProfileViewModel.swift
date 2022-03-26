//
//  DetailInfoProfileViewModel.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 12.02.2022.
//

import Foundation

class DetailInfoProfileViewModel {
    
    var didLoadData: (() -> Void)?
    var showError: ((String) -> Void)?
    
    private var dataFetcher: DataFetcher
    
    private var statusUser: StatusDetailInfoProfileCellViewModelType?
    private var briefInfoUser: BriefDetailInfoProfileCellViewModelType?
    private var basicInfoUser: BasicInfoDetailInfoProfileCellViewModelType?
    
    private var user: UserResponse
    
    init(_ user: UserResponse, dataFetcher: DataFetcher = NetworkDataFetcher()) {
        self.dataFetcher = dataFetcher
        self.user = user
        if !(user.relatives?.isEmpty ?? true),
           let ids = user.relatives?.compactMap({ $0.id }) {
            getUsersData(ids: ids)
        }
        formatterData()
    }
    
    private func formatterData() {
        if let status = user.status, !status.isEmpty {
            statusUser = DetailInfoProfileModel.StatusCellModel(status: status)
        }
        briefInfoUser = DetailInfoProfileModel.BriefCellModel(birthday: user.birthdayData, //TODO: добавить метод изменения строки вывода на экран
                                                              city: user.city?.title,
                                                              familyStatus: user.relation?.getStatus(sex: user.sex),
                                                              followers: String(user.followersCount ?? 0))
        formatterBasicInfoUser(relativesUser: [:])
        didLoadData?()
    }
    
    private func formatterBasicInfoUser(relativesUser: [Int: String]) {
        let parents = getNameRelatives(relativesUser: relativesUser, type: .parent)
        let siblings = getNameRelatives(relativesUser: relativesUser, type: .sibling)
        let children = getNameRelatives(relativesUser: relativesUser, type: .child)
        
        basicInfoUser = DetailInfoProfileModel.BasicInfoModel(homeTown: user.homeTown,
                                                              language: user.personal?.langs?.joined(separator: ", "),
                                                              parents: parents,
                                                              siblings: siblings,
                                                              children: children)
    }
    
    private func getNameRelatives(relativesUser: [Int: String], type: RelativesType) -> String? {
        var relativesNameString = user.relatives?.compactMap { $0.name }
                                                 .joined(separator: ", ")
        relativesNameString = user.relatives?.filter { $0.type == type }
                                             .compactMap { $0.id != nil ? relativesUser[$0.id!] : nil }
                                             .joined(separator: ", ")
        return relativesNameString
    }
    
    private func getUsersData(ids: [Int]) {
        guard !ids.isEmpty else { return }
        let params = UserRequestParams(userIds: ids.map { String($0) }.joined(separator: ","),
                                       fields: [])
        dataFetcher.getProfileInfo(parametrs: params) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let response):
                    var relativesUser: [Int: String] = [:]
                    response.response.forEach { user in
                        relativesUser.updateValue("\(user.firstName) \(user.lastName)", forKey: user.id)
                    }
                    self.formatterBasicInfoUser(relativesUser: relativesUser)
                    self.didLoadData?()
                case .failure(let error):
                    self.showError?(error.localizedDescription)
            }
        }
    }
}

extension DetailInfoProfileViewModel: DetailInfoProfileViewModelType {
    var count: Int {
        var count = 0
        count += statusUser != nil ? 1 : 0
        count += briefInfoUser != nil ? 1 : 0
        count += basicInfoUser != nil &&
                 (basicInfoUser as! DetailInfoProfileModel.BasicInfoModel).isView ? 1 : 0
        return count
    }
    
    func getDataForCell(at index: Int) -> DetailInfoProfileCell {
        switch index {
            case 0:
                return statusUser != nil ? .status(statusUser) : .briefInfo(briefInfoUser)
            case 1:
                return statusUser != nil ? .briefInfo(briefInfoUser) : .basicInfo(basicInfoUser)
            case 2:
                return statusUser != nil &&
                       (basicInfoUser as! DetailInfoProfileModel.BasicInfoModel).isView ? .basicInfo(basicInfoUser) : .none
            default:
                return .none
        }
    }
}

