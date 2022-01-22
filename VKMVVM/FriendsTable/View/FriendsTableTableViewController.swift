//
//  FriendsTableTableViewController.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 21.01.2022.
//

import UIKit

class FriendsTableTableViewController: UITableViewController {

    var viewModel: FriendsTableViewModelType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: FriendTableViewCell.identifier)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.identifier, for: indexPath) as! FriendTableViewCell
        if let friendViewModel = viewModel?.getItem(by: indexPath.row) {
            cell.set(viewModel: friendViewModel)
        }
        return cell
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 14
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let friendViewModel = viewModel?.getItem(by: indexPath.row) as? FriendTableCellModel {
            let friendPageVC = Configurator.configuratorPageProfile(userId: String(friendViewModel.id))
            navigationController?.pushViewController(friendPageVC, animated: true)
        }
    }
}

extension FriendsTableTableViewController: FriendsTableViewModelDelegate {
    func didLoadData() {
        tableView.reloadData()
    }
}
