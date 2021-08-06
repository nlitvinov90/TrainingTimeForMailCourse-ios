//
// RegistrationViewController.swift
// TrainingTime
//
// Created by Никита Литвинов on 01.05.2021.
//

import Foundation
import UIKit
import PinLayout
import Firebase
import FirebaseAuth

class RegistrationViewController : UIViewController, UITextFieldDelegate{
    
    private let containerView = UIView()
    private var welcomeLable = UILabel()
    private var regButton = UIButton()
    private var regNameField = UITextField()
    private var regSecondNameField = UITextField()
    private var emailField = UITextField()
    private var passwordField = UITextField()
    private var repeatPasswordField = UITextField()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.071, green: 0.078, blue: 0.086, alpha: 1)

        regButton.backgroundColor = UIColor(red: 0.169, green: 0.18, blue: 0.2, alpha: 1)
        regButton.layer.cornerRadius = 8
        regButton.layer.masksToBounds = true
        regButton.setTitle("Зарегистрироваться", for: .normal)
        regButton.setTitleColor(UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1), for:  UIControl.State.highlighted)
        regButton.addTarget(self, action: #selector(didTapRegister), for:
        .touchUpInside)
        

        welcomeLable.backgroundColor = UIColor(red: 0.071, green: 0.078, blue: 0.086, alpha: 1)
        welcomeLable.text = "Регистрация"
        welcomeLable.textColor = UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1)
        welcomeLable.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        
        regNameField.layer.cornerRadius = 8
        regNameField.layer.masksToBounds = true
        regNameField.textColor = UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1)
        regNameField.backgroundColor = UIColor(red: 0.169, green: 0.18, blue: 0.2, alpha: 1)
        regNameField.attributedPlaceholder = NSAttributedString(string: " Введите имя",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1)])
        regNameField.delegate = self
        
        regSecondNameField.layer.cornerRadius = 8
        regSecondNameField.layer.masksToBounds = true
        regSecondNameField.textColor = UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1)
        regSecondNameField.backgroundColor = UIColor(red: 0.169, green: 0.18, blue: 0.2, alpha: 1)
        regSecondNameField.attributedPlaceholder = NSAttributedString(string: " Введите фамилию",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1)])
        regSecondNameField.delegate = self

        emailField.layer.cornerRadius = 8
        emailField.layer.masksToBounds = true
        emailField.textColor = UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1)
        emailField.backgroundColor = UIColor(red: 0.169, green: 0.18, blue: 0.2, alpha: 1)
        emailField.attributedPlaceholder = NSAttributedString(string: " Введите почту",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1)])
        emailField.delegate = self

        passwordField.layer.cornerRadius = 8
        passwordField.layer.masksToBounds = true
        passwordField.textColor = UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1)
        passwordField.backgroundColor = UIColor(red: 0.169, green: 0.18, blue: 0.2, alpha: 1)
        passwordField.attributedPlaceholder = NSAttributedString(string: " Введите пароль",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1)])
        passwordField.isSecureTextEntry = true
        passwordField.delegate = self

        repeatPasswordField.layer.cornerRadius = 8
        repeatPasswordField.layer.masksToBounds = true
        repeatPasswordField.textColor = UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1)
        repeatPasswordField.backgroundColor = UIColor(red: 0.169, green: 0.18, blue: 0.2, alpha: 1)
        repeatPasswordField.attributedPlaceholder = NSAttributedString(string: " Повторите пароль",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1)])
        repeatPasswordField.isSecureTextEntry = true
        repeatPasswordField.delegate = self
        
        
        containerView.addSubview(regNameField)
        containerView.addSubview(regSecondNameField)
        containerView.addSubview(welcomeLable)
        containerView.addSubview(emailField)
        containerView.addSubview(passwordField)
        containerView.addSubview(regButton)
        containerView.addSubview(repeatPasswordField)
        
        view.addSubview(containerView)
}

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc
    func didTapRegister(){
        let nameValue = regNameField.text!
        let surnameValue = regSecondNameField.text!
        let emailValue = emailField.text!
        let passwordValue = passwordField.text!
        let repeatPasswordValue = repeatPasswordField.text!
        
        if (!emailValue.isEmpty && !passwordValue.isEmpty && !nameValue.isEmpty && !surnameValue.isEmpty) {
            if (passwordValue == repeatPasswordValue) {
                if (ParsePassword(value: passwordValue)){
                    if (passwordValue.count > 5){
                        Auth.auth().createUser(withEmail: emailValue, password: passwordValue) { (result, error) in
                            if error == nil {
                                if let result = result {
                                    print(result.user.uid)
                                    let db = Firestore.firestore()
                                    db.collection("User").document(result.user.uid).setData(["Email": emailValue, "Surname": surnameValue, "Name": nameValue, "Gender": "", "Height": "", "Weight": "", "Favourites" : []]) {
                                        err in if let err = err {
                                            print("Error writing doc \(err)")
                                        } else {
                                            print("added to db")
                                        }
                                    }
                                    self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                                }
                            } else {
                                self.showAlert(message: "Некорректная почта, попробуйте другую")
                            }
                        }
                    } else {
                        showAlert(message: "Пароль должен содержать не менее 6 символов")
                    }
                } else {
                    showAlert(message: "Пароль должен содержать цифры или буквы английского языка")
                }
            } else {
                showAlert(message: "Пароли не совпадают!")
            }
        } else {
            showAlert(message: "Заполните все поля!")
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        welcomeLable.pin
            .top()
            .sizeToFit()
            .hCenter()
        
        
        regNameField.pin
            .below(of: welcomeLable)
            .marginTop(72)
            .width(231)
            .height(44)
            .hCenter()
        
        regSecondNameField.pin
            .below(of: regNameField)
            .marginTop(28)
            .width(231)
            .height(44)
            .hCenter()

        emailField.pin
            .below(of: regSecondNameField)
            .marginTop(28)
            .width(231)
            .height(44)
            .hCenter()

        passwordField.pin
            .below(of: emailField)
            .marginTop(28)
            .width(231)
            .height(44)
            .hCenter()

        repeatPasswordField.pin
            .below(of: passwordField)
            .marginTop(28)
            .width(231)
            .height(44)
            .hCenter()

        regButton.pin
            .below(of: repeatPasswordField)
            .marginTop(37)
            .width(191)
            .height(56)
            .hCenter()
    
        

        containerView.pin
            .wrapContent()
            .center()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as? UITouch{
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        regNameField.resignFirstResponder()
        regSecondNameField.resignFirstResponder()
        repeatPasswordField.resignFirstResponder()
        return true
    }
    
    
    private func ParsePassword(value: String) -> Bool{
        let ch = [Character](value)
        for i in 0...value.count-1{
            if (ch[i] < "a" || ch[i] > "z") && (ch[i] < "0" || ch[i] > "9")
                    && (ch[i] < "A" || ch[i] > "Z"){
                return false
            }
        }
        return true
    }
//
//    private func ParseEmail(value: String)-> Bool{
//        var ch = [Character](value)
//        var firstIndexToRemove  = 0
//        var secondIndexToRemove = 0
//        if (value.contains("@") && value.contains(".")){
//            for i in 0...ch.count-1{
//                if ch[i] == "@"{
//                    firstIndexToRemove = i
//                }
//                if ch[i] == "."{
//                    secondIndexToRemove = i
//                }
//            }
//            ch.remove(at: firstIndexToRemove)
//            ch.remove(at: secondIndexToRemove-1)
//            for i in 0...ch.count-1{
//                if (ch[i] < "a" || ch[i] > "z") && (ch[i] < "0" || ch[i] > "9")
//                        && (ch[i] < "A" || ch[i] > "Z"){
//                    return false
//                }
//            }
//        } else {
//            return false
//        }
//        return true
//    }
}
