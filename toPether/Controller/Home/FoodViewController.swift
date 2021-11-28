//
//  FoodViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/30.
//

import UIKit

class FoodViewController: UIViewController {
    
    convenience init(selectedPet: Pet?) {
        self.init()
        self.selectedPet = selectedPet
    }
    private var selectedPet: Pet!
    private var foods = [Food]()
    
    private var searching = false
    private var keyword: String?
    private var searchedFoods = [Food]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configNavigationBackgroundView()
        configPetNameLabel()
        configSearchBar()
        configFoodTableView()
        
        addListener(petId: selectedPet.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.navigationItem.title = "Food"
        self.setNavigationBarColor(bgColor: .mainBlue, textColor: .white, tintColor: .white)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Img.iconsAddWhite.obj,
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(tapAdd))
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Button Functions
    
    @objc func tapAdd(_: UIButton) {
        let foodRecordVC = FoodRecordViewController(selectedPetId: selectedPet.id, food: nil)
        navigationController?.pushViewController(foodRecordVC, animated: true)
    }
    
    // MARK: - Data Functions
    private func addListener(petId: String) {
        PetManager.shared.addFoodsListener(petId: petId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let records):
                self.foods = records
                self.foodTableView.reloadData()
                
                if self.foods.isEmpty {
                    self.configEmptyContentLabel()
                    self.configEmptyAnimation()
                } else {
                    self.emptyContentLabel.removeFromSuperview()
                    self.emptyAnimationView.removeFromSuperview()
                }
                
            case .failure(let error):
                print("listen foods error", error)
                self.presentErrorAlert(message: error.localizedDescription + " Please try again")
            }
        }
    }
    
    // MARK: - UI Properties
    
    private lazy var navigationBackgroundView = NavigationBackgroundView()
    
    private lazy var petNameLabel = RegularLabel(size: 16, text: "of \(selectedPet.name)", textColor: .lightBlueGrey)
    
    private lazy var searchBar: BorderSearchBar = {
        let searchBar = BorderSearchBar(placeholder: "Search for food name or notes")
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var foodTableView: UITableView = {
        let foodTableView = UITableView()
        foodTableView.register(FoodTableViewCell.self, forCellReuseIdentifier: FoodTableViewCell.identifier)
        foodTableView.separatorColor = .clear
        foodTableView.backgroundColor = .white
        foodTableView.estimatedRowHeight = 100
        foodTableView.rowHeight = UITableView.automaticDimension
        foodTableView.allowsSelection = true
        foodTableView.delegate = self
        foodTableView.dataSource = self
        foodTableView.translatesAutoresizingMaskIntoConstraints = false
        return foodTableView
    }()
    
    private lazy var emptyContentLabel = RegularLabel(size: 18,
                                                      text: "Empty records \nTap Plus to create one",
                                                      textColor: .deepBlueGrey)

    private lazy var emptyAnimationView = LottieAnimation.shared.createLoopAnimation(lottieName: "lottieDogSitting")
}

// MARK: - UITableViewDataSource

extension FoodViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedFoods.count
        } else {
            return foods.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FoodTableViewCell.identifier, for: indexPath)
        guard let foodCell = cell as? FoodTableViewCell else { return UITableViewCell() }
        
        foodCell.selectionStyle = .none
        
        let food = searching ? searchedFoods[indexPath.row] : foods[indexPath.row]
        foodCell.reload(food: food)
        
        return foodCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFood = foods[indexPath.row]
        let foodRecordVC = FoodRecordViewController(selectedPetId: selectedPet.id, food: selectedFood)
        navigationController?.pushViewController(foodRecordVC, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension FoodViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            self.presentDeleteAlert(title: "Delete food record") {
                
                PetManager.shared.deletePetObject(petId: self.selectedPet.id,
                                                  recordId: self.foods[indexPath.row].id,
                                                  objectType: .food) { result in
                    switch result {
                    case .success(let string):
                        print(string)
                    case .failure(let error):
                        self.presentErrorAlert(message: error.localizedDescription + " Please try again")
                    }
                }
            }
            
            completionHandler(true)
        }
        
        deleteAction.image = Img.iconsDelete.obj
        deleteAction.backgroundColor = .white
        
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeAction.performsFirstActionWithFullSwipe = false
        
        return swipeAction
    }
}

// MARK: - UISearchBarDelegate

extension FoodViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        keyword = searchBar.text
        searching = true
        search(keyword: keyword)
        foodTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        keyword = searchBar.text
        search(keyword: keyword)
        searching = true
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        foodTableView.reloadData()
        searchBar.endEditing(true)
    }
    
    private func search(keyword: String?) {
        guard let keyword = self.keyword else { return }
        if keyword != "" {
            searchedFoods = foods.filter({ $0.name.lowercased().contains(keyword.lowercased()) || $0.note.lowercased().contains(keyword.lowercased()) })
        } else {
            searchedFoods = foods
            searching = false
            searchBar.endEditing(true)
        }
    }
}

// MARK: - UI configure extension

extension FoodViewController {
    
    private func configNavigationBackgroundView() {
        view.addSubview(navigationBackgroundView)
        NSLayoutConstraint.activate([
            navigationBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBackgroundView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1 / 12)
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
    
    private func configFoodTableView() {
        view.addSubview(foodTableView)
        NSLayoutConstraint.activate([
            foodTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            foodTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            foodTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            foodTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configEmptyContentLabel() {
        emptyContentLabel.textAlignment = .center
        emptyContentLabel.numberOfLines = 0
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
