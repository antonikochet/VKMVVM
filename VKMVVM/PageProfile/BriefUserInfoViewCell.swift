//
//  BriefUserInfoViewCell.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 17.01.2022.
//

import UIKit

protocol BriefUserInfoViewModelType {
    var city: String? { get }
    var education: String? { get }
    var work: String? { get }
    var followes: String? { get }
}

protocol BriefUserInfoViewCellDelegate: AnyObject {
    func showFollowersTable()
}

class BriefUserInfoViewCell: UITableViewCell {

    static let identifier = "BriefUserInfoViewCell"
    
    weak var delegate: BriefUserInfoViewCellDelegate?
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .leading
        stack.spacing = StaticSizesPageProfileCell.spacingBriefUserLabel
        return stack
    }()
    
    private let cityView = DetailInfoButton(typeItem: .city, color: UIColor(named: "briefLabelColor")!)
    
    private let educationView = DetailInfoButton(typeItem: .education, color: UIColor(named: "briefLabelColor")!)
    
    private let workView = DetailInfoButton(typeItem: .work, color: UIColor(named: "briefLabelColor")!)
    
    private let followesView = DetailInfoButton(typeItem: .followers, color: UIColor(named: "briefLabelColor")!)
    
    private let detailModelViewButton = DetailInfoButton(typeItem: .information, color: UIColor(named: "ColorVK")!)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.addSubview(stack)
        stack.addArrangedSubview(cityView)
        stack.addArrangedSubview(educationView)
        stack.addArrangedSubview(workView)
        stack.addArrangedSubview(followesView)
        stack.addArrangedSubview(detailModelViewButton)
        
        followesView.addTarget(self, action: #selector(touchFollowersButton), for: .touchUpInside)
        
        let padding = StaticSizesPageProfileCell.paddingBriefUserStack
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding.top),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding.left),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding.right),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding.bottom)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(viewModel: BriefUserInfoViewModelType) {
        setView(cityView, text: viewModel.city)
        setView(educationView, text: viewModel.education)
        setView(workView, text: viewModel.work)
        setView(followesView, text: viewModel.followes)
        detailModelViewButton.set(text: nil)
    }
    
    private func setView(_ view: DetailInfoButton, text: String?) {
        if let text = text, !text.isEmpty {
            view.set(text: text)
            view.isHidden = false
        } else {
            view.isHidden = true
        }
    }
    
    @objc private func touchFollowersButton() {
        delegate?.showFollowersTable()
    }
}
