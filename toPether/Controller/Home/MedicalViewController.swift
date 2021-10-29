//
//  MedicalViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/27.
//

import UIKit
import Firebase
import FirebaseFirestore

class MedicalViewController: UIViewController {
    
    convenience init(selectedPet: Pet?) {
        self.init()
        self.selectedPet = selectedPet
    }
    private var selectedPet: Pet!
    private var medicals = [Medical]()
    private var listener: ListenerRegistration?
    
    private var navigationBackgroundView: NavigationBackgroundView!
    private var petNameLabel: RegularLabel!
    private var searchBar: UISearchBar!
    private var medicalTableView: UITableView!

    private var searching = false
    private var searchedMedicals = [Medical]()
    
    override func viewWillAppear(_ animated: Bool) {
        // MARK: Navigation controller
        self.navigationItem.title = "Medical"
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
        
        searchBar = UISearchBar()
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "Search symptoms or vet's orders"
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = .white
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.mainBlue.cgColor
        searchBar.layer.cornerRadius = 10
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: navigationBackgroundView.bottomAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        medicalTableView = UITableView()
        medicalTableView.register(MedicalTableViewCell.self, forCellReuseIdentifier: "MedicalTableViewCell")
        medicalTableView.separatorColor = .clear
        medicalTableView.backgroundColor = .white
        medicalTableView.estimatedRowHeight = 100
        medicalTableView.rowHeight = UITableView.automaticDimension
        medicalTableView.allowsSelection = true
        medicalTableView.delegate = self
        medicalTableView.dataSource = self
        medicalTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(medicalTableView)
        NSLayoutConstraint.activate([
            medicalTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            medicalTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            medicalTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            medicalTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // MARK: data
        /* Create
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.year = 2020
        dateComponents.month = 10
        dateComponents.day = 28
        let mockdate = dateComponents.date
        
        PetModel.shared.setMedical(petId: selectedPet.id, symptoms: "Mock symptoms", dateOfVisit: mockdate!, clinic: "Clinic", vetOrder: "Brush") { result in
            switch result {
            case .success(let medical):
                print("medical mock", medical.dateOfVisit)
            case .failure(let error):
                print("medical mock error", error)
            }
        }
        */
        // Read
        PetModel.shared.queryMedicals(petId: selectedPet.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let records):
                self.medicals = records
                self.medicalTableView.reloadData()
                
            case .failure(let error):
                print("query medical error", error)
            }
        }
        
        PetModel.shared.addMedicalsListener(petId: selectedPet.id) { result in
            switch result {
            case .success(let records):
                self.medicals = records
                self.medicalTableView.reloadData()
                
            case .failure(let error):
                print("query medical error", error)
            }
        }
    }
    
    // MARK: Functions
    
    @objc func tapAdd(sender: UIButton) {
        let medicalRecordVC = MedicalRecordViewController(selectedPet: selectedPet, medical: nil)
        navigationController?.pushViewController(medicalRecordVC, animated: true)
    }
}

// MARK: extension
extension MedicalViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedMedicals.count
        } else {
            return medicals.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicalTableViewCell", for: indexPath)
        guard let cell = cell as? MedicalTableViewCell else { return cell }
        cell.selectionStyle = .none
        
        if searching {
            cell.reload(medical: searchedMedicals[indexPath.row])
        } else {
            cell.reload(medical: medicals[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMedical = medicals[indexPath.row]
        let medicalRecordVC = MedicalRecordViewController(selectedPet: selectedPet, medical: selectedMedical)
        navigationController?.pushViewController(medicalRecordVC, animated: true)
    }
}

extension MedicalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            PetModel.shared.deleteMedical(petId: self.selectedPet.id, recordId: self.medicals[indexPath.row].id)
            
            completionHandler(true)
        }
        
        deleteAction.image = Img.iconsDelete.obj
        deleteAction.backgroundColor = .white
        
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }
}

extension MedicalViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedMedicals = medicals.filter({ (string) -> Bool in
            return string.symptoms.lowercased().prefix(searchText.count) == searchText.lowercased() || string.vetOrder.lowercased().prefix(searchText.count) == searchText.lowercased()
        })
        searching = true
        medicalTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        medicalTableView.reloadData()
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
