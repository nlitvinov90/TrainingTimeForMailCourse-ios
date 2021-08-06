//
// AuthMainViewController.swift
// TrainingTime
//
// Created by Никита Литвинов on 01.05.2021.
//

import Foundation
import UIKit
import PinLayout
import Firebase
import FirebaseAuth

class AuthMainViewController : UIViewController, UITextFieldDelegate {
    
    private let containerView = UIView()
    private let welcomeLable = UILabel()
    private let inputButton = UIButton()
    private var emailField = UITextField()
    private let passwordField = UITextField()
    private let regButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.071, green: 0.078, blue: 0.086, alpha: 1)

        inputButton.backgroundColor = UIColor(red: 0.169, green: 0.18, blue: 0.2, alpha: 1)
        inputButton.layer.cornerRadius = 8
        inputButton.layer.masksToBounds = true
        inputButton.setTitle("Войти", for: .normal)
        inputButton.setTitleColor(UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1), for:  UIControl.State.highlighted)
        inputButton.addTarget(self, action: #selector(didTapAuth), for:
        .touchUpInside)
        
        welcomeLable.backgroundColor = UIColor(red: 0.071, green: 0.078, blue: 0.086, alpha: 1)
        welcomeLable.text = "Необходимо авторизоваться!"
        welcomeLable.textColor = UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1)
        welcomeLable.font = UIFont.systemFont(ofSize: 25, weight: .regular)

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

        regButton.setTitle("Регистрация", for: .normal)
        regButton.layer.cornerRadius = 8
        regButton.layer.masksToBounds = true
        regButton.backgroundColor = UIColor(red: 0.071, green: 0.078, blue: 0.086, alpha: 1)
        regButton.setTitleColor(UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1), for:  UIControl.State.highlighted)
        regButton.addTarget(self, action: #selector(didTapRegButton), for:
        .touchUpInside)

        containerView.addSubview(inputButton)
        containerView.addSubview(welcomeLable)
        containerView.addSubview(emailField)
        containerView.addSubview(passwordField)
        containerView.addSubview(regButton)
        
        view.addSubview(containerView)
    }



    @objc
    private func didTapRegButton() {
        let nextView = RegistrationViewController(nibName: nil, bundle: nil)
        present(nextView, animated: true, completion: nil)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc
    func didTapAuth(){
        let emailValue = emailField.text!
        let passwordValue = passwordField.text!
        if (!emailValue.isEmpty && !passwordValue.isEmpty) {
            Auth.auth().signIn(withEmail: emailValue, password: passwordValue) { (result, error) in
                    if error == nil {
                        self.dismiss(animated: true, completion: nil)
                        print("authed into \(emailValue)")
                    } else {
                        self.showAlert(message: "Неправильный логин или пароль")
                    }
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
        
        emailField.pin
            .below(of: welcomeLable)
            .marginTop(107)
            .width(231)
            .height(44)
            .hCenter()
        
        passwordField.pin
            .below(of: emailField)
            .marginTop(34)
            .width(231)
            .height(44)
            .hCenter()
        
        inputButton.pin
            .below(of: passwordField)
            .marginTop(119)
            .width(191)
            .height(56)
            .hCenter()
        
        regButton.pin
            .below(of: inputButton)
            .marginTop(18)
            .sizeToFit()
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
        return true
    }
}


