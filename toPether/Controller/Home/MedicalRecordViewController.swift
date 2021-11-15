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
    private var vetLabel: MediumLabel!
    private var vetTextField: BlueBorderTextField!
    private var doctorNotesLabel: MediumLabel!
    private var doctorNotesTextView: BlueBorderTextView!
    private var okButton: RoundButton!
    
    override func viewWillAppear(_ animated: Bool) {
 
        self.navigationItem.title = "Medical record"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.medium(size: 22) as Any, NSAttributedString.Key.foregroundColor: UIColor.mainBlue]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        appearance.shadowColor = .clear
        navigationController?.navigationBar.tintColor = .mainBlue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configSymptomsLabel()
        configSymptomsTextField()
        configDateOfVisitLabel()
        configDateOfVisitDatePicker()
        configVetLabel()
        configVetTextField()
        configDoctorNotesLabel()
        configDoctorNotesTextView()
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
    
    private func configVetLabel() {
        vetLabel = MediumLabel(size: 16, text: "Name of Vet", textColor: .mainBlue)
        view.addSubview(vetLabel)
        NSLayoutConstraint.activate([
            vetLabel.topAnchor.constraint(equalTo: dateOfVisitDatePicker.bottomAnchor, constant: 24),
            vetLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            vetLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configVetTextField() {
        vetTextField = BlueBorderTextField(text: nil)
        vetTextField.delegate = self
        view.addSubview(vetTextField)
        NSLayoutConstraint.activate([
            vetTextField.topAnchor.constraint(equalTo: vetLabel.bottomAnchor, constant: 8),
            vetTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            vetTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configDoctorNotesLabel() {
        doctorNotesLabel = MediumLabel(size: 16, text: "Doctor's notes", textColor: .mainBlue)
        view.addSubview(doctorNotesLabel)
        NSLayoutConstraint.activate([
            doctorNotesLabel.topAnchor.constraint(equalTo: vetTextField.bottomAnchor, constant: 24),
            doctorNotesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            doctorNotesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configDoctorNotesTextView() {
        doctorNotesTextView = BlueBorderTextView(self, textSize: 16, height: 64)
        view.addSubview(doctorNotesTextView)
        NSLayoutConstraint.activate([
            doctorNotesTextView.topAnchor.constraint(equalTo: doctorNotesLabel.bottomAnchor, constant: 8),
            doctorNotesTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            doctorNotesTextView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64)
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
        vetTextField.text = medical.clinic
        doctorNotesTextView.text = medical.vetOrder
        dateOfVisitDatePicker.date = medical.dateOfVisit
    }
    
    @objc func tapOK() {
        if medical == nil {
            PetModel.shared.setMedical(
                petId: selectedPet.id,
                symptoms: symptomsTextField.text ?? "no symptoms",
                dateOfVisit: dateOfVisitDatePicker.date,
                clinic: vetTextField.text ?? "no clinic",
                vetOrder: doctorNotesTextView.text ?? "no orders") { [weak self] result in
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
            
            medical.dateOfVisit = dateOfVisitDatePicker.date // in case only update date
            
            PetModel.shared.updateMedical(petId: selectedPet.id, recordId: medical.id, medical: medical)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension MedicalRecordViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if symptomsTextField.hasText && vetTextField.hasText && textView.hasText {
            
            okButton.isEnabled = true
            okButton.backgroundColor = .mainYellow
            
            guard let medical = medical, let symptoms = symptomsTextField.text, let clinic = vetTextField.text, let vetOrder = doctorNotesTextView.text else { return }
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

extension MedicalRecordViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if symptomsTextField.hasText && vetTextField.hasText && doctorNotesTextView.hasText {
            
            okButton.isEnabled = true
            okButton.backgroundColor = .mainYellow
            
            guard let medical = medical, let symptoms = symptomsTextField.text, let clinic = vetTextField.text, let vetOrder = doctorNotesTextView.text else { return }
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
