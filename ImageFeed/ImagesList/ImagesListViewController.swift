//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Эмилия on 09.05.2023.
//
import UIKit
import Kingfisher

//MARK: - Protocol
public protocol ImagesListViewControllerProtocol {
    var presenter: ImagesListViewPresenterProtocol? { get set }
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func likeError()
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    //MARK: - Properties
    var presenter: ImagesListViewPresenterProtocol?
    
    //MARK: - IBOutlets
    @IBOutlet private var tableView: UITableView!
    
    //MARK: - Private properties
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ImagesListViewPresenter()
        presenter?.view = self
        presenter?.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            viewController.fullImageURL = presenter?.getLargeImageURL(indexPath: indexPath)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        tableView.performBatchUpdates {
            let indexPath = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPath, with: .automatic)
        } completion: { _ in }
    }
    
    func likeError() {
        let alert = UIAlertController(title: "Ошибка", message: "Не удалось поставить лайк", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}

// MARK: - Extensions
extension ImagesListViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    //считает количество ячеек таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter else { return 0 }
        return presenter.getPhotosCount()
    }
    
    //создаём ячейку, наполняем её данными и передаём таблице
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //dequeueReusableCell - переиспользование ячеек
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
    
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
            
        imageListCell.delegate = self
        
        guard let presenter = presenter,
              let photo = presenter.getPhoto(indexPath: indexPath) else {
            return UITableViewCell()
        }
        
        let isConfigCell = imageListCell.configCell(photoURL: photo.thumbImageURL, with: indexPath)
        imageListCell.setIsLiked(isLiked: photo.isLiked)
        
        if isConfigCell {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return imageListCell
    }
}

//MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    //действия при тапе по ячейке таблицы
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photos = presenter?.photos[indexPath.row] else { return 10 }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photos.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photos.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.fetchPhotos(indexPath: indexPath)
    }
}

//MARK: - ImageListCellDelegate
extension ImagesListViewController: ImageListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter?.likePhoto(cell, indexPath)
    }
}
