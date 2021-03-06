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
    
    private var searching = false
    private var keyword: String?
    private var searchedMessages = [Message]()
    
    private var unblockedmessages = [Message]()
    private var blackList = [String]()
    
    // MARK: - Life Cycles
    
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
        
        addListener(petId: selectedPet.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Message"
        self.setNavigationBarColor(bgColor: .mainBlue, textColor: .white, tintColor: .white)

        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Data Functions
    
    private func addListener(petId: String) {
        PetManager.shared.addMessagesListener(petId: petId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let messages):
                self.messages = messages

                for message in messages where self.senderNameCache[message.senderId] == nil {
                    MemberManager.shared.queryMember(id: message.senderId) { member in

                        guard let member = member else {
                            self.senderNameCache[message.senderId] = "anonymous"
                            return
                        }
                        self.senderNameCache[message.senderId] = member.name
                    }
                }
                
                self.filterMessages {
                    self.messageTableView.reloadData()
                }
                
                if self.unblockedmessages.count > 1 {
                    let pathToLastRow = IndexPath(row: self.unblockedmessages.count - 1, section: 0)
                    self.messageTableView.scrollToRow(at: pathToLastRow as IndexPath, at: .bottom, animated: true)
                }
                
                if self.messages.isEmpty {
                    self.configEmptyContentLabel()
                    self.configEmptyAnimation()
                } else {
                    self.emptyContentLabel.removeFromSuperview()
                    self.emptyAnimationView.removeFromSuperview()
                }
                
            case .failure(let error):
                print(error)
                self.presentErrorAlert(message: error.localizedDescription + " Please try again")
            }
        }
    }
    
    private func filterMessages(completion: () -> Void) {
        self.unblockedmessages = self.messages.filter { message in
            self.selectedPet.memberIds.contains(message.senderId)
        }
        completion()
    }
    
    // MARK: - Button Functions
    
    @objc private func tapSend(_ sender: IconButton) {
        guard let messageContent = messageContent, let currentUser = MemberManager.shared.current else { return }
        
        let message = Message()
        message.senderId = currentUser.id
        message.sentTime = Date()
        message.content = messageContent
        
        PetManager.shared.setMessage(petId: selectedPet.id, message: message) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let message):
                print(message.sentTime, message.content)
                self.inputTextView.text = ""
                self.sendButton.alpha = 0.5
                self.sendButton.isEnabled = false
                
            case .failure(let error):
                print(error)
                self.presentErrorAlert(message: error.localizedDescription + " Please try again")
            }
        }
    }
    
    // MARK: - UI properties
    
    private lazy var navigationBackgroundView: NavigationBackgroundView = {
        let navigationBackgroundView = NavigationBackgroundView()
        return navigationBackgroundView
    }()
    
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundView
    }()
    
    private lazy var petNameLabel: RegularLabel = {
        let petNameLabel = RegularLabel(size: 16, text: "of \(selectedPet.name)", textColor: .lightBlueGrey)
        return petNameLabel
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = BorderSearchBar(placeholder: "Search for messages")
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var messageTableView: UITableView = {
        let messageTableView = UITableView()
        messageTableView.register(RightMessageTableViewCell.self, forCellReuseIdentifier: RightMessageTableViewCell.identifier)
        messageTableView.register(LeftMessageTableViewCell.self, forCellReuseIdentifier: LeftMessageTableViewCell.identifier)
        messageTableView.separatorColor = .clear
        messageTableView.backgroundColor = .white
        messageTableView.estimatedRowHeight = 60
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.allowsSelection = false
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.translatesAutoresizingMaskIntoConstraints = false
        return messageTableView
    }()
    
    private lazy var inputTextView: UITextView = {
        let inputTextView = UITextView()
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
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        return inputTextView
    }()
    private lazy var sendButton: IconButton = {
        let sendButton = IconButton(self, action: #selector(tapSend), img: Img.iconsSend)
        sendButton.backgroundColor = .mainBlue
        sendButton.alpha = 0.5
        sendButton.isEnabled = false
        return sendButton
    }()
    private lazy var emptyContentLabel: RegularLabel = {
        let emptyContentLabel = RegularLabel(size: 18, text: "No one chatted \nSend something to start", textColor: .deepBlueGrey)
        emptyContentLabel.textAlignment = .center
        emptyContentLabel.numberOfLines = 0
        return emptyContentLabel
    }()
    
    private lazy var emptyAnimationView = LottieAnimation.shared.createLoopAnimation(lottieName: "lottieDogSitting")
}

// MARK: - UITableViewDelegate

extension MessageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        if messages[indexPath.row].senderId != MemberManager.shared.current?.id {
            let block = UIAction(title: "Block member", image: Img.iconsBlock.obj) { _ in
                self.presentBlockAlert(title: "Block this member",
                                       message: "Make him/she leave the group, and couln't see the pet info no longer. \n The members in the group also couldn't see his/her messages") { [weak self] in
                    guard let self = self else { return }

                    let blockedMemberId = self.unblockedmessages[indexPath.row].senderId
                    
                    MemberManager.shared.queryMember(id: blockedMemberId) { [weak self] member in
                        guard let self = self else { return }
                        
                        if let member = member { // the member is existing
                            
                            // delete petIds of that member
                            member.petIds.removeAll { $0 == self.selectedPet.id }
                            MemberManager.shared.updateMember(member: member)
                            
                            // delete memberId of the pet
                            self.selectedPet.memberIds.removeAll { $0 == blockedMemberId }
                            
                            PetManager.shared.updatePet(id: self.selectedPet.id, pet: self.selectedPet) { result in
                                switch result {
                                case .success(let string):
                                    print(string)
                                    self.filterMessages {
                                        self.messageTableView.reloadData()
                                    }
                                    
                                case .failure(let error):
                                    self.presentErrorAlert(message: error.localizedDescription + " Please try again")
                                }
                            }

                        } else {
                            self.presentErrorAlert(message: "The member doesn't exist, please try a again later")
                        }
                    }
                }
            }

            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                UIMenu(title: "", children: [block])
            }
        } else {
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                UIMenu(title: "", children: [])
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension MessageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedMessages.count
        } else {
            return unblockedmessages.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = searching ? searchedMessages[indexPath.row] : unblockedmessages[indexPath.row]
        let senderName = senderNameCache[message.senderId]
        
        var msgCell: MessageTableViewCell?
        if message.senderId ==  MemberManager.shared.current?.id {
            msgCell = tableView.dequeueReusableCell(withIdentifier: RightMessageTableViewCell.identifier, for: indexPath) as? RightMessageTableViewCell
        } else {
            msgCell = tableView.dequeueReusableCell(withIdentifier: LeftMessageTableViewCell.identifier, for: indexPath) as? LeftMessageTableViewCell
        }
        msgCell?.reload(message: message, senderName: senderName)
        return msgCell ?? .init()
    }
}

