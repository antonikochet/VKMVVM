//
//  NewsFeedViewController.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 15.12.2021.
//

import UIKit

class NewsFeedViewController: UIViewController {

    var viewModel: NewsFeedModelViewType!

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .purple
        tableView.register(NewsFeedViewCell.self, forCellReuseIdentifier: NewsFeedViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
        
        viewModel.updateData()
    }
}

extension NewsFeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedViewCell.identifier, for: indexPath) as! NewsFeedViewCell
        let cellModelItem = viewModel.getItem(by: indexPath.row)
        cell.set(cellModelItem!)
        cell.delegate = self
        return cell
    }
}

extension NewsFeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = viewModel.getItem(by: indexPath.row)
        return cellViewModel?.contentPost.sizes.totalHeight ?? 0
    }
}

extension NewsFeedViewController: NewsFeedModelViewDelegate {
    func willLoadData() {
        print(#function)
    }
    
    func didLoadData() {
        print(#function)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showError(_ error: Error) {
        print(error.localizedDescription)
    }
}

extension NewsFeedViewController: NewsFeedCellDelegate {
    func revealPost(for cell: NewsFeedViewCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let cellViewModel = viewModel.getItem(by: indexPath.row) as? NewsFeedModel else { return }
        viewModel.revealPost(cellViewModel.postId)
    }
}
