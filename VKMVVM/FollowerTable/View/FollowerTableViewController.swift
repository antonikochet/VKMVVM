//
//  FollowerTableViewController.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 25.01.2022.
//

import UIKit

class FollowerTableViewController: UITableViewController {

    var viewModel: FollowerTableViewModelType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(FollowerTableViewCell.self, forCellReuseIdentifier: FollowerTableViewCell.identifier)
        viewModel?.startLoadData()
        navigationItem.title = "Подписчики"
        navigationItem.largeTitleDisplayMode = .always
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FollowerTableViewCell.identifier, for: indexPath) as! FollowerTableViewCell
        if let followerViewModel = viewModel?.getItem(at: indexPath.row) {
            cell.set(viewModel: followerViewModel)
        }
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension FollowerTableViewController: FollowerTableViewModelDelegate {
    func didLoadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showError(_ error: Error) {
        print(error)
    }
    
    
}
