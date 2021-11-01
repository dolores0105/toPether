//
//  FoodRecordViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/31.
//

import UIKit

class FoodRecordViewController: UIViewController, UIScrollViewDelegate {

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
    
    private let units = ["kg", "g", "lb"]
    private var selectedUnit: String?
    
    override func viewWillAppear(_ animated: Bool) {
        // MARK: Navigation controller
        self.navigationItem.title = "Food record"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.medium(size: 24) as Any, NSAttributedString.Key.foregroundColor: UIColor.mainBlue]
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configScrollView()
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
        configNoteLabel()
        configNoteTextField()
        configOkButton()
        
        renderExistingData(food: food)
    }
    
    private func configScrollView() {
        scrollView = UIScrollView()
        let fullsize = UIScreen.main.bounds.size
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: fullsize.width, height: 750)
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
    
    private func configNameLabel() {
        nameLabel = MediumLabel(size: 16, text: "Name", textColor: .mainBlue)
        scrollView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            nameLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
 
    private func configNameTextField() {
        nameTextField = BlueBorderTextField(text: nil)
        nameTextField.delegate = self
        scrollView.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            nameTextField.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -64)
        ])
    }
    
    private func configWeightLabel() {
        weightLabel = MediumLabel(size: 16, text: "Weight", textColor: .mainBlue)
        scrollView.addSubview(weightLabel)
        NSLayoutConstraint.activate([
            weightLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            weightLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            weightLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    private func configWeightTextField() {
        weightTextField = BlueBorderTextField(text: nil)
        weightTextField.keyboardType = .numberPad
        weightTextField.delegate = self
        scrollView.addSubview(weightTextField)
        NSLayoutConstraint.activate([
            weightTextField.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 8),
            weightTextField.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            weightTextField.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, multiplier: 2 / 3, constant: -40)
        ])
    }
    
    private func configUnitTextField() {
        unitTextField = BlueBorderTextField(text: nil)
        unitPickerView = UIPickerView()
        unitPickerView.delegate = self
        unitPickerView.dataSource = self
        unitTextField.inputView = unitPickerView
        unitTextField.placeholder = "Unit"
        unitTextField.delegate = self
        scrollView.addSubview(unitTextField)
        NSLayoutConstraint.activate([
            unitTextField.topAnchor.constraint(equalTo: weightTextField.topAnchor),
            unitTextField.leadingAnchor.constraint(equalTo: weightTextField.trailingAnchor, constant: 16),
            unitTextField.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, multiplier: 1 / 3, constant: -40)
        ])
    }
    
    private func configPriceLabel() {
        priceLabel = MediumLabel(size: 16, text: "Price", textColor: .mainBlue)
        scrollView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: weightTextField.bottomAnchor, constant: 24),
            priceLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            priceLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    private func configPriceTextField() {
        priceTextField = BlueBorderTextField(text: nil)
        priceTextField.keyboardType = .numberPad
        priceTextField.delegate = self
        scrollView.addSubview(priceTextField)
        NSLayoutConstraint.activate([
            priceTextField.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            priceTextField.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            priceTextField.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -64)
        ])
    }
    
    private func configMarketLabel() {
        marketLabel = MediumLabel(size: 16, text: "Purchase from", textColor: .mainBlue)
        scrollView.addSubview(marketLabel)
        NSLayoutConstraint.activate([
            marketLabel.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 24),
            marketLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            marketLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    private func configMarketTextField() {
        marketTextField = BlueBorderTextField(text: nil)
        marketTextField.delegate = self
        scrollView.addSubview(marketTextField)
        NSLayoutConstraint.activate([
            marketTextField.topAnchor.constraint(equalTo: marketLabel.bottomAnchor, constant: 8),
            marketTextField.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            marketTextField.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -64)
        ])
    }
    
    private func configDateOfPurchaseLabel() {
        dateOfPurchaseLabel = MediumLabel(size: 16, text: "Date of Purchase", textColor: .mainBlue)
        scrollView.addSubview(dateOfPurchaseLabel)
        NSLayoutConstraint.activate([
            dateOfPurchaseLabel.topAnchor.constraint(equalTo: marketTextField.bottomAnchor, constant: 24),
            dateOfPurchaseLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            dateOfPurchaseLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    private func configDateOfPurchaseDatePicker() {
        dateOfPurchaseDatePicker.datePickerMode = .date
        dateOfPurchaseDatePicker.preferredDatePickerStyle = .compact
        dateOfPurchaseDatePicker.backgroundColor = .white
        dateOfPurchaseDatePicker.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(dateOfPurchaseDatePicker)
        NSLayoutConstraint.activate([
            dateOfPurchaseDatePicker.topAnchor.constraint(equalTo: dateOfPurchaseLabel.bottomAnchor, constant: 8),
            dateOfPurchaseDatePicker.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            dateOfPurchaseDatePicker.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func configNoteLabel() {
        noteLabel = MediumLabel(size: 16, text: "Notes", textColor: .mainBlue)
        scrollView.addSubview(noteLabel)
        NSLayoutConstraint.activate([
            noteLabel.topAnchor.constraint(equalTo: dateOfPurchaseDatePicker.bottomAnchor, constant: 24),
            noteLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            noteLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    private func configNoteTextField() {
        noteTextField = BlueBorderTextField(text: nil)
        noteTextField.delegate = self
        scrollView.addSubview(noteTextField)
        NSLayoutConstraint.activate([
            noteTextField.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 8),
            noteTextField.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            noteTextField.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -64)
        ])
    }
    
    func renderExistingData(food: Food?) {
        guard let food = food else { return }
        
        nameTextField.text = food.name
        weightTextField.text = food.weight
        unitTextField.text = food.unit
        priceTextField.text = food.price
        marketTextField.text = food.market
        dateOfPurchaseDatePicker.date = food.dateOfPurchase
        noteTextField.text = food.note
    }
    
    private func configOkButton() {
        okButton = RoundButton(text: "OK", size: 18)
        if food != nil {
            okButton.isEnabled = true
            okButton.backgroundColor = .mainYellow
        } else {
            okButton.isEnabled = false
            okButton.backgroundColor = .lightBlueGrey
        }
        okButton.addTarget(self, action: #selector(tapOK), for: .touchUpInside)
        scrollView.addSubview(okButton)
        NSLayoutConstraint.activate([
            okButton.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            okButton.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -64),
            okButton.topAnchor.constraint(equalTo: noteTextField.bottomAnchor, constant: 40)
        ])
    }
    
    @objc func tapOK(_: RoundButton) {
        
    }
}

extension FoodRecordViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
//        if symptomsTextField.hasText && vetTextField.hasText && doctorNotesTextField.hasText {
//
//            okButton.isEnabled = true
//            okButton.backgroundColor = .mainYellow
//
//            guard let medical = medical, let symptoms = symptomsTextField.text, let clinic = vetTextField.text, let vetOrder = doctorNotesTextField.text else { return }
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

extension FoodRecordViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return units[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        unitTextField.text = units[row]
    }
}

extension FoodRecordViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        units.count
    }
}
