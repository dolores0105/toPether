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
    private var units = ["kg", "g", "lb"]
    
    // MARK: - Life Cycle
    
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
        configNoteTextView()
        configOkButton()
        
        renderExistingData(food: food)
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.navigationItem.title = "Food record"
        self.setNavigationBarColor(bgColor: .white, textColor: .mainBlue, tintColor: .mainBlue)

        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Button Functions
    
    @objc func tapOK(_: RoundButton) {
        
        configLoadingAnimation()
        
        guard let food = food else {

            var newFood = Food()
            newFood = setFoodValue(food: newFood)
            
            PetManager.shared.setFood(
                petId: selectedPetId,
                food: newFood) { [weak self] result in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let foodId):
                        print(foodId)
                        
                        LottieAnimation.shared.stopAnimation(lottieAnimation: self.loadingAnimationView)
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    case .failure(let error):
                        self.presentErrorAlert(message: error.localizedDescription + " Please try again")
                    }
                }
            return
        }
        
        food.dateOfPurchase = dateOfPurchaseDatePicker.date // in case only update date

        PetManager.shared.updatePetObject(petId: selectedPetId,
                                          recordId: food.id,
                                          objectType: .food,
                                          object: food) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let string):
                print(string)
                
                LottieAnimation.shared.stopAnimation(lottieAnimation: self.loadingAnimationView)
                self.navigationController?.popViewController(animated: true)
                
            case .failure(let error):
                self.presentErrorAlert(message: error.localizedDescription + " Please try again")
            }
        }
    }
    
    // MARK: - Data Functions
    
    func renderExistingData(food: Food?) {
        guard let food = food else { return }
        
        nameTextField.text = food.name
        weightTextField.text = food.weight
        unitTextField.text = food.unit
        priceTextField.text = food.price
        marketTextField.text = food.market
        dateOfPurchaseDatePicker.date = food.dateOfPurchase
        noteTextView.text = food.note
    }
    
    private func setFoodValue(food: Food) -> Food {
        food.name = nameTextField.text ?? "no value"
        food.weight = weightTextField.text ?? "no value"
        food.unit = unitTextField.text ?? "no value"
        food.price = priceTextField.text ?? "no value"
        food.market = marketTextField.text ?? "no value"
        food.dateOfPurchase = dateOfPurchaseDatePicker.date
        food.note = noteTextView.text ?? "no value"
        
        return food
    }
    
    // MARK: - UI properties
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        let fullsize = UIScreen.main.bounds.size
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: fullsize.width, height: 750)
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var nameLabel = MediumLabel(size: 16, text: "Name", textColor: .mainBlue)
    
    private lazy var nameTextField: BlueBorderTextField = {
        let nameTextField = BlueBorderTextField(text: nil)
        nameTextField.delegate = self
        return nameTextField
    }()
    
    private lazy var weightLabel = MediumLabel(size: 16, text: "Weight", textColor: .mainBlue)
    
    private lazy var weightTextField: BlueBorderTextField = {
        let weightTextField = BlueBorderTextField(text: nil)
        weightTextField.keyboardType = .numberPad
        weightTextField.delegate = self
        return weightTextField
    }()
    
    private lazy var unitPickerView: UIPickerView = {
        let unitPickerView = UIPickerView()
        unitPickerView.delegate = self
        unitPickerView.dataSource = self
        return unitPickerView
    }()
    
    private lazy var unitTextField: BlueBorderTextField = {
        let unitTextField = BlueBorderTextField(text: nil)
        unitTextField.inputView = unitPickerView
        unitTextField.placeholder = "Unit"
        unitTextField.delegate = self
        return unitTextField
    }()
    
    private lazy var priceLabel = MediumLabel(size: 16, text: "Price", textColor: .mainBlue)
    
    private lazy var priceTextField: BlueBorderTextField = {
        let priceTextField = BlueBorderTextField(text: nil)
        priceTextField.keyboardType = .numberPad
        priceTextField.delegate = self
        return priceTextField
    }()
    
    private lazy var marketLabel = MediumLabel(size: 16, text: "Purchase from", textColor: .mainBlue)
    
    private lazy var marketTextField: BlueBorderTextField = {
        let marketTextField = BlueBorderTextField(text: nil)
        marketTextField.delegate = self
        return marketTextField
    }()
    
    private lazy var dateOfPurchaseLabel = MediumLabel(size: 16, text: "Date of Purchase", textColor: .mainBlue)
    
    private lazy var dateOfPurchaseDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.backgroundColor = .white
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private lazy var noteLabel = MediumLabel(size: 16, text: "Notes", textColor: .mainBlue)
    
    private lazy var noteTextView = BlueBorderTextView(self, textSize: 16, height: 72)
    
    private lazy var okButton: RoundButton = {
        let okButton = RoundButton(text: "OK", size: 18)
        okButton.addTarget(self, action: #selector(tapOK), for: .touchUpInside)
        return okButton
    }()
    
    private lazy var loadingAnimationView = LottieAnimation.shared.createLoopAnimation(lottieName: "lottieLoading")
}

// MARK: - UITextViewDelegate