// MARK: - UITextViewDelegate

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

// MARK: - UISearchBarDelegate

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
            searchedMessages = unblockedmessages.filter({ $0.content.lowercased().contains(keyword.lowercased())
            })
        } else {
            searchedMessages = unblockedmessages
            searching = false
            searchBar.endEditing(true)
        }
    }
}

// MARK: - UI configure extension

extension MessageViewController {
    
    private func configNavigationBackgroundView() {
        view.addSubview(navigationBackgroundView)
        NSLayoutConstraint.activate([
            navigationBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBackgroundView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,
                                                             multiplier: 1 / 12)
        ])
    }
    
    private func configBackgroundView() {
        view.addSubview(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: navigationBackgroundView.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func configPetNameLabel() {
        view.addSubview(petNameLabel)
        NSLayoutConstraint.activate([
            petNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            petNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func configSearchBar() {
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.centerYAnchor.constraint(equalTo: navigationBackgroundView.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configMessageTableView() {
        view.addSubview(messageTableView)
        NSLayoutConstraint.activate([
            messageTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            messageTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -72)
        ])
    }
    
    private func configInputTextView() {
        view.addSubview(inputTextView)
        NSLayoutConstraint.activate([
            inputTextView.topAnchor.constraint(equalTo: messageTableView.bottomAnchor, constant: 12),
            inputTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            inputTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            inputTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
    
    private func configSendButton() {
        view.addSubview(sendButton)
        NSLayoutConstraint.activate([
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            sendButton.centerYAnchor.constraint(equalTo: inputTextView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 44),
            sendButton.heightAnchor.constraint(equalTo: sendButton.widthAnchor)
        ])
    }
    
    private func configEmptyContentLabel() {
        view.addSubview(emptyContentLabel)
        NSLayoutConstraint.activate([
            emptyContentLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyContentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyContentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configEmptyAnimation() {
        view.addSubview(emptyAnimationView)
        NSLayoutConstraint.activate([
            emptyAnimationView.topAnchor.constraint(equalTo: emptyContentLabel.bottomAnchor, constant: 24),
            emptyAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyAnimationView.widthAnchor.constraint(equalToConstant: 120),
            emptyAnimationView.heightAnchor.constraint(equalTo: emptyAnimationView.widthAnchor)
        ])
    }
}
