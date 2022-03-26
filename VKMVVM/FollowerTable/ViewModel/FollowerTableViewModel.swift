//
//  FollowerTableViewModel.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 25.01.2022.
//

import Foundation

protocol FollowerTableViewModelType {
    var count: Int { get }
    func getItem(at index: Int) -> FollowerTableCellViewModelType
    func startLoadData()
    
    var didLoadData: (() -> Void)? { get set }
    var showError: ((String) -> Void)? { get set }
}

class FollowerTableViewModel {
    var didLoadData: (() -> Void)?
    var showError: ((String) -> Void)?
    
    private var cells: [FollowerTableCellViewModelType] = []
    private var dataFetcher: DataFetcher
    private var userId: String?
    
    init(userId: String?, dataFetcher: DataFetcher = NetworkDataFetcher()) {
        self.userId = userId
        self.dataFetcher = dataFetcher
    }
    
    private func getFollowers() {
        let requestParametrs = UsersGetFollowersRequestParams(userId: userId,
                                                              fields: [.online, .photo100])
        dataFetcher.getFollowers(parametrs: requestParametrs) { result in
            switch result {
                case .success(let response):
                    self.cells = response.response.items.map { item in
                        let fullName = item.firstName + " " + item.lastName
                        return FollowerTableCellModel(iconUrl: item.photoUrl,
                                                      fullName: fullName)
                    }
                    self.didLoadData?()
                case .failure(let error):
                    self.showError?(error.localizedDescription)
            }
        }
    }
}

extension FollowerTableViewModel: FollowerTableViewModelType {
    var count: Int {
        return cells.count
    }
    
    func getItem(at index: Int) -> FollowerTableCellViewModelType {
        return cells[index]
    }
    
    func startLoadData() {
        getFollowers()
    }
}
