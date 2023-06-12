//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Эмилия on 12.06.2023.
//

import UIKit

final class AuthViewController: UIViewController {
    private let showWebViewSegueIdentifier = "ShowWebView"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(showWebViewSegueIdentifier)") }
            webViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        // TODO: process code
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
