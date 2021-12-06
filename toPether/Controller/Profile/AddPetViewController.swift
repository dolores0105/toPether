//
//  AddPetViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/22.
//

import UIKit

class AddPetViewController: UIViewController, UIScrollViewDelegate {
    convenience init(currentUser: Member, selectedPet: Pet?, isFirstSignIn: Bool) {
        self.init()
        self.currentUser = currentUser
        self.selectedPet = selectedPet
        self.isFirstSignIn = isFirstSignIn
    }
    private var currentUser: Member!
    private var selectedPet: Pet?
    private var isFirstSignIn: Bool!
    
    private let genders = ["male", "female"]
    private let years = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    private let months = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    private var selectedGender: String?
    private var selectedYear: Int?
    private var selectedMonth: Int?
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configScrollView()
        configPetImageView()
        configUploadImageView()
        configSelectImageButton()
        configNameTitleLabel()
        configNameTextField()
        configGenderTitleLabel()
        configGenderTextField()
        configAgeTitleLabel()
        configAgeTextField()
        configOkButton()
        
        renderExistingData(pet: selectedPet)
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.navigationItem.title = "Furkid"
        self.setNavigationBarColor(bgColor: .white, textColor: .mainBlue, tintColor: .mainBlue)

        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Data Functions
    
    func renderExistingData(pet: Pet?) {
        guard let pet = pet else { return }

        petImageView.image = pet.photoImage
        uploadImageView.isHidden = true
        nameTextField.text = pet.name
        genderTextField.text = pet.gender
        (selectedYear, selectedMonth) = PetManager.shared.getYearMonth(from: pet.birthday)
        ageTextField.text = "\(selectedYear ?? 0) year" + " \(selectedMonth ?? 0) month"
    }
    
    // MARK: - @objc Functions
    
    @objc func tapSelectImg(sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.modalPresentationStyle = .popover
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func tapOK(sender: UIButton) {
        
        if selectedPet == nil { // Create a pet
            var memberIds = [String]()
            memberIds.append(currentUser.id)
            
            let pet = Pet()
            pet.name = nameTextField.text ?? "no value"
            pet.gender = genderTextField.text ?? "male"
            pet.birthday = PetManager.shared.getBirthday(year: selectedYear ?? 0, month: selectedMonth ?? 0) ?? Date()
            pet.memberIds = memberIds
            
            PetManager.shared.setPetData(pet: pet, photo: petImageView.image ?? Img.iconsEdit.obj) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let petId):
                    MemberManager.shared.current?.petIds.append(petId)
                    MemberManager.shared.updateCurrentUser()
                    
                    if self.isFirstSignIn {
                        let tabBarViewController = TabBarViewController()
                        
                        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                        sceneDelegate?.changeRootViewController(tabBarViewController)
                        
                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                case .failure(let error):
                    self.presentErrorAlert(message: error.localizedDescription + " Please try again")
                }
            }
        } else { // Update pet
            guard let selectedPet = selectedPet else { return }

            PetManager.shared.updatePet(id: selectedPet.id, pet: selectedPet) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let string):
                    print(string)
                    self.navigationController?.popViewController(animated: true)
                    
                case .failure(let error):
                    self.presentErrorAlert(message: error.localizedDescription + " Please try again")
                }
            }
        }
    }
    
    // MARK: - UI Properties
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        let fullsize = UIScreen.main.bounds.size
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: fullsize.width, height: 650)
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var petImageView: RoundCornerImageView = {
        let petImageView = RoundCornerImageView(img: nil)
        petImageView.backgroundColor = .mainBlue
        return petImageView
    }()
    
    private lazy var uploadImageView: UIImageView = {
        let uploadImageView = UIImageView()
        uploadImageView.image = Img.iconsAddWhite.obj
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        return uploadImageView
    }()
    
    private lazy var selectImageButton: UIButton = {
        let selectImageButton = BorderButton()
        selectImageButton.addTarget(self, action: #selector(tapSelectImg), for: .touchUpInside)
        selectImageButton.backgroundColor = .clear
        selectImageButton.layer.borderWidth = 0
        return selectImageButton
    }()
    
    private lazy var nameTitleLabel: MediumLabel = {
        let nameTitleLabel = MediumLabel(size: 16, text: "Name", textColor: .mainBlue)
        return nameTitleLabel
    }()
    
    private lazy var nameTextField: BlueBorderTextField = {
        let nameTextField = BlueBorderTextField(text: nil)
        nameTextField.delegate = self
        return nameTextField
    }()
    
    private lazy var genderTitleLabel: MediumLabel = {
        let genderTitleLabel = MediumLabel(size: 16, text: "Gender", textColor: .mainBlue)
        return genderTitleLabel
    }()
    
    private lazy var genderPickerView: UIPickerView = {
        let genderPickerView = UIPickerView()
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        return genderPickerView
    }()
    
    private lazy var genderTextField: BlueBorderTextField = {
        let genderTextField = BlueBorderTextField(text: nil)
        genderTextField.inputView = genderPickerView
        genderTextField.delegate = self
        return genderTextField
    }()
    
    private lazy var ageTitleLabel: MediumLabel = {
        let ageTitleLabel = MediumLabel(size: 16, text: "Age", textColor: .mainBlue)
        return ageTitleLabel
    }()
    
    private lazy var agePickerView: UIPickerView = {
        let agePickerView = UIPickerView()
        agePickerView.delegate = self
        agePickerView.dataSource = self
        return agePickerView
    }()
    
    private lazy var ageTextField: BlueBorderTextField = {
        let ageTextField = BlueBorderTextField(text: nil)
        ageTextField.inputView = agePickerView
        ageTextField.delegate = self
        return ageTextField
    }()
    
    private lazy var okButton: RoundButton = {
        let okButton = RoundButton(text: "OK", size: 18)
        if selectedPet != nil {
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

// MARK: - UIImagePickerControllerDelegate

extension AddPetViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var pickedImage: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            pickedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            pickedImage = originalImage
            print("originalImage size:", originalImage.size)
        }
        
        petImageView.image = pickedImage
        picker.dismiss(animated: true, completion: nil)
        uploadImageView.isHidden = true
        if nameTextField.hasText && genderTextField.hasText && ageTextField.hasText {
            okButton.isEnabled = true
            okButton.backgroundColor = .mainYellow
        }
        
        guard let selectedPet = selectedPet,
              let jpegData06 = pickedImage?.jpegData(compressionQuality: 0.2) else { return }
        let imageBase64String = jpegData06.base64EncodedString()
        selectedPet.photo = imageBase64String
        
    }
}

