//
//  AddPetViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/22.
//

import UIKit

class AddPetViewController: UIViewController {
    convenience init(currentUser: Member) {
        self.init()
        self.currentUser = currentUser
    }
    private var currentUser: Member!
    
    var petImageView: RoundCornerImageView!
    var uploadImageView: UIImageView!
    var uploadImageButton: UIButton!
    var nameTitleLabel: MediumLabel!
    var nameTextField: BlueBorderTextField!
    var genderTitleLabel: MediumLabel!
    let genderPickerView = UIPickerView()
    var genderTextField: BlueBorderTextField!
    var ageTitleLabel: MediumLabel!
    let agePickerView = UIPickerView()
    var ageTextField: BlueBorderTextField!
    var okButton: RoundButton!
    
    let genders = ["male", "female"]
    let years = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    let months = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    var selectedGender: String?
    var selectedYear: Int?
    var selectedMonth: Int?
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Navigation controller
        self.navigationItem.title = "Furkid"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.medium(size: 24) as Any, NSAttributedString.Key.foregroundColor: UIColor.mainBlue]
        
        // MARK: UI objects
        petImageView = RoundCornerImageView(img: nil)
        petImageView.backgroundColor = .mainBlue
        view.addSubview(petImageView)
        NSLayoutConstraint.activate([
            petImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            petImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            petImageView.heightAnchor.constraint(equalToConstant: 80),
            petImageView.widthAnchor.constraint(equalTo: petImageView.heightAnchor)
        ])
        
        uploadImageView = UIImageView() // when uploaded image, dismiss it
        uploadImageView.image = Img.iconsAddWhite.obj
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(uploadImageView)
        NSLayoutConstraint.activate([
            uploadImageView.centerXAnchor.constraint(equalTo: petImageView.centerXAnchor),
            uploadImageView.centerYAnchor.constraint(equalTo: petImageView.centerYAnchor),
            uploadImageView.widthAnchor.constraint(equalToConstant: 24),
            uploadImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        uploadImageButton = BorderButton()
        uploadImageButton.addTarget(self, action: #selector(tapUploadImg), for: .touchUpInside)
        uploadImageButton.backgroundColor = .clear
        uploadImageButton.layer.borderWidth = 0
        view.addSubview(uploadImageButton)
        NSLayoutConstraint.activate([
            uploadImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uploadImageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            uploadImageButton.heightAnchor.constraint(equalToConstant: 80),
            uploadImageButton.widthAnchor.constraint(equalTo: uploadImageButton.heightAnchor)
        ])
        
        
        nameTitleLabel = MediumLabel(size: 16)
        nameTitleLabel.textColor = .mainBlue
        nameTitleLabel.text = "Name"
        view.addSubview(nameTitleLabel)
        NSLayoutConstraint.activate([
            nameTitleLabel.topAnchor.constraint(equalTo: uploadImageButton.bottomAnchor, constant: 32),
            nameTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            nameTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        nameTextField = BlueBorderTextField(text: nil)
        view.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: nameTitleLabel.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        
        genderTitleLabel = MediumLabel(size: 16)
        genderTitleLabel.textColor = .mainBlue
        genderTitleLabel.text = "Gender"
        view.addSubview(genderTitleLabel)
        NSLayoutConstraint.activate([
            genderTitleLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 32),
            genderTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            genderTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        
        genderTextField = BlueBorderTextField(text: nil)
        genderTextField.inputView = genderPickerView
        view.addSubview(genderTextField)
        NSLayoutConstraint.activate([
            genderTextField.topAnchor.constraint(equalTo: genderTitleLabel.bottomAnchor, constant: 8),
            genderTextField.leadingAnchor.constraint(equalTo: genderTitleLabel.leadingAnchor),
            genderTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        
        ageTitleLabel = MediumLabel(size: 16)
        ageTitleLabel.textColor = .mainBlue
        ageTitleLabel.text = "Age"
        view.addSubview(ageTitleLabel)
        NSLayoutConstraint.activate([
            ageTitleLabel.topAnchor.constraint(equalTo: genderTextField.bottomAnchor, constant: 32),
            ageTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            ageTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        agePickerView.delegate = self
        agePickerView.dataSource = self
        
        ageTextField = BlueBorderTextField(text: nil)
        ageTextField.inputView = agePickerView
        view.addSubview(ageTextField)
        NSLayoutConstraint.activate([
            ageTextField.topAnchor.constraint(equalTo: ageTitleLabel.bottomAnchor, constant: 8),
            ageTextField.leadingAnchor.constraint(equalTo: ageTitleLabel.leadingAnchor),
            ageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        okButton = RoundButton(text: "OK", size: 18)
        okButton.addTarget(self, action: #selector(tapOK), for: .touchUpInside)
        view.addSubview(okButton)
        NSLayoutConstraint.activate([
            okButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            okButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            okButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32)
        ])
    }

    // MARK: functions
    @objc func tapUploadImg(sender: UIButton) {
        
    }
    
    @objc func tapOK(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension AddPetViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == genderPickerView {
            return genders[row]
        } else { // agePickerView
            if component == 0 {
                return "\(years[row]) year"
            } else {
                return "\(months[row]) month"
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genderPickerView {
            genderTextField.text = genders[row]
        } else { // agePickerView
            if component == 0 {
                selectedYear = years[row]
            } else {
                selectedMonth = months[row]
            }
            ageTextField.text = "\(selectedYear ?? 0) year" + " \(selectedMonth ?? 0) month"
            print("選擇的是 \(selectedYear ?? 0) year" + " \(selectedMonth ?? 0) month")
        }
    }
}

extension AddPetViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == genderPickerView {
            return 1
        } else {
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == genderPickerView {
            return genders.count
        } else { // agePickerView
            if component == 0 {
                return years.count
            } else {
                return months.count
            }
        }
    }
    
}
