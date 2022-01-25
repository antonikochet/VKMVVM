//
//  PageProfileViewController.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 15.01.2022.
//

import UIKit

class PageProfileViewController: UIViewController {

    var viewModel: PageProfileViewModelType?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HeaderProfileTableViewCell.self, forCellReuseIdentifier: HeaderProfileTableViewCell.identifier)
        tableView.register(BriefUserInfoViewCell.self, forCellReuseIdentifier: BriefUserInfoViewCell.identifier)
        tableView.register(FriendsViewCell.self, forCellReuseIdentifier: FriendsViewCell.identifier)
        tableView.register(ClosedTableViewCell.self, forCellReuseIdentifier: ClosedTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.backButtonTitle = ""
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.loadProfileInfo()
    }
}

extension PageProfileViewController: PageProfileViewModelDelegate {
    func didLoadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.navigationItem.title = self.viewModel?.nickName
        }
    }

    func didPhotosProfile(photos: [Photo]) {
        DispatchQueue.main.async {
            let galleryVC = Configurator.configuratorGalleryPhotos(photos: photos, beginIndexPhoto: 0)
            self.navigationController?.pushViewController(galleryVC, animated: true)
        }
    }
    func showError(error: Error) {
        print(error)
    }
}

extension PageProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 3
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath {
            case IndexPath(row: 0, section: 0):
                let custemCell = tableView.dequeueReusableCell(withIdentifier: HeaderProfileTableViewCell.identifier, for: indexPath) as! HeaderProfileTableViewCell
                if let viewModel = viewModel?.getHeaderProfile() {
                    custemCell.set(viewModel: viewModel)
                    custemCell.delegate = self
                }
                return custemCell
            case IndexPath(row: 1, section: 0):
                let custemCell = tableView.dequeueReusableCell(withIdentifier: BriefUserInfoViewCell.identifier, for: indexPath) as! BriefUserInfoViewCell
                if let viewModel = viewModel?.getBriefUserInfo() {
                    custemCell.set(viewModel: viewModel)
                    custemCell.delegate = self
                }
                return custemCell
            case IndexPath(row: 2, section: 0):
                if viewModel?.isClosed ?? false {
                    let custemCell = tableView.dequeueReusableCell(withIdentifier: ClosedTableViewCell.identifier, for: indexPath) as! ClosedTableViewCell
                    custemCell.set(isDeleted: viewModel?.isDeleted ?? false)
                    return custemCell
                } else {
                    let custemCell = tableView.dequeueReusableCell(withIdentifier: FriendsViewCell.identifier, for: indexPath) as! FriendsViewCell
                    if let viewModel = viewModel?.getFriendsList() {
                        custemCell.set(viewModel: viewModel)
                        custemCell.delegate = self
                    }
                    return custemCell
                }
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                return cell
        }
    }
}

extension PageProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
            case IndexPath(row: 0, section: 0):
                return StaticSizesPageProfileCell.heigthHeaderProfileCell
            case IndexPath(row: 1, section: 0):
                guard let viewModel = viewModel?.getBriefUserInfo() else { return 0 }
                return CGFloat(CalculatorSizes.calculateSizeBriefUserInfo(viewModel: viewModel))
            case IndexPath(row: 2, section: 0):
                if viewModel?.isClosed ?? false {
                    return StaticSizesPageProfileCell.heightClosedCell
                } else {
                    return StaticSizesPageProfileCell.heightFriendsCell
                }
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
            case IndexPath(row: 2, section: 0):
                let response = viewModel?.getFriendsResponse()
                let frindsTableVC = Configurator.configuratorFriendsTable(friends: response)
                navigationController?.pushViewController(frindsTableVC, animated: true)
            default:
                return
        }
    }
}

extension PageProfileViewController: FriendsViewCellDelegate {
    func showFriend(by id: Int) {
        let pageFriendsVC = Configurator.configuratorPageProfile(userId: String(id))
        navigationController?.pushViewController(pageFriendsVC, animated: true)
    }
}

extension PageProfileViewController: HeaderProfileCellDelegate {
    func showProfilePhotosGallery() {
        viewModel?.loadPhotosProfileInfo()
    }
}

extension PageProfileViewController: BriefUserInfoViewCellDelegate {
    func showFollowersTable() {
        let userId = viewModel?.getFriendsResponse()?.userId 
        let followersTableVC = Configurator.conficuratorFollowerTable(userId: userId)
        navigationController?.pushViewController(followersTableVC, animated: true)
    }
}
