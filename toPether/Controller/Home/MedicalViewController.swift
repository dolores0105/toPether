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
    private var searchBar: BorderSearchBar!
    private var medicalTableView: UITableView!

    private var searching = false
    private var keyword: String?
    private var searchedMedicals = [Medical]()
    
    override func viewWillAppear(_ animated: Bool) {
        // MARK: Navigation controller
        self.navigationItem.title = "Medical"
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Img.iconsAddWhite.obj, style: .plain, target: self, action: #selector(tapAdd))

        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationBackgroundView = NavigationBackgroundView()
        view.addSubview(navigationBackgroundView)
        NSLayoutConstraint.activate([
            navigationBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor ),
            navigationBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBackgroundView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1 / 12)
        ])
        
        petNameLabel = RegularLabel(size: 16, text: "of \(selectedPet.name)", textColor: .lightBlueGrey)
        view.addSubview(petNameLabel)
        NSLayoutConstraint.activate([
            petNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            petNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        searchBar = BorderSearchBar(placeholder: "Search for symptoms or notes")
        searchBar.delegate = self
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.centerYAnchor.constraint(equalTo: navigationBackgroundView.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
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
        guard let medicalCell = cell as? MedicalTableViewCell else { return cell }
        medicalCell.selectionStyle = .none
        
        if searching {
            medicalCell.reload(medical: searchedMedicals[indexPath.row])
        } else {
            medicalCell.reload(medical: medicals[indexPath.row])
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
            
            let deleteAlert = Alert.deleteAlert(title: "Delete medical record", message: "Do you want to delete this record?") {

                PetModel.shared.deleteMedical(petId: self.selectedPet.id, recordId: self.medicals[indexPath.row].id)
            }
            
            self.present(deleteAlert, animated: true)
            
            
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
        keyword = searchBar.text
        search(keyword: searchText)
        searching = true
        medicalTableView.reloadData()
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
        medicalTableView.reloadData()
        searchBar.endEditing(true)
    }
    
    private func search(keyword: String?) {
        guard let keyword = self.keyword else { return }
        if keyword != "" {
            searchedMedicals = medicals.filter({ $0.symptoms.lowercased().contains(keyword.lowercased()) || $0.vetOrder.lowercased().contains(keyword.lowercased()) })
        } else {
            searchedMedicals = medicals
            searching = false
            searchBar.endEditing(true)
        }
    }
}
