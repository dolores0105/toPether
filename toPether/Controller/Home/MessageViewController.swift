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
    
    private var navigationBackgroundView: NavigationBackgroundView!
    private var backgroundView: UIView!
    private var petNameLabel: RegularLabel!
    private var searchBar: UISearchBar!
    private var messageTableView: UITableView!
    private var inputTextView: UITextView!
    private var sendButton: IconButton!
    
    override func viewWillAppear(_ animated: Bool) {
        // MARK: Navigation controller
        self.navigationItem.title = "Message"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.medium(size: 24) as Any, NSAttributedString.Key.foregroundColor: UIColor.white]
        
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
        /*
        guard let currentUser = MemberModel.shared.current else { return }
        PetModel.shared.setMessage(petId: selectedPet.id, senderId: currentUser.id, sentTime: Date(), content: "Friday night QQQQ") { result in
            switch result {
            case .success(let message):
                print(message.sentTime, message.content)
            case .failure(let error):
                print(error)
            }
        }

        PetModel.shared.addMessagesListener(petId: selectedPet.id) { result in
            switch result {
            case .success(let messages):
                for index in messages {
                    print("-->", index.sentTime)
                }
                self.messages = messages
            case .failure(let error):
                print(error)
            }
        }
         */
    }
}

extension MessageViewController: UITableViewDelegate {
    
}

extension MessageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath)
        guard let cell = cell as? FoodTableViewCell else { return cell }
        
        return cell
    }
}

extension MessageViewController {
    
    private func configNavigationBackgroundView() {
        navigationBackgroundView = NavigationBackgroundView()
        view.addSubview(navigationBackgroundView)
        NSLayoutConstraint.activate([
            navigationBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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
//        searchBar.delegate = self
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.centerYAnchor.constraint(equalTo: navigationBackgroundView.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configMessageTableView() {
        messageTableView = UITableView()
        messageTableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageTableViewCell")
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
        sendButton.isHidden = true
        view.addSubview(sendButton)
        NSLayoutConstraint.activate([
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            sendButton.centerYAnchor.constraint(equalTo: inputTextView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 44),
            sendButton.heightAnchor.constraint(equalTo: sendButton.widthAnchor)
        ])
    }
    
    @objc private func tapSend() {
        
    }
}

extension MessageViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.hasText && textView.text != "" {
            messageContent = textView.text
        } else {
            textView.text = "input content"
            textView.textColor = .lightBlueGrey
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.hasText && textView.text != "" {
            sendButton.isHidden = false
        } else {
            sendButton.isHidden = true
        }
    }
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == .lightBlueGrey {
//            textView.text = nil
//            textView.textColor = UIColor.black
//        }
//    }
}
