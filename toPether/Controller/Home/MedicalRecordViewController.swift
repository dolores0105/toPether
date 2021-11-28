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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Medical record"
        self.setNavigationBarColor(bgColor: .white, textColor: .mainBlue, tintColor: .mainBlue)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Button Functions
    
    @objc private func tapOK() {
        guard let medical = medical else {
            
            var newMedical = Medical()
            newMedical = setMedicalValues(medical: newMedical)
            
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
        
        medical.dateOfVisit = dateOfVisitDatePicker.date // in case only update date

        PetManager.shared.updatePetObject(petId: selectedPet.id,
                                          recordId: medical.id,
                                          objectType: .medical,
                                          object: medical) { result in
            switch result {
            case .success(let string):
                print(string)
                self.navigationController?.popViewController(animated: true)
                
            case .failure(let error):
                self.presentErrorAlert(message: error.localizedDescription + " Please try again")
            }
        }
    }
    
    // MARK: - Data Functions
    
    private func renderExistingData(medical: Medical?) {
        guard let medical = medical else { return }
        
        symptomsTextView.text = medical.symptoms
        vetTextField.text = medical.clinic
        doctorNotesTextView.text = medical.vetOrder
        dateOfVisitDatePicker.date = medical.dateOfVisit
    }
    
    private func setMedicalValues(medical: Medical) -> Medical {
        medical.symptoms = symptomsTextView.text ?? "no symptoms"
        medical.dateOfVisit = dateOfVisitDatePicker.date
        medical.clinic = vetTextField.text ?? "no clinic"
        medical.vetOrder = doctorNotesTextView.text ?? "no orders"
        
        return medical
    }
    
    private func checkHaveText() -> Bool {
        if symptomsTextView.hasText && vetTextField.hasText && doctorNotesTextView.hasText {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - UI properties
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        let fullsize = UIScreen.main.bounds.size
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: fullsize.width, height: 550)
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var symptomsLabel = MediumLabel(size: 16, text: "Symptoms", textColor: .mainBlue)
    
    private lazy var symptomsTextView = BlueBorderTextView(self, textSize: 16, height: 64)
    
    private lazy var dateOfVisitLabel = MediumLabel(size: 16, text: "Date of visit", textColor: .mainBlue)
    
    private lazy var dateOfVisitDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.backgroundColor = .white
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var vetLabel = MediumLabel(size: 16, text: "Name of Vet", textColor: .mainBlue)
    
    private lazy var vetTextField: BlueBorderTextField = {
        let vetTextField = BlueBorderTextField(text: nil)
        vetTextField.delegate = self
        return vetTextField
    }()
    
    private lazy var doctorNotesLabel = MediumLabel(size: 16, text: "Doctor's notes", textColor: .mainBlue)
    
    private lazy var doctorNotesTextView = BlueBorderTextView(self, textSize: 16, height: 64)
    
    private lazy var okButton: RoundButton = {
        let okButton = RoundButton(text: "OK", size: 18)
        if medical != nil {
            okButton.isEnabled = true
            okButton.backgroundColor = .mainYellow
        } else {
            okButton.isEnabled = false
            okButton.backgroundColor = .lightBlueGrey
        }
        okButton.addTarget(self, action: #selector(tapOK), for: .touchUpInside)
        return okButton
    }()
}

// MARK: - UITextViewDelegate

extension MedicalRecordViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if checkHaveText() {
            
            okButton.isEnabled = true
            okButton.backgroundColor = .mainYellow
            
            guard var medical = medical else { return }
            medical = setMedicalValues(medical: medical)
            
        } else {
            okButton.isEnabled = false
            okButton.backgroundColor = .lightBlueGrey
        }
    }
}

// MARK: - UITextFieldDelegate

extension MedicalRecordViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if checkHaveText() {
            
            okButton.isEnabled = true
            okButton.backgroundColor = .mainYellow
            
            guard var medical = medical else { return }
            medical = setMedicalValues(medical: medical)
            
        } else {
            okButton.isEnabled = false
            okButton.backgroundColor = .lightBlueGrey
        }
    }
}

// MARK: - UI configure extension

extension MedicalRecordViewController {
    
    private func configScrollView() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configSymptomsLabel() {
        scrollView.addSubview(symptomsLabel)
        NSLayoutConstraint.activate([
            symptomsLabel.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            symptomsLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            symptomsLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    private func configSymptomsTextView() {
        scrollView.addSubview(symptomsTextView)
        NSLayoutConstraint.activate([
            symptomsTextView.topAnchor.constraint(equalTo: symptomsLabel.bottomAnchor, constant: 8),
            symptomsTextView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor,
                                                      constant: 32),
            symptomsTextView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor,
                                                       constant: -32)
        ])
    }
    
    private func configDateOfVisitLabel() {
        scrollView.addSubview(dateOfVisitLabel)
        NSLayoutConstraint.activate([
            dateOfVisitLabel.topAnchor.constraint(equalTo: symptomsTextView.bottomAnchor, constant: 24),
            dateOfVisitLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor,
                                                      constant: 32),
            dateOfVisitLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor,
                                                       constant: -32)
        ])
    }
    
    private func configDateOfVisitDatePicker() {
        scrollView.addSubview(dateOfVisitDatePicker)
        NSLayoutConstraint.activate([
            dateOfVisitDatePicker.topAnchor.constraint(equalTo: dateOfVisitLabel.bottomAnchor, constant: 8),
            dateOfVisitDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            dateOfVisitDatePicker.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func configVetLabel() {
        scrollView.addSubview(vetLabel)
        NSLayoutConstraint.activate([
            vetLabel.topAnchor.constraint(equalTo: dateOfVisitDatePicker.bottomAnchor, constant: 24),
            vetLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            vetLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    private func configVetTextField() {
        scrollView.addSubview(vetTextField)
        NSLayoutConstraint.activate([
            vetTextField.topAnchor.constraint(equalTo: vetLabel.bottomAnchor, constant: 8),
            vetTextField.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            vetTextField.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    private func configDoctorNotesLabel() {
        scrollView.addSubview(doctorNotesLabel)
        NSLayoutConstraint.activate([
            doctorNotesLabel.topAnchor.constraint(equalTo: vetTextField.bottomAnchor, constant: 24),
            doctorNotesLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor,
                                                      constant: 32),
            doctorNotesLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor,
                                                       constant: -32)
        ])
    }
    
    private func configDoctorNotesTextView() {
        scrollView.addSubview(doctorNotesTextView)
        NSLayoutConstraint.activate([
            doctorNotesTextView.topAnchor.constraint(equalTo: doctorNotesLabel.bottomAnchor,
                                                     constant: 8),
            doctorNotesTextView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor,
                                                         constant: 32),
            doctorNotesTextView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -64)
        ])
    }
    
    private func configOkButton() {
        view.addSubview(okButton)
        NSLayoutConstraint.activate([
            okButton.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            okButton.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32),
            okButton.topAnchor.constraint(equalTo: doctorNotesTextView.bottomAnchor, constant: 40)
        ])
    }
}