extension FoodRecordViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if nameTextField.hasText && weightTextField.hasText && unitTextField.hasText && priceTextField.hasText && marketTextField.hasText && textView.hasText {
            
            okButton.isEnabled = true
            okButton.backgroundColor = .mainYellow

            guard var food = food else { return }
            food = setFoodValue(food: food)

        } else {
            
            okButton.isEnabled = false
            okButton.backgroundColor = .lightBlueGrey
        }
    }
}

// MARK: - UITextFieldDelegate

extension FoodRecordViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if nameTextField.hasText && weightTextField.hasText && unitTextField.hasText && priceTextField.hasText && marketTextField.hasText && noteTextView.hasText {

            okButton.isEnabled = true
            okButton.backgroundColor = .mainYellow

            guard var food = food else { return }
            food = setFoodValue(food: food)

        } else {
            okButton.isEnabled = false
            okButton.backgroundColor = .lightBlueGrey
        }
    }
}

// MARK: - UIPickerViewDelegate

extension FoodRecordViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return units[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        unitTextField.text = units[row]
    }
}

// MARK: - UIPickerViewDataSource

extension FoodRecordViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        units.count
    }
}

// MARK: - UI configure extension

extension FoodRecordViewController {
    
    private func configScrollView() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configNameLabel() {
        scrollView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            nameLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
 
    private func configNameTextField() {
        scrollView.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            nameTextField.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -64)
        ])
    }
    
    private func configWeightLabel() {
        scrollView.addSubview(weightLabel)
        NSLayoutConstraint.activate([
            weightLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            weightLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            weightLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    private func configWeightTextField() {
        scrollView.addSubview(weightTextField)
        NSLayoutConstraint.activate([
            weightTextField.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 8),
            weightTextField.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            weightTextField.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, multiplier: 2 / 3, constant: -40)
        ])
    }
    
    private func configUnitTextField() {
        scrollView.addSubview(unitTextField)
        NSLayoutConstraint.activate([
            unitTextField.topAnchor.constraint(equalTo: weightTextField.topAnchor),
            unitTextField.leadingAnchor.constraint(equalTo: weightTextField.trailingAnchor, constant: 16),
            unitTextField.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, multiplier: 1 / 3, constant: -40)
        ])
    }
    
    private func configPriceLabel() {
        scrollView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: weightTextField.bottomAnchor, constant: 24),
            priceLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            priceLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    private func configPriceTextField() {
        scrollView.addSubview(priceTextField)
        NSLayoutConstraint.activate([
            priceTextField.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            priceTextField.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            priceTextField.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -64)
        ])
    }
    
    private func configMarketLabel() {
        scrollView.addSubview(marketLabel)
        NSLayoutConstraint.activate([
            marketLabel.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 24),
            marketLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            marketLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    private func configMarketTextField() {
        scrollView.addSubview(marketTextField)
        NSLayoutConstraint.activate([
            marketTextField.topAnchor.constraint(equalTo: marketLabel.bottomAnchor, constant: 8),
            marketTextField.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            marketTextField.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -64)
        ])
    }
    
    private func configDateOfPurchaseLabel() {
        scrollView.addSubview(dateOfPurchaseLabel)
        NSLayoutConstraint.activate([
            dateOfPurchaseLabel.topAnchor.constraint(equalTo: marketTextField.bottomAnchor, constant: 24),
            dateOfPurchaseLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            dateOfPurchaseLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    private func configDateOfPurchaseDatePicker() {
        scrollView.addSubview(dateOfPurchaseDatePicker)
        NSLayoutConstraint.activate([
            dateOfPurchaseDatePicker.topAnchor.constraint(equalTo: dateOfPurchaseLabel.bottomAnchor, constant: 8),
            dateOfPurchaseDatePicker.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            dateOfPurchaseDatePicker.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func configNoteLabel() {
        scrollView.addSubview(noteLabel)
        NSLayoutConstraint.activate([
            noteLabel.topAnchor.constraint(equalTo: dateOfPurchaseDatePicker.bottomAnchor, constant: 24),
            noteLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            noteLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    private func configNoteTextView() {
        scrollView.addSubview(noteTextView)
        NSLayoutConstraint.activate([
            noteTextView.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 8),
            noteTextView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            noteTextView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -64)
        ])
    }
    
    private func configOkButton() {
        if food != nil {
            okButton.isEnabled = true
            okButton.backgroundColor = .mainYellow
        } else {
            okButton.isEnabled = false
            okButton.backgroundColor = .lightBlueGrey
        }

        scrollView.addSubview(okButton)
        NSLayoutConstraint.activate([
            okButton.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            okButton.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -64),
            okButton.topAnchor.constraint(equalTo: noteTextView.bottomAnchor, constant: 40)
        ])
    }
    
    private func configLoadingAnimation() {
        view.addSubview(loadingAnimationView)
        NSLayoutConstraint.activate([
            loadingAnimationView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loadingAnimationView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            loadingAnimationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            loadingAnimationView.heightAnchor.constraint(equalTo: loadingAnimationView.widthAnchor)
        ])
    }
}
