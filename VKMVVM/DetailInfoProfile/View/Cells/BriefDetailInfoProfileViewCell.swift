//
//  BriefDetailInfoProfileViewCell.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 12.02.2022.
//

import UIKit

protocol BriefDetailInfoProfileCellViewModelType {
    var birthday: String? { get }
    var city: String? { get }
    var familyStatus: String? { get }
    var followers: String? { get }
}

class BriefDetailInfoProfileViewCell: UITableViewCell {
    static let identifier = "BriefDetailInfoProfileViewCell"
    
    //MARK: - main stack view
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.spacing = CalculatorSizes.spacingStack
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - elements stack view
    private let birthdayView = DetailInfoButton(typeItem: .birthday, color: UIColor(named: "briefLabelColor")!)
    
    private let cityView = DetailInfoButton(typeItem: .city, color: UIColor(named: "briefLabelColor")!)
    
    private let familyStatusView = DetailInfoButton(typeItem: .familyStatus, color: UIColor(named: "briefLabelColor")!)
    
    private let followersView = DetailInfoButton(typeItem: .followers, color: UIColor(named: "briefLabelColor")!)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(birthdayView)
        stackView.addArrangedSubview(cityView)
        stackView.addArrangedSubview(familyStatusView)
        stackView.addArrangedSubview(followersView)
        
        stackView.fillSuperview(padding: CalculatorSizes.paddingStack)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(viewModel: BriefDetailInfoProfileCellViewModelType) {
        setView(birthdayView, text: viewModel.birthday)
        setView(cityView, text: viewModel.city)
        setView(familyStatusView, text: viewModel.familyStatus)
        setView(followersView, text: viewModel.followers)
    }
    
    private func setView(_ view: DetailInfoButton, text: String?) {
        if let text = text, !text.isEmpty {
            view.set(text: text)
            view.isHidden = false
        } else {
            view.isHidden = true
        }
    }
}

extension BriefDetailInfoProfileViewCell {
    struct CalculatorSizes {
        static let paddingStack = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        static let spacingStack: CGFloat = 8
        
        private static let heightElementStack: CGFloat = 30
        
        static func calculateHeightBriefDetailInfoProfileCell(viewModel: BriefDetailInfoProfileCellViewModelType) -> CGFloat {
            var count: CGFloat = 0
            count += viewModel.birthday != nil && !viewModel.birthday!.isEmpty ? 1 : 0
            count += viewModel.city != nil && !viewModel.city!.isEmpty ? 1 : 0
            count += viewModel.familyStatus != nil && !viewModel.familyStatus!.isEmpty ? 1 : 0
            count += viewModel.followers != nil && !viewModel.followers!.isEmpty ? 1 : 0
            
            let height = (paddingStack.top +
                          count * heightElementStack +
                          (count - 1) * spacingStack +
                          paddingStack.bottom)
            return height
        }
    }
}
