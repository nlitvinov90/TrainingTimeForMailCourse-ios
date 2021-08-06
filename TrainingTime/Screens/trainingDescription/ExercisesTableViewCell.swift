//
//  exercisesTableViewCell.swift
//  TrainingTime
//
//  Created by Ivan Bolshakov on 28.03.2021.
//

import UIKit
import PinLayout

class ExercisesTableViewCell: UITableViewCell {
    private let nameLable = UILabel()
    private let apparatusLabel = UILabel()
    private let iconImageView = UIImageView()
    private let timeLable = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        self.backgroundColor = backgroundColorOur
        contentView.backgroundColor = itemColor
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 10
        self.selectionStyle = .none
        nameLable.numberOfLines = 0
        timeLable.numberOfLines = 0
        timeLable.textAlignment = .center
        nameLable.textAlignment = .center
        [nameLable, timeLable].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.pin
            .vertically(10)
            .horizontally(10)
        
        nameLable.pin
            .left(10)
            .horizontally()
            .vCenter()
            .width(50%)
            .sizeToFit(.width)
        
        timeLable.pin
            .right(10)
            .vCenter()
            .width(30%)
            .sizeToFit(.width)
        
    }
    
    func configure(with model: ExerciseCell){
        nameLable.textColor = contentColor
        timeLable.textColor = contentColor
        nameLable.text = model.name
        timeLable.text = model.time
    }
}
