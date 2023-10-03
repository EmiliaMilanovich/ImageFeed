//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Эмилия on 21.09.2023.
//

import UIKit
final class AlertPresenter {
    private weak var delegate: UIViewController?
        
    func showAlert(_ result: AlertModel) {
        let alert = UIAlertController(title: result.title,
                                        message: result.message,
                                        preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
            result.completion?()
        }
            
        alert.addAction(alertAction)
        delegate?.present(alert, animated: true, completion: nil)
    }
}

