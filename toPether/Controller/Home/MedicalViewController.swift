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

    private var searching = false
    private var keyword: String?
    private var searchedMedicals = [Medical]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configNavigationBackgroundView()
        configPetNameLabel()
        configSearchBar()
        configMedicalTableView()
        
        // MARK: data
        PetManager.shared.queryMedicals(petId: selectedPet.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let records):
                self.medicals = records
                self.medicalTableView.reloadData()
                
            case .failure(let error):
                print("query medical error", error)
            }
        }
        
        PetManager.shared.addMedicalsListener(petId: selectedPet.id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let records):
                self.medicals = records
                self.medicalTableView.reloadData()
                if self.medicals.isEmpty {
                    self.configEmptyContentLabel()
                    self.configEmptyAnimation()
                } else {
                    self.emptyContentLabel.removeFromSuperview()
                    self.emptyAnimationView.removeFromSuperview()
                }
                
            case .failure(let error):
                print("query medical error", error)
                self.presentErrorAlert(message: error.localizedDescription + " Please try again")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Medical"
        self.setNavigationBarColor(bgColor: .mainBlue, textColor: .white, tintColor: .white)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Img.iconsAddWhite.obj, style: .plain, target: self, action: #selector(tapAdd))

        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    // MARK: - Button Functions
    
    @objc func tapAdd(sender: UIButton) {
        let medicalRecordVC = MedicalRecordViewController(selectedPet: selectedPet, medical: nil)
        navigationController?.pushViewController(medicalRecordVC, animated: true)
    }
    
    // MARK: - UI properties
    
    private lazy var navigationBackgroundView = NavigationBackgroundView()
    
    private lazy var petNameLabel = RegularLabel(size: 16, text: "of \(selectedPet.name)", textColor: .lightBlueGrey)
    
    private lazy var searchBar: BorderSearchBar = {
        let searchBar = BorderSearchBar(placeholder: "Search for symptoms or notes")
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var medicalTableView: UITableView = {
        let medicalTableView = UITableView()
        medicalTableView.register(MedicalTableViewCell.self, forCellReuseIdentifier: MedicalTableViewCell.identifier)
        medicalTableView.separatorColor = .clear
        medicalTableView.backgroundColor = .white
        medicalTableView.estimatedRowHeight = 100
        medicalTableView.rowHeight = UITableView.automaticDimension
        medicalTableView.allowsSelection = true
        medicalTableView.delegate = self
        medicalTableView.dataSource = self
        medicalTableView.translatesAutoresizingMaskIntoConstraints = false
        return medicalTableView
    }()
    
    private lazy var emptyContentLabel = RegularLabel(size: 18, text: "Empty records \nTap Plus to create one", textColor: .deepBlueGrey)
    
    private lazy var emptyAnimationView = LottieAnimation.shared.createLoopAnimation(lottieName: "lottieDogSitting")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: MedicalTableViewCell.identifier, for: indexPath)
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
            
            self.presentDeleteAlert(title: "Delete medical record") {

                PetManager.shared.deletePetObject(petId: self.selectedPet.id, recordId: self.medicals[indexPath.row].id, objectType: .medical) { result in
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

extension MedicalViewController {

    private func configNavigationBackgroundView() {
        view.addSubview(navigationBackgroundView)
        NSLayoutConstraint.activate([
            navigationBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor ),
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
    
    private func configMedicalTableView() {
        view.addSubview(medicalTableView)
        NSLayoutConstraint.activate([
            medicalTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            medicalTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            medicalTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            medicalTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
