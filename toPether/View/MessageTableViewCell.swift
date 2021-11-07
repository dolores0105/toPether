//
//  MessageTableViewCell.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/5.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    private(set) var senderNameLabel: MediumLabel!
    private(set) var contentLabel: MediumLabel!
    private(set) var contentLabelView: UIView!
    private(set) var sentTimeLabel: RegularLabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        
        senderNameLabel = MediumLabel(size: 14, text: "anonymous", textColor: .deepBlueGrey)
        contentView.addSubview(senderNameLabel)
        
        contentLabelView = UIView()
        contentLabelView.backgroundColor = .white
        contentLabelView.layer.borderWidth = 1
        contentLabelView.layer.cornerRadius = 10
        contentLabelView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentLabelView)
        
        contentLabel = MediumLabel(size: 16, text: "", textColor: .mainBlue)
        contentLabel.numberOfLines = 0
        contentLabelView.addSubview(contentLabel)
        
        sentTimeLabel = RegularLabel(size: 14, text: nil, textColor: .lightBlueGrey)
        contentView.addSubview(sentTimeLabel)
        
        initConstraints()
    }
    
    func initConstraints() {
        // For override
    }
    
    func reload(message: Message, senderName: String?) {
        senderNameLabel.text = senderName
        contentLabel.text = message.content
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d HH:mm"
        dateFormatter.timeZone = TimeZone.current
        sentTimeLabel.text = dateFormatter.string(from: message.sentTime)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
