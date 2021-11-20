//
//  ToDoTableViewCell.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/8.
//

import UIKit

protocol ToDoTableViewCellDelegate: AnyObject {
    func didChangeDoneStatusOnCell(_ cell: ToDoTableViewCell)
}

class ToDoTableViewCell: UITableViewCell {

    weak var delegate: ToDoTableViewCellDelegate?
    
    private var borderView: BorderView!
    private var doneButton: CircleButton!
    private var todoLabel: MediumLabel!
    private var iconsLabelHorizontalStackView: IconLabelHorizontalStackView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        
        borderView = BorderView()
        borderView.backgroundColor = .white
        borderView.setShadow(color: .mainBlue, offset: CGSize(width: 3.0, height: 3.0), opacity: 0.1, radius: 6)
        contentView.addSubview(borderView)
        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            borderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            borderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        doneButton = CircleButton(img: Img.iconsCheck.obj, bgColor: .white, borderColor: .deepBlueGrey)
        doneButton.addTarget(self, action: #selector(tapDone), for: .touchUpInside)
        doneButton.layer.cornerRadius = 16
        contentView.addSubview(doneButton)
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 20),
            doneButton.centerYAnchor.constraint(equalTo: borderView.centerYAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 32),
            doneButton.widthAnchor.constraint(equalTo: doneButton.heightAnchor)
        ])
        
        todoLabel = MediumLabel(size: 18, text: nil, textColor: .mainBlue)
        todoLabel.numberOfLines = 0
        contentView.addSubview(todoLabel)
        NSLayoutConstraint.activate([
            todoLabel.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 16),
            todoLabel.leadingAnchor.constraint(equalTo: doneButton.trailingAnchor, constant: 20),
            todoLabel.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -24)
        ])

    }
    
    func reload(todo: ToDo, executorName: String?, petName: String?) {
        todoLabel.text = todo.content
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone.current
        
        if todo.doneStatus {
            doneButton.backgroundColor = .mainYellow
        } else {
            doneButton.backgroundColor = .white
        }
        
        iconsLabelHorizontalStackView?.removeFromSuperview()
        setUpStackView(labelTexts: [dateFormatter.string(from: todo.dueTime), executorName, petName])
    }
    
    @objc func tapDone(_ sender: UIButton) {
        delegate?.didChangeDoneStatusOnCell(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ToDoTableViewCell {
    private func setUpStackView(labelTexts: [String?]?) {
        
        iconsLabelHorizontalStackView = IconLabelHorizontalStackView(
            icons: [Img.iconsClock.obj, Img.iconsPerson.obj, Img.iconsPaw.obj],
            labelTexts: labelTexts,
            textColors: [.mainBlue, .mainBlue, .mainBlue],
            verticalSpacing: 4,
            horizontalSpacing: 4)
        
        guard let iconsLabelHorizontalStackView = iconsLabelHorizontalStackView else { return }
        contentView.addSubview(iconsLabelHorizontalStackView)
        NSLayoutConstraint.activate([
            iconsLabelHorizontalStackView.topAnchor.constraint(equalTo: todoLabel.bottomAnchor, constant: 6),
            iconsLabelHorizontalStackView.leadingAnchor.constraint(equalTo: todoLabel.leadingAnchor, constant: -20),
            iconsLabelHorizontalStackView.heightAnchor.constraint(equalToConstant: 60),
            iconsLabelHorizontalStackView.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -16),
            iconsLabelHorizontalStackView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -16)
        ])
    }
}
