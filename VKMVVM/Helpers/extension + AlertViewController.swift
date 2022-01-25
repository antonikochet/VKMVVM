//
//  extension + AlertViewController.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 26.01.2022.
//

import UIKit

extension UIViewController {
    
    func showYesOrNoAlert(title: String?, message: String?, yesCompletion: @escaping () -> Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertYes = UIAlertAction(title: "Да", style: .default) { _ in
            yesCompletion()
        }
        let alertCancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alertVC.addAction(alertYes)
        alertVC.addAction(alertCancel)
        
        present(alertVC, animated: true, completion: nil)
    }
}
