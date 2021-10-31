//
//  FoodRecordViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/31.
//

import UIKit

class FoodRecordViewController: UIViewController {

    convenience init(selectedPetId: String, food: Food?) {
        self.init()
        self.selectedPetId = selectedPetId
        self.food = food
    }
    private var selectedPetId: String!
    private var food: Food?
    
    private var scrollView: UIScrollView!
    private var nameLabel: MediumLabel!
    private var nameTextField: BlueBorderTextField!
    private var weightLabel: MediumLabel!
    private var weightTextField: BlueBorderTextField! // number keyboard
    private var unitTextField: BlueBorderTextField!
    private var unitPickerView: UIPickerView!
    private var priceLabel: MediumLabel!
    private var priceTextField: BlueBorderTextField! // number keyboard
    private var marketLabel: MediumLabel!
    private var marketTextField: BlueBorderTextField!
    private var dateOfPurchaseLabel: MediumLabel!
    private var dateOfPurchaseDatePicker = UIDatePicker()
    private var noteLabel: MediumLabel!
    private var noteTextField: BlueBorderTextField!
    private var okButton: RoundButton!
    
    override func viewWillAppear(_ animated: Bool) {
        // MARK: Navigation controller
        self.navigationItem.title = "Food record"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.medium(size: 24) as Any, NSAttributedString.Key.foregroundColor: UIColor.mainBlue]
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configNameLabel()
        configNameTextField()
        configWeightLabel()
        configWeightTextField()
        configUnitTextField()
        configPriceLabel()
        configPriceTextField()
        configMarketLabel()
        configMarketTextField()
        configDateOfPurchaseLabel()
        configDateOfPurchaseDatePicker()
    }
    
    private func configScrollView() {
        scrollView = UIScrollView()
        
    }
    
    private func configNameLabel() {
        nameLabel = MediumLabel(size: 16, text: "Food name", textColor: .mainBlue)
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
 
    private func configNameTextField() {
        nameTextField = BlueBorderTextField(text: nil)
        nameTextField.delegate = self
        view.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configWeightLabel() {
        weightLabel = MediumLabel(size: 16, text: "Weight", textColor: .mainBlue)
        view.addSubview(weightLabel)
        NSLayoutConstraint.activate([
            weightLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            weightLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            weightLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configWeightTextField() {
        weightTextField = BlueBorderTextField(text: nil)
        weightTextField.keyboardType = .numberPad
        weightTextField.delegate = self
        view.addSubview(weightTextField)
        NSLayoutConstraint.activate([
            weightTextField.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 8),
            weightTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            weightTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2 / 3, constant: -40)
        ])
    }
    
    private func configUnitTextField() {
        unitTextField = BlueBorderTextField(text: nil)
        unitTextField.placeholder = "Unit"
//        unitTextField.inputView = unitPickerView
        unitTextField.delegate = self
        view.addSubview(unitTextField)
        NSLayoutConstraint.activate([
            unitTextField.topAnchor.constraint(equalTo: weightTextField.topAnchor),
            unitTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            unitTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 3, constant: -40)
        ])
    }
    
    private func configPriceLabel() {
        priceLabel = MediumLabel(size: 16, text: "Price", textColor: .mainBlue)
        view.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: weightTextField.bottomAnchor, constant: 24),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configPriceTextField() {
        priceTextField = BlueBorderTextField(text: nil)
        priceTextField.keyboardType = .numberPad
        priceTextField.delegate = self
        view.addSubview(priceTextField)
        NSLayoutConstraint.activate([
            priceTextField.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            priceTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            priceTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configMarketLabel() {
        marketLabel = MediumLabel(size: 16, text: "Market", textColor: .mainBlue)
        view.addSubview(marketLabel)
        NSLayoutConstraint.activate([
            marketLabel.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 24),
            marketLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            marketLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configMarketTextField() {
        marketTextField = BlueBorderTextField(text: nil)
        marketTextField.delegate = self
        view.addSubview(marketTextField)
        NSLayoutConstraint.activate([
            marketTextField.topAnchor.constraint(equalTo: marketLabel.bottomAnchor, constant: 8),
            marketTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            marketTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configDateOfPurchaseLabel() {
        dateOfPurchaseLabel = MediumLabel(size: 16, text: "Date of Purchase", textColor: .mainBlue)
        view.addSubview(dateOfPurchaseLabel)
        NSLayoutConstraint.activate([
            dateOfPurchaseLabel.topAnchor.constraint(equalTo: marketTextField.bottomAnchor, constant: 24),
            dateOfPurchaseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            dateOfPurchaseLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configDateOfPurchaseDatePicker() {
        dateOfPurchaseDatePicker.datePickerMode = .date
        dateOfPurchaseDatePicker.preferredDatePickerStyle = .compact
        dateOfPurchaseDatePicker.backgroundColor = .white
        dateOfPurchaseDatePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateOfPurchaseDatePicker)
        NSLayoutConstraint.activate([
            dateOfPurchaseDatePicker.topAnchor.constraint(equalTo: dateOfPurchaseLabel.bottomAnchor, constant: 8),
            dateOfPurchaseDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            dateOfPurchaseDatePicker.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}

extension FoodRecordViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
//        if symptomsTextField.hasText && clinicTextField.hasText && vetOrderTextField.hasText {
//
//            okButton.isEnabled = true
//            okButton.backgroundColor = .mainYellow
//
//            guard let medical = medical, let symptoms = symptomsTextField.text, let clinic = clinicTextField.text, let vetOrder = vetOrderTextField.text else { return }
//            medical.symptoms = symptoms
//            medical.dateOfVisit = dateOfVisitDatePicker.date
//            medical.clinic = clinic
//            medical.vetOrder = vetOrder
//
//        } else {
//            okButton.isEnabled = false
//            okButton.backgroundColor = .lightBlueGrey
//        }
    }
}
