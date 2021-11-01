//
//  FoodTableViewCell.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/30.
//

import UIKit

class FoodTableViewCell: UITableViewCell {

    private var dotView: DotView!
    private var lineView: LineView!
    private var dateLabel: MediumLabel!
    private var borderView: BorderView!
    private var nameLabel: MediumLabel!
    private var weightUnitLabel: RegularLabel!
    private var priceLabel: RegularLabel!
    private var marketLabel: RegularLabel!
    private var noteLabel: RegularLabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        
        dotView = DotView(bordercolor: .mainYellow, size: 20)
        contentView.addSubview(dotView)
        NSLayoutConstraint.activate([
            dotView.topAnchor.constraint(equalTo: contentView.topAnchor),
            dotView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
        ])
        
        lineView = LineView(color: .lightBlueGrey, width: 2)
        contentView.addSubview(lineView)
        NSLayoutConstraint.activate([
            lineView.centerXAnchor.constraint(equalTo: dotView.centerXAnchor),
            lineView.topAnchor.constraint(equalTo: dotView.centerYAnchor),
            lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        contentView.bringSubviewToFront(dotView)
        
        dateLabel = MediumLabel(size: 16, text: nil, textColor: .deepBlueGrey)
        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: dotView.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: dotView.trailingAnchor, constant: 12),
            dateLabel.widthAnchor.constraint(equalToConstant: 160)
        ])
        
        borderView = BorderView()
        contentView.addSubview(borderView)
        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 12),
            borderView.leadingAnchor.constraint(equalTo: dotView.trailingAnchor, constant: 12),
            borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            borderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
        
        nameLabel = MediumLabel(size: 18, text: nil, textColor: .mainBlue)
        nameLabel.numberOfLines = 0
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -12)
        ])
        
        weightUnitLabel = RegularLabel(size: 14, text: nil, textColor: .deepBlueGrey)
        contentView.addSubview(weightUnitLabel)
        NSLayoutConstraint.activate([
            weightUnitLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            weightUnitLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            weightUnitLabel.widthAnchor.constraint(equalTo: borderView.widthAnchor, multiplier: 0.5)
        ])
        
        priceLabel = RegularLabel(size: 14, text: nil, textColor: .deepBlueGrey)
        priceLabel.textAlignment = .right
        contentView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.centerYAnchor.constraint(equalTo: weightUnitLabel.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -12),
            priceLabel.widthAnchor.constraint(equalTo: borderView.widthAnchor, multiplier: 0.5)
        ])
        
        marketLabel = RegularLabel(size: 14, text: nil, textColor: .deepBlueGrey)
        contentView.addSubview(marketLabel)
        NSLayoutConstraint.activate([
            marketLabel.topAnchor.constraint(equalTo: weightUnitLabel.bottomAnchor, constant: 8),
            marketLabel.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 12),
            marketLabel.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -12)
        ])
        
        noteLabel = RegularLabel(size: 17, text: nil, textColor: .deepBlueGrey)
        noteLabel.numberOfLines = 0
        contentView.addSubview(noteLabel)
        NSLayoutConstraint.activate([
            noteLabel.topAnchor.constraint(equalTo: marketLabel.bottomAnchor, constant: 16),
            noteLabel.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 12),
            noteLabel.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -12),
            noteLabel.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: functions
    func reload(food: Food) {
        nameLabel.text = food.name
        weightUnitLabel.text = food.weight + " " + food.unit
        priceLabel.text = "$ " + food.price
        marketLabel.text = food.market
        noteLabel.text = food.note
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d YYYY"
        dateFormatter.timeZone = TimeZone.current
        dateLabel.text = dateFormatter.string(from: food.dateOfPurchase)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
