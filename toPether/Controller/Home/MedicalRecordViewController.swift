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
    
    private var scrollView: UIScrollView!
    private var symptomsLabel: MediumLabel!
    private var symptomsTextView: BlueBorderTextView!
    private var dateOfVisitLabel: MediumLabel!
    private let dateOfVisitDatePicker = UIDatePicker()
    private var vetLabel: MediumLabel!
    private var vetTextField: BlueBorderTextField!
    private var doctorNotesLabel: MediumLabel!
    private var doctorNotesTextView: BlueBorderTextView!
    private var okButton: RoundButton!
    
    override func viewWillAppear(_ animated: Bool) {
 
        self.navigationItem.title = "Medical record"
        self.setNavigationBarColor(bgColor: .white, textColor: .mainBlue, tintColor: .mainBlue)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configScrollView()
        configSymptomsLabel()
        configSymptomsTextView()
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
    private func configScrollView() {
        scrollView = UIScrollView()
        let fullsize = UIScreen.main.bounds.size
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: fullsize.width, height: 550)
        scrollView.isScrollEnabled = true
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configSymptomsLabel() {
        symptomsLabel = MediumLabel(size: 16, text: "Symptoms", textColor: .mainBlue)
        scrollView.addSubview(symptomsLabel)
        NSLayoutConstraint.activate([
            symptomsLabel.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            symptomsLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            symptomsLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    private func configSymptomsTextView() {
        symptomsTextView = BlueBorderTextView(self, textSize: 16, height: 64)
        scrollView.addSubview(symptomsTextView)
        NSLayoutConstraint.activate([
            symptomsTextView.topAnchor.constraint(equalTo: symptomsLabel.bottomAnchor, constant: 8),
            symptomsTextView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            symptomsTextView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    private func configDateOfVisitLabel() {
        dateOfVisitLabel = MediumLabel(size: 16, text: "Date of visit", textColor: .mainBlue)
        scrollView.addSubview(dateOfVisitLabel)
        NSLayoutConstraint.activate([
            dateOfVisitLabel.topAnchor.constraint(equalTo: symptomsTextView.bottomAnchor, constant: 24),
            dateOfVisitLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            dateOfVisitLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    private func configDateOfVisitDatePicker() {
        dateOfVisitDatePicker.datePickerMode = .date
        dateOfVisitDatePicker.preferredDatePickerStyle = .compact
        dateOfVisitDatePicker.backgroundColor = .white
        dateOfVisitDatePicker.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(dateOfVisitDatePicker)
        NSLayoutConstraint.activate([
            dateOfVisitDatePicker.topAnchor.constraint(equalTo: dateOfVisitLabel.bottomAnchor, constant: 8),
            dateOfVisitDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            dateOfVisitDatePicker.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func configVetLabel() {
        vetLabel = MediumLabel(size: 16, text: "Name of Vet", textColor: .mainBlue)
        scrollView.addSubview(vetLabel)
        NSLayoutConstraint.activate([
            vetLabel.topAnchor.constraint(equalTo: dateOfVisitDatePicker.bottomAnchor, constant: 24),
            vetLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            vetLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    private func configVetTextField() {
        vetTextField = BlueBorderTextField(text: nil)
        vetTextField.delegate = self
        scrollView.addSubview(vetTextField)
        NSLayoutConstraint.activate([
            vetTextField.topAnchor.constraint(equalTo: vetLabel.bottomAnchor, constant: 8),
            vetTextField.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            vetTextField.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    private func configDoctorNotesLabel() {
        doctorNotesLabel = MediumLabel(size: 16, text: "Doctor's notes", textColor: .mainBlue)
        scrollView.addSubview(doctorNotesLabel)
        NSLayoutConstraint.activate([
            doctorNotesLabel.topAnchor.constraint(equalTo: vetTextField.bottomAnchor, constant: 24),
            doctorNotesLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            doctorNotesLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    private func configDoctorNotesTextView() {
        doctorNotesTextView = BlueBorderTextView(self, textSize: 16, height: 64)
        scrollView.addSubview(doctorNotesTextView)
        NSLayoutConstraint.activate([
            doctorNotesTextView.topAnchor.constraint(equalTo: doctorNotesLabel.bottomAnchor, constant: 8),
            doctorNotesTextView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            doctorNotesTextView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -64)
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
            okButton.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            okButton.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32),
            okButton.topAnchor.constraint(equalTo: doctorNotesTextView.bottomAnchor, constant: 40)
        ])
    }
    
    func renderExistingData(medical: Medical?) {
        guard let medical = medical else { return }
        
        symptomsTextView.text = medical.symptoms
        vetTextField.text = medical.clinic
        doctorNotesTextView.text = medical.vetOrder
        dateOfVisitDatePicker.date = medical.dateOfVisit
    }
    
    @objc func tapOK() {
        guard let medical = medical else {
            
            // create medical
            var newMedical = Medical()
            newMedical = setMedicalValue(medical: newMedical)
            
            PetManager.shared.setMedical(
                petId: selectedPet.id,
                medical: newMedical) { [weak self] result in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let medicalId):
                        print(medicalId)
                        self.navigationController?.popViewController(animated: true)
                        
                    case .failure(let error):
                        print("set medical record error:", error)
                        self.presentErrorAlert(message: error.localizedDescription + " Please try again")
                    }
                }
            return
        }
        // update medical
        medical.dateOfVisit = dateOfVisitDatePicker.date // in case only update date

        PetManager.shared.updatePetObject(petId: selectedPet.id, recordId: medical.id, objectType: .medical, object: medical) { result in
            switch result {
            case .success(let string):
                print(string)
                self.navigationController?.popViewController(animated: true)
                
            case .failure(let error):
                self.presentErrorAlert(message: error.localizedDescription + " Please try again")
            }
        }
    }
    
    private func setMedicalValue(medical: Medical) -> Medical {
        medical.symptoms = symptomsTextView.text ?? "no symptoms"
        medical.dateOfVisit = dateOfVisitDatePicker.date
        medical.clinic = vetTextField.text ?? "no clinic"
        medical.vetOrder = doctorNotesTextView.text ?? "no orders"
        
        return medical
    }
}

extension MedicalRecordViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if symptomsTextView.hasText && vetTextField.hasText && doctorNotesTextView.hasText {
            
            okButton.isEnabled = true
            okButton.backgroundColor = .mainYellow
            
            guard var medical = medical else { return }
            medical = setMedicalValue(medical: medical)
            
        } else {
            okButton.isEnabled = false
            okButton.backgroundColor = .lightBlueGrey
        }
    }
}

extension MedicalRecordViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if symptomsTextView.hasText && vetTextField.hasText && doctorNotesTextView.hasText {
            
            okButton.isEnabled = true
            okButton.backgroundColor = .mainYellow
            
            guard var medical = medical else { return }
            medical = setMedicalValue(medical: medical)
            
        } else {
            okButton.isEnabled = false
            okButton.backgroundColor = .lightBlueGrey
        }
    }
}
