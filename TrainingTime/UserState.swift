//
//  UserState.swift
//  TrainingTime
//
//  Created by Дмитрий Бокарев on 31.05.2021.
//

import Foundation

class UserState {
    public var isLoggedIn: Bool = false
    public var userID: String = ""
    static var shared = UserState()
    private init() {
        
    }
    
}
