//
//  AlertHelper.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 9.08.2025.
//

import UIKit

final class AlertHelper {
    static func showErrorAlert(on vc: UIViewController, title: String, message: String, retryHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let retry = retryHandler {
            alert.addAction(UIAlertAction(title: UIConstants.Texts.retryButton, style: .default) { _ in retry() })
        }
        alert.addAction(UIAlertAction(title: UIConstants.Texts.okButton, style: .cancel))
        vc.present(alert, animated: true)
    }
}
