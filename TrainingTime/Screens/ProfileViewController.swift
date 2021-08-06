//
//  LayoutForProfile.swift
//  TrainingTime
//
//  Created by Ivan Bolshakov on 11.03.2021.
//


import UIKit
import Firebase
import PinLayout
import FirebaseAuth

class ProfileViewController: UIViewController {

    private let containerView = UIView()
    private var nameLabel = UILabel()
    private let profileButton = UIButton()
    private let signOutButton = UIButton()
    private let signInButton = UIButton()
    private let userManager: UserManagerDescription = UserManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.071, green: 0.078, blue: 0.086, alpha: 1)
        nameLabel.backgroundColor = UIColor(red: 0.071, green: 0.078, blue: 0.086, alpha: 1)
        nameLabel.text = ""
        nameLabel.textColor = UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1)
        nameLabel.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        
        profileButton.backgroundColor = UIColor(red: 0.169, green: 0.18, blue: 0.2, alpha: 1)
        profileButton.layer.cornerRadius = 8
        profileButton.layer.masksToBounds = true
        profileButton.setTitle("Мои данные", for: .normal)
        profileButton.setTitleColor(UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1), for:  UIControl.State.highlighted)
        profileButton.addTarget(self, action: #selector(didTapDataButton), for:
        .touchUpInside)
        
        signOutButton.backgroundColor = UIColor(red: 0.169, green: 0.18, blue: 0.2, alpha: 1)
        signOutButton.layer.cornerRadius = 8
        signOutButton.layer.masksToBounds = true
        signOutButton.setTitle("Выйти", for: .normal)
        signOutButton.setTitleColor(UIColor(red: 0.789, green: 0.501, blue: 0.925, alpha: 1), for:  UIControl.State.highlighted)
        signOutButton.addTarget(self, action: #selector(didTapSignOutButton), for:
        .touchUpInside)
        
        [nameLabel, profileButton, signOutButton].forEach{containerView.addSubview($0)}
        view.addSubview(containerView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadUser()
    }
    
    @objc
    private func didTapSignInButton() {
    let nextView = AuthMainViewController(nibName: nil, bundle: nil)
    present(nextView, animated: true, completion: nil)
    }
    
    @objc
    private func didTapDataButton() {
        let nextView = UserDataViewController(nibName: nil, bundle: nil)
        nextView.output = self
        present(nextView, animated: true, completion: nil)
    }
    
    @objc
    private func didTapSignOutButton() {
        do{
            try Auth.auth().signOut()
        }catch{
            print(error)
        }
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        nameLabel.pin
            .top()
            .height(30)
            .sizeToFit(.height)
            .hCenter()
        
        profileButton.pin.below(of: nameLabel, aligned: .center)
            .marginTop(70)
            .height(54)
            .width(161)
        signOutButton.pin.below(of: profileButton, aligned: .center).marginTop(210)
            .height(54)
            .width(161)
        
        containerView.pin.wrapContent().center()
        nameLabel.pin.hCenter()
        
    }
    
    private func loadUser() {
        userManager.loadUserFromID(ID: UserState.shared.userID){ [weak self] (result) in
            switch result{
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let user):
                self?.nameLabel.text = user[0].name
                self?.view.setNeedsLayout()
            }
        }
    }
}

extension ProfileViewController: UserDataOutput {
    func didClose(name: String) {
        self.nameLabel.text = name
        self.view.setNeedsLayout()
    }
}
