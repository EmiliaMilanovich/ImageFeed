//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Эмилия on 31.05.2023.
//

import UIKit
import Kingfisher

// MARK: - SingleImageViewController
final class SingleImageViewController: UIViewController {
    
    // MARK: - Properties
    var fullImageURL: URL?
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    // MARK: - Licycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageViewPicture()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        scrollView.delegate = self
    }
    
    // MARK: - Methods
    func setImageViewPicture() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: fullImageURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                UIBlockingProgressHUD.dismiss()
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showAlert()
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    // MARK: - Private methods
    private func showAlert() {
        let alert = UIAlertController(title: "Ошибка!", message: "Что-то пошло не так.\nПопробовать еще раз?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Нет", style: .default)
        let action2 = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.setImageViewPicture()
        }
        alert.addAction(action1)
        alert.addAction(action2)
        self.present(alert, animated: true)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

// MARK: - Extension
extension SingleImageViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
