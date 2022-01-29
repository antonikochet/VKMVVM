//
//  OnlineImageView.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 22.01.2022.
//

import UIKit

class OnlineImageView: UIImageView {
    
    func set(online: Bool, has_phone: Bool) {
        if online {
            if has_phone {
                image = UIImage(systemName: ImageName.phone.rawValue)?.withRenderingMode(.alwaysTemplate)
            } else {
                image = UIImage(systemName: ImageName.online.rawValue)?.withRenderingMode(.alwaysTemplate)
            }
            tintColor = .systemGreen
            isHidden = false
        } else {
            isHidden = true
            image = nil
        }
    }
}

extension OnlineImageView {
    enum ImageName: String {
        case online = "circle.fill"
        case phone = "iphone.homebutton"
    }
}
