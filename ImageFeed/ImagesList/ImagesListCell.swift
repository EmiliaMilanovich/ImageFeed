//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Эмилия on 09.05.2023.
//
import UIKit
import Kingfisher

//MARK: - ImagesListCell
public final class ImagesListCell: UITableViewCell {
    
    //MARK: - Properties
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImageListCellDelegate?
    
    //MARK: - IBOutlets
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    //MARK: - Private properties
    private let imagesListService = ImagesListService.shared
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    //MARK: - Lifecycle
    public override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }

    //MARK: - Methods
    func setIsLiked(isLiked: Bool) {
        let likeImage = UIImage(named: isLiked ? "like_button_on" : "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    func configCell(photoURL: String, with indexPath: IndexPath) -> Bool {
        var isConfigCell = false
        let placeholder = UIImage(named: "placeholder")
        let imageURL = URL(string: photoURL)
        
        if let date = imagesListService.photos[indexPath.row].createdAt {
            dateLabel.text = dateFormatter.string(from: date)
        } else {
            dateLabel.text = ""
        }
                
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(
            with: imageURL,
            placeholder: placeholder) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    isConfigCell = true
                case .failure:
                    self.cellImage.image = placeholder
                }
            }
        return isConfigCell
    }
    
    //MARK: - IBActions
    @IBAction private func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
}

