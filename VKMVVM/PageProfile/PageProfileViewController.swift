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
        tableView.register(PhotosGalleryProfileViewCell.self, forCellReuseIdentifier: PhotosGalleryProfileViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.backButtonTitle = ""
        tableView.fillSuperview()
        viewModel?.loadProfileInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupRightBarButton()
    }
    
    private func setupRightBarButton() {
        if viewModel?.isProfileSpecificUser ?? false {
            let rightBarButtomItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(exitProfile))
            navigationItem.rightBarButtonItem = rightBarButtomItem
        }
    }
    
    @objc private func exitProfile() {
        showYesOrNoAlert(title: "Выход из аккаунта", message: "Вы уверены, что хотите выйти из своего аккаунта?") {
            AuthService.shared.forceLogout()
        }
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
                if viewModel?.isClosed ?? false {
                    return 3
                } else {
                    return 4
                }
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
            case IndexPath(row: 3, section: 0):
                let custemCell = tableView.dequeueReusableCell(withIdentifier: PhotosGalleryProfileViewCell.identifier, for: indexPath) as! PhotosGalleryProfileViewCell
                if let viewModel = viewModel?.getGalleryPhotos() {
                    custemCell.set(viewModel: viewModel)
                    custemCell.delegate = self
                }
                return custemCell
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
                return BriefUserInfoViewCell.CalculatorSizes.calculateHeightBriefUserInfoCell(viewModel: viewModel)
            case IndexPath(row: 2, section: 0):
                if viewModel?.isClosed ?? false {
                    return StaticSizesPageProfileCell.heightClosedCell
                } else {
                    return StaticSizesPageProfileCell.heightFriendsCell
                }
            case IndexPath(row: 3, section: 0):
                return viewModel?.isClosed ?? true || viewModel?.isEmptyPhotos ?? true ? 0 : PhotosGalleryProfileViewCell.CalculatorSizes.calculateHeightPhotosGalleryCell(widthSuperView: view.frame.width)
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
            case IndexPath(row: 2, section: 0):
                if let response = viewModel?.getFriendsUser(), !response.isEmpty {
                    let userId = viewModel?.getUserId()
                    let frindsTableVC = Configurator.configuratorFriendsTable(friends: response, userId: userId)
                    navigationController?.pushViewController(frindsTableVC, animated: true)
                }
            case IndexPath(row: 3, section: 0):
                let userId = viewModel?.getUserId()
                let photosVC = Configurator.configuratorPhotosGalleryProfile(userId: userId)
                navigationController?.pushViewController(photosVC, animated: true)
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
        let userId = viewModel?.getUserId()
        let followersTableVC = Configurator.configuratorFollowerTable(userId: userId)
        navigationController?.pushViewController(followersTableVC, animated: true)
    }
    
    func showDetailInfoUser() {
        guard let user = viewModel?.getUserResponseForDetailInfoProfile() else { return }
        let detailInfoProfileVC = Configurator.configuratorDetailInfoProfile(user: user)
        navigationController?.pushViewController(detailInfoProfileVC, animated: true)
    }
}

extension PageProfileViewController: PhotosGalleryProfileViewCellDelegate {
    func showDetailPhotos(beginIndex: Int) {
        if let photos = viewModel?.showDetailGalleryPhotos(), !photos.isEmpty {
            let vc = Configurator.configuratorGalleryPhotos(photos: photos, beginIndexPhoto: beginIndex)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
