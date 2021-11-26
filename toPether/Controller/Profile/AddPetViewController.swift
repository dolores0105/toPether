//
//  AddPetViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/22.
//

import UIKit

class AddPetViewController: UIViewController {
    convenience init(currentUser: Member, selectedPet: Pet?, isFirstSignIn: Bool) {
        self.init()
        self.currentUser = currentUser
        self.selectedPet = selectedPet
        self.isFirstSignIn = isFirstSignIn
    }
    private var currentUser: Member!
    private var selectedPet: Pet?
    private var isFirstSignIn: Bool!
    
    private var petImageView: RoundCornerImageView!
    private var uploadImageView: UIImageView!
    private var selectImageButton: UIButton!
    private var nameTitleLabel: MediumLabel!
    private var nameTextField: BlueBorderTextField!
    private var genderTitleLabel: MediumLabel!
    private let genderPickerView = UIPickerView()
    private var genderTextField: BlueBorderTextField!
    private var ageTitleLabel: MediumLabel!
    private let agePickerView = UIPickerView()
    private var ageTextField: BlueBorderTextField!
    private var okButton: RoundButton!
    
    private let genders = ["male", "female"]
    private let years = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    private let months = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    private var selectedGender: String?
    private var selectedYear: Int?
    private var selectedMonth: Int?
    
    override func viewWillAppear(_ animated: Bool) {

        self.navigationItem.title = "Furkid"
        self.setNavigationBarColor(bgColor: .white, textColor: .mainBlue, tintColor: .mainBlue)

        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: UI objects
        view.backgroundColor = .white
        
        petImageView = RoundCornerImageView(img: nil)
        petImageView.backgroundColor = .mainBlue
        view.addSubview(petImageView)
        NSLayoutConstraint.activate([
            petImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            petImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            petImageView.heightAnchor.constraint(equalToConstant: 140),
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
        
        selectImageButton = BorderButton()
        selectImageButton.addTarget(self, action: #selector(tapSelectImg), for: .touchUpInside)
        selectImageButton.backgroundColor = .clear
        selectImageButton.layer.borderWidth = 0
        view.addSubview(selectImageButton)
        NSLayoutConstraint.activate([
            selectImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectImageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            selectImageButton.heightAnchor.constraint(equalToConstant: 140),
            selectImageButton.widthAnchor.constraint(equalTo: selectImageButton.heightAnchor)
        ])
        
        
        nameTitleLabel = MediumLabel(size: 16, text: "Name", textColor: .mainBlue)
        view.addSubview(nameTitleLabel)
        NSLayoutConstraint.activate([
            nameTitleLabel.topAnchor.constraint(equalTo: selectImageButton.bottomAnchor, constant: 32),
            nameTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            nameTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        nameTextField = BlueBorderTextField(text: nil)
        nameTextField.delegate = self
        view.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: nameTitleLabel.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        genderTitleLabel = MediumLabel(size: 16, text: "Gender", textColor: .mainBlue)
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
        genderTextField.delegate = self
        view.addSubview(genderTextField)
        NSLayoutConstraint.activate([
            genderTextField.topAnchor.constraint(equalTo: genderTitleLabel.bottomAnchor, constant: 8),
            genderTextField.leadingAnchor.constraint(equalTo: genderTitleLabel.leadingAnchor),
            genderTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        
        ageTitleLabel = MediumLabel(size: 16, text: "Age", textColor: .mainBlue)
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
        ageTextField.delegate = self
        view.addSubview(ageTextField)
        NSLayoutConstraint.activate([
            ageTextField.topAnchor.constraint(equalTo: ageTitleLabel.bottomAnchor, constant: 8),
            ageTextField.leadingAnchor.constraint(equalTo: ageTitleLabel.leadingAnchor),
            ageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        okButton = RoundButton(text: "OK", size: 18)
        if selectedPet != nil {
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
        
        // MARK: Render data
        renderExistingData(pet: selectedPet)
    }

    // MARK: functions
    func renderExistingData(pet: Pet?) {
        guard let pet = pet else { return }

        petImageView.image = pet.photoImage
        uploadImageView.isHidden = true
        nameTextField.text = pet.name
        genderTextField.text = pet.gender
        (selectedYear, selectedMonth) = PetManager.shared.getYearMonth(from: pet.birthday)
        ageTextField.text = "\(selectedYear ?? 0) year" + " \(selectedMonth ?? 0) month"
    }
    
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
                    MemberModel.shared.current?.petIds.append(petId)
                    MemberModel.shared.updateCurrentUser()
                    
                    if self.isFirstSignIn {
                        let tabBarViewController = TabBarViewController()
                        
                        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                        sceneDelegate?.changeRootViewController(tabBarViewController)
                        
                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                case .failure(let error):
                    print("update petId to currentUser error:", error)
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
}

// MARK: Extension
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

extension AddPetViewController: UINavigationControllerDelegate {
    
}


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
