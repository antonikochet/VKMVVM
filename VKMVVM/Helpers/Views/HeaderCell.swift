//
//  HeaderCell.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 29.01.2022.
//

import UIKit

class HeaderCell: UIView {

    private let label: UILabel = {
        let label = UILabel()
        label.font = StaticSizesUniversalViews.fontLabelCell
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = StaticSizesUniversalViews.fontCountLabelCell
        label.textColor = StaticSizesUniversalViews.colorCountLabelCell
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        addSubview(label)
        addSubview(countLabel)
        
        label.text = title
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            
            countLabel.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8),
            countLabel.centerYAnchor.constraint(equalTo: label.centerYAnchor)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints(superView: UIView) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superView.topAnchor, constant: StaticSizesUniversalViews.topConstantLabelCell),
            self.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            self.heightAnchor.constraint(equalToConstant: StaticSizesUniversalViews.fontLabelCell.lineHeight)])
    }
    
    func set(count: String?) {
        countLabel.text = count
    }
}
