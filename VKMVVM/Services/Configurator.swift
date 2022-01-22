//
//  Configurator.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 21.01.2022.
//

import Foundation

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
}
