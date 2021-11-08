//
//  ToDoViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/30.
//

import UIKit
import Lottie

class ToDoViewController: UIViewController {

    private var cardView: CardView!
    private var calendar: UIDatePicker!
    private var toDoTableView: UITableView!
    private var animationView: AnimationView!
    
    override func viewWillAppear(_ animated: Bool) {
        // MARK: Navigation controller
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .mainBlue
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.medium(size: 24) as Any, NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationItem.title = "Todos"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Img.iconsAddWhite.obj, style: .plain, target: self, action: #selector(tapAdd))
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainBlue
        configCardView()
        configCalendar()
        configToDoTableView()
    }
    
    @objc private func tapAdd(_ sender: UIBarButtonItem) {
        // to CU todo page
    }
}

extension ToDoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoTableViewCell", for: indexPath)
        guard let toDoCell = cell as? ToDoTableViewCell else { return cell }
        
        return toDoCell
    }
}

extension ToDoViewController: UITableViewDelegate {
    
}

extension ToDoViewController {
    
    private func configCardView() {
        cardView = CardView(color: .white, cornerRadius: 20)
        view.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configCalendar() {
        calendar = UIDatePicker()
        calendar.datePickerMode = .date
        calendar.preferredDatePickerStyle = .inline
        calendar.tintColor = .mainYellow
        calendar.backgroundColor = .white
        calendar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendar)
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            calendar.heightAnchor.constraint(equalTo: calendar.widthAnchor)
        ])
    }
    
    private func configToDoTableView() {
        toDoTableView = UITableView()
        toDoTableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: "ToDoTableViewCell")
        toDoTableView.separatorColor = .clear
        toDoTableView.backgroundColor = .white
        toDoTableView.estimatedRowHeight = 150
        toDoTableView.rowHeight = UITableView.automaticDimension
        toDoTableView.allowsSelection = true
        toDoTableView.delegate = self
        toDoTableView.dataSource = self
        toDoTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toDoTableView)
        NSLayoutConstraint.activate([
            toDoTableView.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 32),
            toDoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toDoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toDoTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configAnimation() {
        animationView = .init(name: "layingCat")
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.play(completion: nil)
        animationView.loopMode = .loop
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            animationView.heightAnchor.constraint(equalTo: animationView.widthAnchor)
        ])
    }
}
