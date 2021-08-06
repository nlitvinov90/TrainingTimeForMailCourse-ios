//
//  TrainingTableViewCell.swift
//  TrainingTime
//
//  Created by Дмитрий Бокарев on 01.05.2021.
//

import UIKit

protocol MyTrainingTableViewCellDelegate: AnyObject {
    func didTapButton(trainingId: Int, toFavourites: Bool)
}

class MyTrainingTableViewCell: UITableViewCell {
    
    weak var delegate: MyTrainingTableViewCellDelegate?
    private let nameLabel = UILabel()
    private let levelImage = UIImageView()
    let bookmarkButton = UIButton()
    private var trainingId: Int = 1
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        nameLabel.numberOfLines = 0
        bookmarkButton.addTarget(self, action: #selector(bookmark_click(sender:)), for: .touchUpInside)
        //contentView.backgroundColor = backgroundColor
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
        
//        bookmarkButton.setImage(UIImage(named:"bookmark"), for: .normal)
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
            sender.setImage(UIImage(named:"bookmark"), for: .normal)
            delegate?.didTapButton(trainingId: trainingId, toFavourites: false)
            self.setNeedsLayout()
        } else {
            sender.setImage(UIImage(named:"BookmarkChosen"), for: .normal)
            delegate?.didTapButton(trainingId: trainingId, toFavourites: true)
            self.setNeedsLayout()
        }
    }
}
