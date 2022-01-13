//
//  NewsFeedViewController.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 15.12.2021.
//

import UIKit

class NewsFeedViewController: UIViewController {

    var viewModel: NewsFeedViewModelType!

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NewsFeedViewCell.self, forCellReuseIdentifier: NewsFeedViewCell.identifier)
        return tableView
    }()

    private let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshFeed), for: .valueChanged)
        return refresh
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Новости"
        navigationItem.titleView?.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.addSubview(refreshControl)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
        
        viewModel.getFirstData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnSwipe = false
    }
    
    @objc private func refreshFeed() {
        viewModel.updateData()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.1 {
            viewModel.getNextBatchNews()
        }
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

extension NewsFeedViewController: NewsFeedViewModelDelegate {
    func willLoadData() {
        print(#function)
    }
    
    func didLoadData() {
        print(#function)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
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
    
    func showDetailGalleryPhotos(for cell: NewsFeedViewCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let cellViewModel = viewModel.getItem(by: indexPath.row) as? NewsFeedModel else { return }

        let galleryModelView = DetailGalleryPhotosModelView(cellViewModel.contentPost.photos)
        let galleryVC = DetailGalleryPhotosViewController(viewModel: galleryModelView, beginIndex: 0) //TODO: добавить опредление индекса нажатой фотографии

        navigationController?.pushViewController(galleryVC, animated: true)
    }
}
