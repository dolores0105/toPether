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
    
    private var navigationBackgroundView: NavigationBackgroundView!
    private var petNameLabel: RegularLabel!
    private var searchBar: UISearchBar!
    private var foodTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        // MARK: Navigation controller
        self.navigationItem.title = "Food"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.medium(size: 24) as Any, NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Img.iconsAddWhite.obj, style: .plain, target: self, action: #selector(tapAdd))
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationBackgroundView = NavigationBackgroundView()
        view.addSubview(navigationBackgroundView)
        NSLayoutConstraint.activate([
            navigationBackgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: -20),
            navigationBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBackgroundView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        petNameLabel = RegularLabel(size: 16, text: "of \(selectedPet.name)", textColor: .lightBlueGrey)
        view.addSubview(petNameLabel)
        NSLayoutConstraint.activate([
            petNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            petNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        searchBar = BorderSearchBar(placeholder: "Search for food name or notes")
        searchBar.delegate = self
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: navigationBackgroundView.bottomAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        foodTableView = UITableView()
        foodTableView.register(FoodTableViewCell.self, forCellReuseIdentifier: "FoodTableViewCell")
//        foodTableView.separatorColor = .clear
        foodTableView.backgroundColor = .white
        foodTableView.estimatedRowHeight = 100
        foodTableView.rowHeight = UITableView.automaticDimension
        foodTableView.allowsSelection = true
        foodTableView.delegate = self
        foodTableView.dataSource = self
        foodTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(foodTableView)
        NSLayoutConstraint.activate([
            foodTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            foodTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            foodTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            foodTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        /* food CRUD
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.year = 2021
        dateComponents.month = 8
        dateComponents.day = 7
        let mockdate = dateComponents.date
        
        PetModel.shared.setFood(
            petId: selectedPet.id,
            name: "Test food name",
            weight: "800 weight",
            unit: "kg",
            price: "$ 1000",
            market: "Shoppe",
            dateOfPurchase: mockdate!,
            note: "mock note") { result in
            switch result {
            case .success(let food):
                print("food mock", food.dateOfPurchase)
            case .failure(let error):
                print("food mock error", error)
            }
        }
        
        PetModel.shared.queryFoods(petId: selectedPet.id) { result in
            switch result {
            case .success(let foods):
                for index in foods {
                    print(index.dateOfPurchase)
                }
                food[0].dateOfPurchase = mockdate!
                PetModel.shared.updateFood(petId: self.selectedPet.id, recordId: food[0].id, food: food[0])
                PetModel.shared.deleteFood(petId: self.selectedPet.id, recordId: foods[1].id)
            case .failure(let error):
                print("query foods error", error)
            }
        }
         */
    }
    
    @objc func tapAdd(_: UIButton) {
        
    }
}

extension FoodViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchedMedicals = medicals.filter({ (string) -> Bool in
//            return string.symptoms.lowercased().prefix(searchText.count) == searchText.lowercased() || string.vetOrder.lowercased().prefix(searchText.count) == searchText.lowercased()
//        })
//        searching = true
//        medicalTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searching = false
//        searchBar.text = ""
//        medicalTableView.reloadData()
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

extension FoodViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodTableViewCell", for: indexPath)
        guard let cell = cell as? FoodTableViewCell else { return cell }

        cell.selectionStyle = .none
        
        return cell
    }
}

extension FoodViewController: UITableViewDelegate {
    
}
