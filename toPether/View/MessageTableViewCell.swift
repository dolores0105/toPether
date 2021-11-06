//
//  MessageTableViewCell.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/5.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    private var senderNameLabel: MediumLabel!
    private var contentLabel: MediumLabel!
    private var contentLabelView: UIView!
    private var sentTimeLabel: RegularLabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        
        configSenderNameLabel()
        configContentLabel()
        configContentLabelView()
        configSentTimeLabel()
        
    }
    
    func reload(message: Message, senderName: String?, isSelf: Bool) {
        senderNameLabel.text = senderName
        contentLabel.text = message.content
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d HH:mm"
        dateFormatter.timeZone = TimeZone.current
        sentTimeLabel.text = dateFormatter.string(from: message.sentTime)
        
        if isSelf {
            
            senderNameLabel.isHidden = true
            contentLabel.removeConstraints(contentLabel.constraints)
            NSLayoutConstraint.activate([
                contentLabel.topAnchor.constraint(equalTo: senderNameLabel.bottomAnchor, constant: 12),
                contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
                contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32)
            ])

            sentTimeLabel.removeConstraints(sentTimeLabel.constraints)
            NSLayoutConstraint.activate([
                sentTimeLabel.bottomAnchor.constraint(equalTo: contentLabelView.bottomAnchor),
                sentTimeLabel.trailingAnchor.constraint(equalTo: contentLabelView.leadingAnchor, constant: -12)
            ])
            
            contentLabelView.layer.borderColor = UIColor.mainYellow.cgColor
            contentLabelView.setShadow(color: .mainYellow, offset: CGSize(width: 3.0, height: 3.0), opacity: 0.15, radius: 5)
            
        } else {
            senderNameLabel.isHidden = false
            contentLabel.removeConstraints(contentLabel.constraints)
            NSLayoutConstraint.activate([
                contentLabel.topAnchor.constraint(equalTo: senderNameLabel.bottomAnchor, constant: 12),
                contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
                contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32)
            ])

            sentTimeLabel.removeConstraints(sentTimeLabel.constraints)
            NSLayoutConstraint.activate([
                sentTimeLabel.bottomAnchor.constraint(equalTo: contentLabelView.bottomAnchor),
                sentTimeLabel.leadingAnchor.constraint(equalTo: contentLabelView.trailingAnchor, constant: 12)
            ])
            
            contentLabelView.layer.borderColor = UIColor.mainBlue.cgColor
            contentLabelView.setShadow(color: .mainBlue, offset: CGSize(width: 3.0, height: 3.0), opacity: 0.1, radius: 5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MessageTableViewCell {
    
    private func configSenderNameLabel() {
        senderNameLabel = MediumLabel(size: 14, text: "anonymous", textColor: .deepBlueGrey)
        contentView.addSubview(senderNameLabel)
        NSLayoutConstraint.activate([
            senderNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            senderNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            senderNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 2 / 3)
        ])
    }
    
    private func configContentLabel() {
        contentLabel = MediumLabel(size: 16,
                                   text: "",
                                   textColor: .mainBlue)
        contentLabel.numberOfLines = 0
        contentView.addSubview(contentLabel)
        contentLabel.preferredMaxLayoutWidth = contentView.frame.width / 3 * 2
        
//        contentLabel.topAnchor.constraint(equalTo: senderNameLabel.bottomAnchor, constant: 12).isActive = true
//        contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
//        contentLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 2 / 3).isActive = true
//        contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32).isActive = true
    }
    
    private func configContentLabelView() {
        contentLabelView = UIView()
        contentLabelView.backgroundColor = .white
        contentLabelView.layer.borderWidth = 1
        contentLabelView.layer.cornerRadius = 10
        contentLabelView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentLabelView)
        
        contentLabelView.centerXAnchor.constraint(equalTo: contentLabel.centerXAnchor).isActive = true
        contentLabelView.centerYAnchor.constraint(equalTo: contentLabel.centerYAnchor).isActive = true
        contentLabelView.heightAnchor.constraint(equalTo: contentLabel.heightAnchor, constant: 16).isActive = true
        contentLabelView.widthAnchor.constraint(equalTo: contentLabel.widthAnchor, constant: 16).isActive = true
        
        contentView.bringSubviewToFront(contentLabel)
    }
    
    private func configSentTimeLabel() {
        sentTimeLabel = RegularLabel(size: 14, text: "Nov. 22 20:34", textColor: .lightBlueGrey)
        contentView.addSubview(sentTimeLabel)
    }
}
