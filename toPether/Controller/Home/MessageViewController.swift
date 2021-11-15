//
//  MessageViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/5.
//

import UIKit

class MessageViewController: UIViewController {
    
    convenience init(selectedPet: Pet?) {
        self.init()
        self.selectedPet = selectedPet
    }
    private var selectedPet: Pet!
    private var messages = [Message]()
    private var messageContent: String?
    private var senderNameCache = [String: String]() { // senderId -> memberName
        didSet {
            messageTableView.reloadData()
        }
    }
    
    private var navigationBackgroundView: NavigationBackgroundView!
    private var backgroundView: UIView!
    private var petNameLabel: RegularLabel!
    private var searchBar: UISearchBar!
    private var messageTableView: UITableView!
    private var inputTextView: UITextView!
    private var sendButton: IconButton!
    
    private var searching = false
    private var keyword: String?
    private var searchedMessages = [Message]()
    
    override func viewWillAppear(_ animated: Bool) {

        self.navigationItem.title = "Message"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .mainBlue
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.medium(size: 22) as Any, NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        appearance.shadowColor = .clear
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainBlue
        configNavigationBackgroundView()
        configBackgroundView()
        configPetNameLabel()
        configSearchBar()
        configMessageTableView()
        configInputTextView()
        configSendButton()
        
        // MARK: Data
        PetModel.shared.addMessagesListener(petId: selectedPet.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let messages):
                self.messages = messages

                for message in messages where self.senderNameCache[message.senderId] == nil {
                    MemberModel.shared.queryMember(id: message.senderId) { [weak self] member in
                        guard let self = self else { return }
                        guard let member = member else {
                            self.senderNameCache[message.senderId] = "anonymous"
                            return
                        }
                        self.senderNameCache[message.senderId] = member.name
                    }
                }
                
                self.messageTableView.reloadData()
                
                if messages.count > 0 {
                    let pathToLastRow = NSIndexPath(row: messages.count - 1, section: 0)
                    self.messageTableView.scrollToRow(at: pathToLastRow as IndexPath, at: .bottom, animated: true)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MessageViewController: UITableViewDelegate {
    
}

extension MessageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchedMessages.count
        } else {
            return messages.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = searching ? searchedMessages[indexPath.row] : messages[indexPath.row]
        let senderName = senderNameCache[message.senderId]
        
        var msgCell: MessageTableViewCell?
        if message.senderId ==  MemberModel.shared.current?.id {
            msgCell = tableView.dequeueReusableCell(withIdentifier: "RightMessageTableViewCell", for: indexPath) as? RightMessageTableViewCell
        } else {
            msgCell = tableView.dequeueReusableCell(withIdentifier: "LeftMessageTableViewCell", for: indexPath) as? LeftMessageTableViewCell
        }
        msgCell?.reload(message: message, senderName: senderName)
        return msgCell ?? .init()
    }
}

extension MessageViewController {
    
    private func configNavigationBackgroundView() {
        navigationBackgroundView = NavigationBackgroundView()
        view.addSubview(navigationBackgroundView)
        NSLayoutConstraint.activate([
            navigationBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBackgroundView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1 / 12)
        ])
    }
    
    private func configBackgroundView() {
        backgroundView = UIView()
        backgroundView.backgroundColor = .white
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: navigationBackgroundView.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func configPetNameLabel() {
        petNameLabel = RegularLabel(size: 16, text: "of \(selectedPet.name)", textColor: .lightBlueGrey)
        view.addSubview(petNameLabel)
        NSLayoutConstraint.activate([
            petNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            petNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func configSearchBar() {
        searchBar = BorderSearchBar(placeholder: "Search for messages")
        searchBar.delegate = self
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.centerYAnchor.constraint(equalTo: navigationBackgroundView.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configMessageTableView() {
        messageTableView = UITableView()
        messageTableView.register(RightMessageTableViewCell.self, forCellReuseIdentifier: "RightMessageTableViewCell")
        messageTableView.register(LeftMessageTableViewCell.self, forCellReuseIdentifier: "LeftMessageTableViewCell")
        messageTableView.separatorColor = .clear
        messageTableView.backgroundColor = .white
        messageTableView.estimatedRowHeight = 60
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.allowsSelection = false
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageTableView)
        NSLayoutConstraint.activate([
            messageTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            messageTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -72)
        ])
    }
    
    private func configInputTextView() {
        inputTextView = UITextView()
        inputTextView.backgroundColor = .white
        inputTextView.textColor = .mainBlue
        inputTextView.font = UIFont.regular(size: 15)
        inputTextView.textAlignment = .left
        inputTextView.isEditable = true
        inputTextView.isSelectable = true
        inputTextView.isScrollEnabled = true
        inputTextView.layer.cornerRadius = 10
        inputTextView.delegate = self
        inputTextView.textContainer.maximumNumberOfLines = 5
        inputTextView.textContainer.lineBreakMode = .byWordWrapping
//        inputTextView.addDoneOnKeyboardWithTarget(self, action: #selector(tapSend))
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputTextView)
        NSLayoutConstraint.activate([
            inputTextView.topAnchor.constraint(equalTo: messageTableView.bottomAnchor, constant: 12),
            inputTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            inputTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            inputTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
    
    private func configSendButton() {
        sendButton = IconButton(self, action: #selector(tapSend), img: Img.iconsSend)
        sendButton.backgroundColor = .mainBlue
        sendButton.alpha = 0.5
        sendButton.isEnabled = false
        view.addSubview(sendButton)
        NSLayoutConstraint.activate([
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            sendButton.centerYAnchor.constraint(equalTo: inputTextView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 44),
            sendButton.heightAnchor.constraint(equalTo: sendButton.widthAnchor)
        ])
    }
    
    @objc private func tapSend(_ sender: IconButton) {
        guard let messageContent = messageContent, let currentUser = MemberModel.shared.current else { return }
        
        PetModel.shared.setMessage(petId: selectedPet.id, senderId: currentUser.id, sentTime: Date(), content: messageContent) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let message):
                print(message.sentTime, message.content)
                self.inputTextView.text = ""
                self.sendButton.alpha = 0.5
                self.sendButton.isEnabled = false
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MessageViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.hasText && textView.text != "" {
            messageContent = textView.text
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.hasText && textView.text != "" {
            messageContent = textView.text
            sendButton.isEnabled = true
            sendButton.alpha = 1
        } else {
            sendButton.isEnabled = false
            sendButton.alpha = 0.5
        }
    }
}

extension MessageViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        keyword = searchBar.text
        searching = true
        search(keyword: keyword)
        messageTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        keyword = searchBar.text
        searching = true
        search(keyword: keyword)
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        messageTableView.reloadData()
        searchBar.endEditing(true)
    }
    
    private func search(keyword: String?) {
        guard let keyword = self.keyword else { return }
        if keyword != "" {
            searchedMessages = messages.filter({ $0.content.lowercased().contains(keyword.lowercased())
            })
        } else {
            searchedMessages = messages
            searching = false
            searchBar.endEditing(true)
        }
    }
}
