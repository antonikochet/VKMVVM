//
//  Configurator.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 21.01.2022.
//

import UIKit

class Configurator {
    static func configuratorNewsFeed() -> NewsFeedViewController {
        let newsFeedVC = NewsFeedViewController()
        let newsFeedModelView = NewsFeedViewModel()
        newsFeedVC.viewModel = newsFeedModelView
        newsFeedModelView.delegate = newsFeedVC
        return newsFeedVC
    }
    
    static func configuratorPageProfile(userId: String?) -> PageProfileViewController {
        let pageProfileVC = PageProfileViewController()
        let pageProfileViewModel = PageProfileViewModel(userId: userId)
        pageProfileVC.viewModel = pageProfileViewModel
        pageProfileViewModel.delegate = pageProfileVC
        return pageProfileVC
    }
    
    static func configuratorFriendsTable(friends: FriendsResponse?) -> FriendsTableTableViewController {
        let friendsViewModel = FriendsTableViewModel(friends)
        let friendsVC = FriendsTableTableViewController()
        friendsVC.viewModel = friendsViewModel
        friendsViewModel.delegate = friendsVC
        return friendsVC
    }
    
    static func configuratorGalleryPhotos(photos: [Photo], beginIndexPhoto: Int) -> DetailGalleryPhotosViewController {
        let galleryModelView = DetailGalleryPhotosModelView(photos)
        let galleryVC = DetailGalleryPhotosViewController(viewModel: galleryModelView, beginIndex: beginIndexPhoto)
        return galleryVC
    }
    
    static func conficuratorFollowerTable(userId: String?) -> FollowerTableViewController {
        let followersViewModel = FollowerTableViewModel(userId: userId)
        let followersVC = FollowerTableViewController()
        followersVC.viewModel = followersViewModel
        followersViewModel.delegate = followersVC
        return followersVC
    }
    
    static func conficuratorMainTabBar(viewControllers: [UIViewController]) -> UITabBarController {
        let tabBarVC = UITabBarController()
        tabBarVC.setViewControllers(viewControllers, animated: true)
        tabBarVC.tabBar.tintColor = UIColor(named: "ColorVK")!
        tabBarVC.tabBar.backgroundColor = UIColor(named: "NewsFeedView")!
        return tabBarVC
    }
    
    static func configuratorRootViewController() -> UIViewController {
        let pageProfileVC = Configurator.configuratorPageProfile(userId: nil)
        let newsFeedVC = Configurator.configuratorNewsFeed()
        let navBarNewsFeedVC = UINavigationController(rootViewController: newsFeedVC)
        let navBarPageProfileVC = UINavigationController(rootViewController: pageProfileVC)
        
        navBarNewsFeedVC.configuratorTabBarItem(title: "Новости", image: .newsFeed, tag: 0)
        navBarPageProfileVC.configuratorTabBarItem(title: "Страница", image: .profile, tag: 1)
        
        let tabBarVC = Configurator.conficuratorMainTabBar(viewControllers: [navBarNewsFeedVC, navBarPageProfileVC])
        return tabBarVC
    }
}

extension UIViewController {
    enum NameImageTabBarItem: String {
        case profile = "person.crop.circle"
        case newsFeed = "newspaper.fill"
    }
    
    func configuratorTabBarItem(title: String, image: NameImageTabBarItem, tag: Int) {
        tabBarItem.title = title
        tabBarItem.image = UIImage(systemName: image.rawValue)?.withRenderingMode(.alwaysTemplate)
        tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 16)], for: .normal)
        tabBarItem.tag = tag
    }
}
