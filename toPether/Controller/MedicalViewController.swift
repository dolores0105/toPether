//
//  MedicalViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/27.
//

import UIKit

class MedicalViewController: UIViewController {
    
    convenience init(selectedPet: Pet?) {
        self.init()
        self.selectedPet = selectedPet
    }
    private var selectedPet: Pet!
    private var medicals = [Medical]()
//    private var medicalRecords = [Date: [Medical]]()
    
    private var navigationBackgroundView: NavigationBackgroundView!
    private var petNameLabel: RegularLabel!
    private var searchTextField: BlueBorderTextField!
    private var medicalTableView: UITableView!
    
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
        
        searchTextField = BlueBorderTextField(text: "Search symptoms or vet's orders")
        view.addSubview(searchTextField)
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: navigationBackgroundView.bottomAnchor, constant: 20),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        medicalTableView = UITableView()
        medicalTableView.register(MedicalTableViewCell.self, forCellReuseIdentifier: "MedicalTableViewCell")
//        medicalTableView.separatorColor = .clear
        medicalTableView.backgroundColor = .white
        medicalTableView.estimatedRowHeight = 100
        medicalTableView.rowHeight = UITableView.automaticDimension
        medicalTableView.allowsSelection = true
        medicalTableView.delegate = self
        medicalTableView.dataSource = self
        medicalTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(medicalTableView)
        NSLayoutConstraint.activate([
            medicalTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20),
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
//                self.medicalRecords = Dictionary(grouping: medicals, by: { $0.dateOfVisit })
                
            case .failure(let error):
                print("query medical error", error)
            }
        }
        
    }
    
    // MARK: Functions
    
    @objc func tapAdd(sender: UIButton) {
        
    }
}

// MARK: extension
extension MedicalViewController: UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.medicals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicalTableViewCell", for: indexPath)
        guard let cell = cell as? MedicalTableViewCell else { return cell }
        cell.selectionStyle = .none
        cell.reload(medical: medicals[indexPath.row])
        return cell
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        "section \(section)"
//    }
}

extension MedicalViewController: UITableViewDelegate {
    
}
