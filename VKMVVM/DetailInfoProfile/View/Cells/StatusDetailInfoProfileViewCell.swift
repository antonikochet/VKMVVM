//
//  StatusDetailInfoProfileViewCell.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 12.02.2022.
//

import UIKit

protocol StatusDetailInfoProfileCellViewModelType {
    var status: String { get }
}

class StatusDetailInfoProfileViewCell: UITableViewCell {
    static let identifier = "StatusDetailInfoProfileViewCell"
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = CalculatorSizes.fontTextLabel
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(statusLabel)
        
        statusLabel.fillSuperview(padding: CalculatorSizes.paddingLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(viewModel: StatusDetailInfoProfileCellViewModelType) {
        statusLabel.text = viewModel.status
    }
}

extension StatusDetailInfoProfileViewCell {
    struct CalculatorSizes {
        
        static let paddingLabel = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        static let fontTextLabel: UIFont = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        static func calculateHeightCell(text: String, width: CGFloat) -> CGFloat {
            let heightText = text.height(width: width - (paddingLabel.left + paddingLabel.right),
                                         font: fontTextLabel)
            return paddingLabel.top + heightText + paddingLabel.bottom
        }
    }
}
