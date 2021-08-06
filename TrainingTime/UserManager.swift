//
//  UserManager.swift
//  TrainingTime
//
//  Created by Никита Литвинов on 18.05.2021.
//

import Foundation
import FirebaseFirestore

protocol UserManagerDescription : AnyObject {
    func loadUserFromID(ID: String, completion: @escaping ( Result<[User], Error>) -> Void)
    func AuthorizationInApp(emailValue: String, passwordValue: String)
    func RegistrationInApp(emailValue: String, passwordValue: String, repeatPasswordValue: String, nameValue: String, surnameValue: String)
    func addTrainingToFavourites(userId: String, trainingId: Int) -> Void
    func deleteTrainingFromFavourites(userId: String, trainingId: Int) -> Void
//    func isTrainingFavourite(userId: String, trainingId: Int, completion: @escaping (Result<Bool, Error>) -> Void)
    func getFavourites(userId: String, completion: @escaping (Result<[Int], Error>) -> Void)
}

final class UserManager : UserManagerDescription {
    
    static let shared : UserManagerDescription = UserManager()
    
    private let database = Firestore.firestore()
    
    private init(){}
    
    func AuthorizationInApp(emailValue: String, passwordValue: String) {
        
    }
    
    func RegistrationInApp(emailValue: String, passwordValue: String, repeatPasswordValue: String, nameValue: String, surnameValue: String) {
        
    }
    
    
    func loadUserFromID(ID: String, completion: @escaping (Result<[User], Error>) -> Void) {

        database.collection("User").document(ID).getDocument { (querySnapshot, err) in
                if let err = err {
                    completion(.failure(err))
                    print("Error getting documents: \(err)")
                    return
                }
            guard let documents = querySnapshot?.data() else {
                    completion(.failure(NetworkError.unexpected))
                    return
                }
              
            
            let name = documents["Name"]
            let surname = documents["Surname"]
            let gender = documents["Gender"]
            let weight = documents["Weight"]
            let height = documents["Height"]
            completion(.success([User(name: name as! String,
                                      surname: surname as! String,
                                         gender: gender as! String,
                                         weight: weight as! String,
                                         height: height as! String)]))
        }
   }
    
    func addTrainingToFavourites(userId: String, trainingId: Int) -> Void {
        database.collection("User").document(userId)
            .updateData([
                "Favourites": FieldValue.arrayUnion([trainingId])
            ])
    }
    
    func deleteTrainingFromFavourites(userId: String, trainingId: Int) -> Void {
        database.collection("User").document(userId)
            .updateData([
                "Favourites": FieldValue.arrayRemove([trainingId])
            ])
    }
    
    func getFavourites(userId: String, completion: @escaping (Result<[Int], Error>) -> Void) {
        database.collection("User").document(userId).getDocument {
            (querySnapshot, err) in
            if let err = err {
                completion(.failure(err))
                print("Error getting user: \(err)")
                return
            }
            guard let documents = querySnapshot?.data() else {
                completion(.failure(NetworkError.unexpected))
                return
            }
            let favourites = documents["Favourites"] as! Array<Int>
            completion(.success(favourites))
            return
        }
    }
    
//    func isTrainingFavourite(userId: String, trainingId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
//        database.collection("User").document(userId).getDocument { (querySnapshot, err) in
//                if let err = err {
//                    completion(.failure(err))
//                    print("Error getting user: \(err)")
//                    return
//                }
//            guard let documents = querySnapshot?.data() else {
//                    completion(.failure(NetworkError.unexpected))
//                    return
//                }
//            let favourites = documents["Favourites"] as! Array<Int>
//            print(favourites)
//            if favourites.contains(trainingId) {
//                print("Эта тренировка в избранном!")
//                completion(.success(true))
//                return
//            } else {
//                completion(.success(false))
//                print("Эта тренировка не в избранном!")
//                return
//            }
//        }
//    }
}

struct User: Codable{
    let name: String
    let surname: String
    let gender: String
    let weight: String
    let height: String
}
