//
//  BasicInfoView.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 22.02.2022.
//

import UIKit

class BasicInfoView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(named: "briefLabelColor")!
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(title: TitleName) {
        super.init(frame: .zero)
        addSubview(titleLabel)
        addSubview(contentLabel)
        titleLabel.text = title.rawValue
        
        titleLabel.anchor(top: topAnchor,
                          leading: leadingAnchor,
                          bottom: nil,
                          trailing: trailingAnchor,
                          padding: UIEdgeInsets(top: 2, left: 2, bottom: 0, right: 2))
        
        contentLabel.anchor(top: titleLabel.bottomAnchor,
                            leading: leadingAnchor,
                            bottom: bottomAnchor,
                            trailing: trailingAnchor,
                            padding: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(content: String?) {
        contentLabel.text = content
    }
}

extension BasicInfoView {
    enum TitleName: String {
        case city = "Родной город"
        case language =  "Языки"
        case parents = "Родители"
        case siblings = "Братья, сёстры"
        case children = "Дети"
    }
}
