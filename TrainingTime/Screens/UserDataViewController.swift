//
//  UserDataViewController.swift
//  TrainingTime
//
//  Created by Никита Литвинов on 07.05.2021.
//

import Foundation
import UIKit
import PinLayout
import Firebase
import FirebaseFirestore

protocol UserDataOutput: AnyObject {
    func didClose(name: String)
}

class UserDataViewController : UIViewController, UITextFieldDelegate{
    
    private let containerView = UIView()
    private let dataLabel = UILabel()
    private let closeButton = UIButton()
    private var nameField   =  UITextField()
    private var secondNameField = UITextField()
    private var genderField =  UITextField()
    private var heightField =  UITextField()
    private var weightField =  UITextField()
    weak var output: UserDataOutput?
    
    
    private let userManager: UserManagerDescription = UserManager.shared
    
    private var user: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadUser()
        
        view.backgroundColor = UIColor(red: 0.071, green: 0.078, blue: 0.086, alpha: 1)
        dataLabel.backgroundColor = UIColor(red: 0.071, green: 0.078, blue: 0.086, alpha: 1)
        dataLabel.text = "Мои данные"
        dataLabel.textColor = UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1)
        dataLabel.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        
        closeButton.setTitle("Готово", for: .normal)
        closeButton.layer.cornerRadius = 8
        closeButton.layer.masksToBounds = true
        closeButton.backgroundColor = UIColor(red: 0.071, green: 0.078, blue: 0.086, alpha: 1)
        closeButton.setTitleColor(UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1), for:  UIControl.State.highlighted)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for:
        .touchUpInside)
        
        nameField.layer.cornerRadius = 8
        nameField.layer.masksToBounds = true
        nameField.textColor = UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1)
        nameField.backgroundColor = UIColor(red: 0.169, green: 0.18, blue: 0.2, alpha: 1)
        nameField.attributedPlaceholder = NSAttributedString(string: " Имя",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1)])
        nameField.delegate = self
        
        secondNameField.layer.cornerRadius = 8
        secondNameField.layer.masksToBounds = true
        secondNameField.textColor = UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1)
        secondNameField.backgroundColor = UIColor(red: 0.169, green: 0.18, blue: 0.2, alpha: 1)
        secondNameField.attributedPlaceholder = NSAttributedString(string: " Фамилия",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1)])
        secondNameField.delegate = self
        
        genderField.layer.cornerRadius = 8
        genderField.layer.masksToBounds = true
        genderField.textColor = UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1)
        genderField.backgroundColor = UIColor(red: 0.169, green: 0.18, blue: 0.2, alpha: 1)
        genderField.attributedPlaceholder = NSAttributedString(string: " Пол",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1)])
        genderField.delegate = self
        
        heightField.layer.cornerRadius = 8
        heightField.layer.masksToBounds = true
        heightField.textColor = UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1)
        heightField.backgroundColor = UIColor(red: 0.169, green: 0.18, blue: 0.2, alpha: 1)
        heightField.attributedPlaceholder = NSAttributedString(string: " Рост",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1)])
        heightField.delegate = self
        
        weightField.layer.cornerRadius = 8
        weightField.layer.masksToBounds = true
        weightField.textColor = UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1)
        weightField.backgroundColor = UIColor(red: 0.169, green: 0.18, blue: 0.2, alpha: 1)
        weightField.attributedPlaceholder = NSAttributedString(string: " Вес",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1)])
        weightField.delegate = self
        
        
        view.addSubview(closeButton)
        
        [dataLabel, nameField, secondNameField, genderField, heightField, weightField].forEach{
            containerView.addSubview($0)
        }
        view.addSubview(containerView)
    }
    
    
    @objc
    private func didTapCloseButton(){
        let weight = Int(weightField.text!) ?? 0
        let height = Int(heightField.text!) ?? 0
        if genderField.text! == "" {
            
        } else if genderField.text != "Мужской" && genderField.text != "Женский"{
            showAlert(message: "Пол должен быть Мужской/Женский")
            return
        }
        if heightField.text! == "" || weightField.text! == ""{
            
        } else
        if height == 0 || weight == 0{
            showAlert(message: "Значения веса и роста должны быть целочисленными")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("User").document(UserState.shared.userID)
            .updateData(["Name": nameField.text!, "Surname": secondNameField.text!, "Gender": genderField.text!, "Weight": weightField.text!, "Height": heightField.text!])
        dismiss(animated: true, completion: nil)
        
        output?.didClose(name: nameField.text!)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        dataLabel.pin
            .top(20)
            .sizeToFit()
            .hCenter()
        
        closeButton.pin
            .top(5)
            .sizeToFit()
            .right(5)
        
        nameField.pin
            .below(of: dataLabel)
            .marginTop(72)
            .width(231)
            .height(44)
            .hCenter()
        
        secondNameField.pin
            .below(of: nameField)
            .marginTop(34)
            .width(231)
            .height(44)
            .hCenter()
        
        
        genderField.pin
            .below(of: secondNameField)
            .marginTop(34)
            .width(231)
            .height(44)
            .hCenter()
        
        heightField.pin
            .below(of: genderField)
            .marginTop(34)
            .width(231)
            .height(44)
            .hCenter()
        
        weightField.pin
            .below(of: heightField)
            .marginTop(34)
            .width(231)
            .height(44)
            .hCenter()

        containerView.pin
            .wrapContent()
            .center()
        
    }
    
    private func loadUser() {
        userManager.loadUserFromID(ID: UserState.shared.userID){ [weak self] (result) in
            switch result{
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let user):
                self?.user = user
                self?.nameField.text = user[0].name
                self?.secondNameField.text = user[0].surname
                self?.genderField.text = user[0].gender
                self?.weightField.text = user[0].weight
                self?.heightField.text = user[0].height
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as? UITouch{
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        nameField.resignFirstResponder()
        secondNameField.resignFirstResponder()
        genderField.resignFirstResponder()
        weightField.resignFirstResponder()
        heightField.resignFirstResponder()
        return true
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
