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
    func showDetailInfoUser()
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
        stack.spacing = CalculatorSizes.spacingBriefUserLabel
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
        detailModelViewButton.addTarget(self, action: #selector(touchDetailInfoButton), for: .touchUpInside)
        stack.fillSuperview(padding: StaticSizesPageProfileCell.paddingBriefUserStack)
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
    
    @objc private func touchDetailInfoButton() {
        delegate?.showDetailInfoUser()
    }
}

extension BriefUserInfoViewCell {
    struct CalculatorSizes {
        
        static let spacingBriefUserLabel: CGFloat = 8
        private static let heightBriefUserLabel: CGFloat = 30
        private static let paddingBriefUserStack: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        static func calculateHeightBriefUserInfoCell(viewModel: BriefUserInfoViewModelType) -> CGFloat {
            var count: CGFloat = 0
            count += viewModel.city != nil && !viewModel.city!.isEmpty ? 1 : 0
            count += viewModel.education != nil && !viewModel.education!.isEmpty ? 1 : 0
            count += viewModel.work != nil && !viewModel.work!.isEmpty ? 1 : 0
            count += viewModel.followes != nil && !viewModel.followes!.isEmpty ? 1 : 0
            
            let briefInfoButton = heightBriefUserLabel + spacingBriefUserLabel
            let height = (paddingBriefUserStack.top +
                          count * heightBriefUserLabel +
                          paddingBriefUserStack.bottom +
                          (count - 1) * spacingBriefUserLabel +
                          briefInfoButton)
            return height
        }
    }
}
