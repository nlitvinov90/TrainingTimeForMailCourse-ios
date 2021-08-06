//
//  TrainingTableViewCell.swift
//  TrainingTime
//
//  Created by Дмитрий Бокарев on 01.05.2021.
//

import UIKit

protocol TrainingTableViewCellDelegate: AnyObject {
    func didTapButton(trainingId: Int, toFavourites: Bool)
}

class TrainingTableViewCell: UITableViewCell {
    
    private let userManager: UserManagerDescription = UserManager.shared
    
    weak var delegate: TrainingTableViewCellDelegate?
    private let nameLabel = UILabel()
    private let levelImage = UIImageView()
    let bookmarkButton = UIButton()
    private var trainingId: Int = -1
    private var isTrainingFavourite: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
//    private func isTrainingFavourite(trainingId: Int) -> Void {
//        userManager.isTrainingFavourite(userId: UserDataViewController.UserID, trainingId: trainingId) {
//            [weak self] (result) in switch result {
//            case .success(let res):
//                if res {
//                    self?.isTrainingFavourite = true
//                } else {
//                    self?.isTrainingFavourite = false
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        nameLabel.numberOfLines = 0
        bookmarkButton.addTarget(self, action: #selector(bookmark_click(sender:)), for: .touchUpInside)
        contentView.backgroundColor = backgroundColor
        [nameLabel, levelImage, bookmarkButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func layoutSubviews() {
        nameLabel.pin
            .left(10)
            .horizontally()
            .vCenter()
            .width(150)
            .sizeToFit(.width)
        
        levelImage.pin
            .right(30)
            .height(10)
            .aspectRatio()
            .vCenter()
        
        bookmarkButton.pin
            .top(10)
            .right(20)
            .height(25)
            .width(25)
            .aspectRatio()
    }
    
    func configure(with model: Training) {
        self.trainingId = model.id
        nameLabel.textColor = contentColor
        nameLabel.text = model.name
        
        if model.isFavourite {
            bookmarkButton.setImage(UIImage(named:"BookmarkChosen"), for: .normal)
        } else {
            bookmarkButton.setImage(UIImage(named:"bookmark"), for: .normal)
        }
        bookmarkButton.contentVerticalAlignment = .fill
        bookmarkButton.contentHorizontalAlignment = .fill
        
        switch model.difficulty {
        case 1:
            levelImage.image = UIImage(named: "difficulty1")
        case 2:
            levelImage.image = UIImage(named: "difficulty2")
        case 3:
            levelImage.image = UIImage(named: "difficulty3")
        default:
            levelImage.image = UIImage(named: "difficulty1")
        }
    }
    
    @objc
    func bookmark_click(sender: UIButton) {
        if sender.currentImage == UIImage(named: "BookmarkChosen") {
            delegate?.didTapButton(trainingId: trainingId, toFavourites: false)
            if !UserState.shared.isLoggedIn {
                return
            }
            sender.setImage(UIImage(named:"bookmark"), for: .normal)
            self.setNeedsLayout()
        } else {
            delegate?.didTapButton(trainingId: trainingId, toFavourites: true)
            if !UserState.shared.isLoggedIn {
                return
            }
            sender.setImage(UIImage(named:"BookmarkChosen"), for: .normal)
            self.setNeedsLayout()
        }
    }
}
