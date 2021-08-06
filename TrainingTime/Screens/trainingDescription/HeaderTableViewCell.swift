//
//  HeaderTableViewCell.swift
//  TrainingTime
//
//  Created by Ivan Bolshakov on 28.03.2021.
//

import UIKit
import PinLayout


class HeaderTableViewCell: UITableViewCell {
    
    weak var delegate: TrainingInfoViewController?
    
    private let nameLable = UILabel()
    private let bookmarkButton = UIButton()
    private let descripT = UILabel()
    private let hardImage = UIImageView()
    private let bookmarkImage = UIImageView()
    
    private var trainingId: Int = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        bookmarkButton.addTarget(self, action: #selector(star_click(sender:)), for: .touchUpInside)
//        contentView.setGradientBackground(colorTop: UIColor.black, colorBottom: UIColor.gray)
        contentView.backgroundColor = backgroundColorOur
        [nameLable, descripT, hardImage, bookmarkImage, bookmarkButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLable.pin
            .top(10)
            .hCenter()
            .width(80%)
            .sizeToFit(.width)
        
        bookmarkButton.pin
            .top(10)
            .right(20)
            .height(25)
            .width(25)
            .aspectRatio()
        
        descripT.pin
            .below(of: nameLable).margin(20)
            .horizontally()
            .vCenter()
            .width(90%)
            .sizeToFit(.width)
        
        hardImage.pin
            .below(of: descripT).margin(20)
            .left(20)
            .height(10)
            .aspectRatio()
    }
    
//    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
//        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
//        gradientLayer.locations = [0, 1]
//        gradientLayer.frame = bounds
//
//       layer.insertSublayer(gradientLayer, at: 0)
//    }

    func configure(with model: TitleCell, isFavourite: Bool, id: Int){
        nameLable.numberOfLines = 0
        descripT.numberOfLines = 0
        nameLable.font = nameLable.font.withSize(20)
        nameLable.textColor = contentColor
        descripT.textColor = contentColor
        nameLable.text = model.name
        hardImage.image = UIImage(named: model.imageHard)
        descripT.text = model.descripT
        
        trainingId = id
        
        if isFavourite {
            bookmarkButton.setImage(UIImage(named:"BookmarkChosen"), for: .normal)
        } else {
            bookmarkButton.setImage(UIImage(named:"bookmark"), for: .normal)
        }
        
        bookmarkButton.contentVerticalAlignment = .fill
        bookmarkButton.contentHorizontalAlignment = .fill
    }
    
//    @objc
//    func star_click(sender: UIButton) {
//        if sender.currentImage == UIImage(named: "BookmarkChosen") {
//            sender.setImage(UIImage(named:"bookmark"), for: .normal)
//            self.setNeedsLayout()
//        }
//        else {
//            sender.setImage(UIImage(named:"BookmarkChosen"), for: .normal)
//            self.setNeedsLayout()
//        }
//    }
    @objc
    func star_click(sender: UIButton) {
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
