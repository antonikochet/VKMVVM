//
//  BasicInfoDetailViewCell.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 22.02.2022.
//

import UIKit

protocol BasicInfoDetailInfoProfileCellViewModelType {
    var homeTown: String? { get }
    var language: String? { get }
    var parents: String? { get }
    var siblings: String? { get }
    var children: String? { get }
}

class BasicInfoDetailInfoProfileViewCell: UITableViewCell {
    static let identifier = "BasicInfoDetailInfoProfileViewCell"
    
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
    private let cityView = BasicInfoView(title: .city)
    
    private let languageView = BasicInfoView(title: .language)
    
    private let parentsView = BasicInfoView(title: .parents)
    
    private let siblingsView = BasicInfoView(title: .siblings)
    
    private let childrenView = BasicInfoView(title: .children)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(cityView)
        stackView.addArrangedSubview(languageView)
        stackView.addArrangedSubview(parentsView)
        stackView.addArrangedSubview(siblingsView)
        stackView.addArrangedSubview(childrenView)
        
        stackView.fillSuperview(padding: CalculatorSizes.paddingStack)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(viewModel: BasicInfoDetailInfoProfileCellViewModelType) {
        setView(cityView, text: viewModel.homeTown)
        setView(languageView, text: viewModel.language)
        setView(parentsView, text: viewModel.parents)
        setView(siblingsView, text: viewModel.siblings)
        setView(childrenView, text: viewModel.children)
    }
    
    private func setView(_ view: BasicInfoView, text: String?) {
        if let text = text, !text.isEmpty {
            view.set(content: text)
            view.isHidden = false
        } else {
            view.isHidden = true
        }
    }
}

extension BasicInfoDetailInfoProfileViewCell {
    struct CalculatorSizes {
        static let paddingStack = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        static let spacingStack: CGFloat = 8
        
        private static let heightElementStack: CGFloat = 40
        
        static func calculateHeightCell(viewModel: BasicInfoDetailInfoProfileCellViewModelType) -> CGFloat {
            var count: CGFloat = 0
            count += viewModel.homeTown != nil && !viewModel.homeTown!.isEmpty ? 1 : 0
            count += viewModel.language != nil && !viewModel.language!.isEmpty ? 1 : 0
            count += viewModel.parents != nil && !viewModel.parents!.isEmpty ? 1 : 0
            count += viewModel.siblings != nil && !viewModel.siblings!.isEmpty ? 1 : 0
            count += viewModel.children != nil && !viewModel.children!.isEmpty ? 1 : 0
            
            let height = (paddingStack.top +
                          count * heightElementStack +
                          (count - 1) * spacingStack +
                          paddingStack.bottom)
            return height
        }
    }
}
