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
}

protocol FollowerTableViewModelDelegate: AnyObject {
    func didLoadData()
    func showError(_ error: Error)
}

class FollowerTableViewModel {
    
    weak var delegate: FollowerTableViewModelDelegate?
    
    private var cells: [FollowerTableCellViewModelType] = []
    private var dataFetcher: DataFetcher
    private var userId: String?
    
    init(userId: String?, dataFetcher: DataFetcher = NetworkDataFetcher()) {
        self.userId = userId
        self.dataFetcher = dataFetcher
    }
    
    private func getFollowers() {
        dataFetcher.getFollowers(userId: userId, fieldsParams: [.online, .photo100]) { result in
            switch result {
                case .success(let response):
                    self.cells = response.response.items.map { item in
                        let fullName = item.firstName + " " + item.lastName
                        return FollowerTableCellModel(iconUrl: item.photoUrl,
                                                      fullName: fullName)
                    }
                    self.delegate?.didLoadData()
                case .failure(let error):
                    self.delegate?.showError(error)
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
