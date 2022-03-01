//
//  DetailInfoProfileViewController.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 12.02.2022.
//

import UIKit

protocol DetailInfoProfileViewModelType {
    var count: Int { get }
    func getDataForCell(at index: Int) -> DetailInfoProfileCell
}

enum DetailInfoProfileCell {
    case status(StatusDetailInfoProfileCellViewModelType?)
    case briefInfo(BriefDetailInfoProfileCellViewModelType?)
    case basicInfo(BasicInfoDetailInfoProfileCellViewModelType?)
    case none
}

class DetailInfoProfileViewController: UITableViewController {

    var viewModel: DetailInfoProfileViewModelType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(StatusDetailInfoProfileViewCell.self,
                           forCellReuseIdentifier: StatusDetailInfoProfileViewCell.identifier)
        tableView.register(BriefDetailInfoProfileViewCell.self,
                           forCellReuseIdentifier: BriefDetailInfoProfileViewCell.identifier)
        tableView.register(BasicInfoDetailInfoProfileViewCell.self,
                           forCellReuseIdentifier: BasicInfoDetailInfoProfileViewCell.identifier)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel?.getDataForCell(at: indexPath.row) else {
            return tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        }
        switch viewModel {
            case .status(let statusViewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: StatusDetailInfoProfileViewCell.identifier, for: indexPath) as! StatusDetailInfoProfileViewCell
                if let statusViewModel = statusViewModel {
                    cell.set(viewModel: statusViewModel)
                }
                return cell
            case .briefInfo(let briefViewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: BriefDetailInfoProfileViewCell.identifier, for: indexPath) as! BriefDetailInfoProfileViewCell
                if let briefViewModel = briefViewModel {
                    cell.set(viewModel: briefViewModel)
                }
                return cell
            case .basicInfo(let basicViewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: BasicInfoDetailInfoProfileViewCell.identifier, for: indexPath) as! BasicInfoDetailInfoProfileViewCell
                if let basicViewModel = basicViewModel {
                    cell.set(viewModel: basicViewModel)
                }
                return cell
            case .none:
                return tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let viewModel = viewModel?.getDataForCell(at: indexPath.row) else { return 0 }
        switch viewModel {
            case .status(let status):
                guard let statusStr = status?.status else { return 0 }
                return status != nil ? StatusDetailInfoProfileViewCell.CalculatorSizes.calculateHeightCell(text: statusStr, width: tableView.frame.width) : 0
            case .briefInfo(let brief):
                return brief != nil ? BriefDetailInfoProfileViewCell.CalculatorSizes.calculateHeightBriefDetailInfoProfileCell(viewModel: brief!) : 0
            case .basicInfo(let basic):
                return basic != nil ? BasicInfoDetailInfoProfileViewCell.CalculatorSizes.calculateHeightCell(viewModel: basic!) : 0
            case .none:
                return 0
        }
    }
}

extension DetailInfoProfileViewController: DetailInfoProfileViewModelDelegate {
    func dataDidLoad() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showError(_ error: Error) {
        print(error)
    }
}
