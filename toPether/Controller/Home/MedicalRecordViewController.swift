//
//  MedicalRecordViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/29.
//

import UIKit

class MedicalRecordViewController: UIViewController {
    
    convenience init(selectedPet: Pet, medical: Medical?) {
        self.init()
        self.selectedPet = selectedPet
        self.medical = medical
    }
    private var selectedPet: Pet!
    private var medical: Medical?
    
    private var symptomsLabel: MediumLabel!
    private var symptomsTextField: BlueBorderTextField!
    private var dateOfVisitLabel: MediumLabel!
    private let dateOfVisitDatePicker = UIDatePicker()
    private var clinicLabel: MediumLabel!
    private var clinicTextField: BlueBorderTextField!
    private var vetOrderLabel: MediumLabel!
    private var vetOrderTextField: BlueBorderTextField!
    private var okButton: RoundButton!
    
    override func viewWillAppear(_ animated: Bool) {
        // MARK: Navigation controller
        self.navigationItem.title = "Medical record"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.medium(size: 24) as Any, NSAttributedString.Key.foregroundColor: UIColor.mainBlue]
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configSymptomsLabel()
        configSymptomsTextField()
        configDateOfVisitLabel()
        configDateOfVisitDatePicker()
        configClinicLabel()
        configClinicTextField()
        configVetOrderLabel()
        configVetOrderTextField()
        configOkButton()
        
        renderExistingData(medical: medical)
    }
    
    // MARK: layout
    private func configSymptomsLabel() {
        symptomsLabel = MediumLabel(size: 16, text: "Symptoms", textColor: .mainBlue)
        view.addSubview(symptomsLabel)
        NSLayoutConstraint.activate([
            symptomsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            symptomsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            symptomsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    private func configSymptomsTextField() {
        symptomsTextField = BlueBorderTextField(text: nil)
        symptomsTextField.delegate = self
        view.addSubview(symptomsTextField)
        NSLayoutConstraint.activate([
            symptomsTextField.topAnchor.constraint(equalTo: symptomsLabel.bottomAnchor, constant: 8),
            symptomsTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            symptomsTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configDateOfVisitLabel() {
        dateOfVisitLabel = MediumLabel(size: 16, text: "Date of visit", textColor: .mainBlue)
        view.addSubview(dateOfVisitLabel)
        NSLayoutConstraint.activate([
            dateOfVisitLabel.topAnchor.constraint(equalTo: symptomsTextField.bottomAnchor, constant: 24),
            dateOfVisitLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            dateOfVisitLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configDateOfVisitDatePicker() {
        dateOfVisitDatePicker.datePickerMode = .date
        dateOfVisitDatePicker.preferredDatePickerStyle = .compact
        dateOfVisitDatePicker.backgroundColor = .white
        dateOfVisitDatePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateOfVisitDatePicker)
        NSLayoutConstraint.activate([
            dateOfVisitDatePicker.topAnchor.constraint(equalTo: dateOfVisitLabel.bottomAnchor, constant: 8),
            dateOfVisitDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            dateOfVisitDatePicker.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func configClinicLabel() {
        clinicLabel = MediumLabel(size: 16, text: "Clinic", textColor: .mainBlue)
        view.addSubview(clinicLabel)
        NSLayoutConstraint.activate([
            clinicLabel.topAnchor.constraint(equalTo: dateOfVisitDatePicker.bottomAnchor, constant: 24),
            clinicLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            clinicLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configClinicTextField() {
        clinicTextField = BlueBorderTextField(text: nil)
        clinicTextField.delegate = self
        view.addSubview(clinicTextField)
        NSLayoutConstraint.activate([
            clinicTextField.topAnchor.constraint(equalTo: clinicLabel.bottomAnchor, constant: 8),
            clinicTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            clinicTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configVetOrderLabel() {
        vetOrderLabel = MediumLabel(size: 16, text: "Vet's order", textColor: .mainBlue)
        view.addSubview(vetOrderLabel)
        NSLayoutConstraint.activate([
            vetOrderLabel.topAnchor.constraint(equalTo: clinicTextField.bottomAnchor, constant: 24),
            vetOrderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            vetOrderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configVetOrderTextField() {
        vetOrderTextField = BlueBorderTextField(text: nil)
        vetOrderTextField.delegate = self
        view.addSubview(vetOrderTextField)
        NSLayoutConstraint.activate([
            vetOrderTextField.topAnchor.constraint(equalTo: vetOrderLabel.bottomAnchor, constant: 8),
            vetOrderTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            vetOrderTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configOkButton() {
        okButton = RoundButton(text: "OK", size: 18)
        if medical != nil {
            okButton.isEnabled = true
            okButton.backgroundColor = .mainYellow
        } else {
            okButton.isEnabled = false
            okButton.backgroundColor = .lightBlueGrey
        }
        okButton.addTarget(self, action: #selector(tapOK), for: .touchUpInside)
        view.addSubview(okButton)
        NSLayoutConstraint.activate([
            okButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            okButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            okButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32)
        ])
    }
    
    func renderExistingData(medical: Medical?) {
        guard let medical = medical else { return }
        
        symptomsTextField.text = medical.symptoms
        clinicTextField.text = medical.clinic
        vetOrderTextField.text = medical.vetOrder
        dateOfVisitDatePicker.date = medical.dateOfVisit
    }
    
    @objc func tapOK() {
        if medical == nil {
            PetModel.shared.setMedical(
                petId: selectedPet.id,
                symptoms: symptomsTextField.text ?? "no symptoms",
                dateOfVisit: dateOfVisitDatePicker.date,
                clinic: clinicTextField.text ?? "no clinic",
                vetOrder: vetOrderTextField.text ?? "no orders") { [weak self] result in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(_):
                        self.navigationController?.popViewController(animated: true)
                        
                    case .failure(let error):
                        print("set medical record error:", error)
                    }
                }
        } else {
            guard let medical = medical else { return }
            PetModel.shared.updateMedical(petId: selectedPet.id, recordId: medical.id, medical: medical)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension MedicalRecordViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if symptomsTextField.hasText && clinicTextField.hasText && vetOrderTextField.hasText {
            
            okButton.isEnabled = true
            okButton.backgroundColor = .mainYellow
            
            guard let medical = medical, let symptoms = symptomsTextField.text, let clinic = clinicTextField.text, let vetOrder = vetOrderTextField.text else { return }
            medical.symptoms = symptoms
            medical.dateOfVisit = dateOfVisitDatePicker.date
            medical.clinic = clinic
            medical.vetOrder = vetOrder
            
        } else {
            okButton.isEnabled = false
            okButton.backgroundColor = .lightBlueGrey
        }
    }
}