// MARK: - UINavigationControllerDelegate

extension AddPetViewController: UINavigationControllerDelegate {
    
}

// MARK: - UITextFieldDelegate

extension AddPetViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if petImageView.image != nil && nameTextField.hasText && genderTextField.hasText && ageTextField.hasText {
            
            okButton.isEnabled = true
            okButton.backgroundColor = .mainYellow
            
            guard let selectedPet = selectedPet else { return }
            selectedPet.name = nameTextField.text!
            selectedPet.gender = genderTextField.text!
            guard let birthday = PetManager.shared.getBirthday(year: selectedYear!, month: selectedMonth!) else { return }
            selectedPet.birthday = birthday
            
        } else {
            okButton.isEnabled = false
            okButton.backgroundColor = .lightBlueGrey
        }
    }
}

// MARK: - UIPickerViewDelegate

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

// MARK: - UIPickerViewDataSource

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

// MARK: - UI Configure Functions

extension AddPetViewController {
    
    private func configScrollView() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configPetImageView() {
        scrollView.addSubview(petImageView)
        NSLayoutConstraint.activate([
            petImageView.centerXAnchor.constraint(equalTo: scrollView.frameLayoutGuide.centerXAnchor),
            petImageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 32),
            petImageView.heightAnchor.constraint(equalToConstant: 140),
            petImageView.widthAnchor.constraint(equalTo: petImageView.heightAnchor)
        ])
    }
    
    private func configUploadImageView() {
        scrollView.addSubview(uploadImageView)
        NSLayoutConstraint.activate([
            uploadImageView.centerXAnchor.constraint(equalTo: petImageView.centerXAnchor),
            uploadImageView.centerYAnchor.constraint(equalTo: petImageView.centerYAnchor),
            uploadImageView.widthAnchor.constraint(equalToConstant: 24),
            uploadImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func configSelectImageButton() {
        scrollView.addSubview(selectImageButton)
        NSLayoutConstraint.activate([
            selectImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectImageButton.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 32),
            selectImageButton.heightAnchor.constraint(equalToConstant: 140),
            selectImageButton.widthAnchor.constraint(equalTo: selectImageButton.heightAnchor)
        ])
    }
    
    private func configNameTitleLabel() {
        scrollView.addSubview(nameTitleLabel)
        NSLayoutConstraint.activate([
            nameTitleLabel.topAnchor.constraint(equalTo: selectImageButton.bottomAnchor, constant: 32),
            nameTitleLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            nameTitleLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    private func configNameTextField() {
        scrollView.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: nameTitleLabel.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    private func configGenderTitleLabel() {
        scrollView.addSubview(genderTitleLabel)
        NSLayoutConstraint.activate([
            genderTitleLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 32),
            genderTitleLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            genderTitleLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    private func configGenderTextField() {
        scrollView.addSubview(genderTextField)
        NSLayoutConstraint.activate([
            genderTextField.topAnchor.constraint(equalTo: genderTitleLabel.bottomAnchor, constant: 8),
            genderTextField.leadingAnchor.constraint(equalTo: genderTitleLabel.leadingAnchor),
            genderTextField.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    private func configAgeTitleLabel() {
        scrollView.addSubview(ageTitleLabel)
        NSLayoutConstraint.activate([
            ageTitleLabel.topAnchor.constraint(equalTo: genderTextField.bottomAnchor, constant: 32),
            ageTitleLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            ageTitleLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    private func configAgeTextField() {
        scrollView.addSubview(ageTextField)
        NSLayoutConstraint.activate([
            ageTextField.topAnchor.constraint(equalTo: ageTitleLabel.bottomAnchor, constant: 8),
            ageTextField.leadingAnchor.constraint(equalTo: ageTitleLabel.leadingAnchor),
            ageTextField.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    private func configOkButton() {
        scrollView.addSubview(okButton)
        NSLayoutConstraint.activate([
            okButton.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            okButton.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32),
            okButton.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: 40)
        ])
    }
}
