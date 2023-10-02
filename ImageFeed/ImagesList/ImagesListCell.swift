//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Эмилия on 09.05.2023.
//
import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    private let imagesListService = ImagesListService.shared
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImageListCellDelegate?
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        cellImage.kf.cancelDownloadTask()
    }
    
    func setIsLiked(isLiked: Bool) {
        let likeImage = UIImage(named: isLiked ? "like_button_on" : "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
        }
    
    
    @IBAction private func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
}

