//
//  ExerciseManager.swift
//  TrainingTime
//
//  Created by Ivan Bolshakov on 12.05.2021.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage


protocol ExerciseManagerDescription : AnyObject {
    func loadExercises(completion : @escaping ( Result<[Exercise], Error>) -> Void)
    func loadExerciseFromID(ID: Int, completion: @escaping ( Result<Exercise, Error>) -> Void)
    func downloadImage(url: String, completion: @escaping ( Result<UIImage, Error>) -> Void)
    func loadNameFromID(ID: Int,completion: @escaping ( Result<String, Error>) -> Void)
}

final class ExerciseManager : ExerciseManagerDescription{
    
    static let shared : ExerciseManagerDescription = ExerciseManager()
    
    private let database = Firestore.firestore()
    
    private init(){
    }
    
    func loadExercises(completion: @escaping ( Result<[Exercise], Error>) -> Void) {
        database.collection("Exercise").addSnapshotListener{ (querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
                return
            }
            guard let documents = querySnapshot?.documents else {
                completion(.failure(NetworkError.unexpected))
                return
            }
            let exercises = documents.compactMap{ ExerciseConverter.exercise(from: $0)}
            completion(.success(exercises))
        }
    }
    func loadExerciseFromID(ID: Int,completion: @escaping ( Result<Exercise, Error>) -> Void) {
        database.collection("Exercise").whereField("ID", isEqualTo: ID)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    completion(.failure(err))
                    print("Error getting documents: \(err)")
                    return
                }
                guard let documents = querySnapshot?.documents else {
                    completion(.failure(NetworkError.unexpected))
                    return
                }
                let exercise = documents.compactMap{ ExerciseConverter.exercise(from: $0)}
                completion(.success(exercise[0]))
        }
    }
    func downloadImage(url: String, completion: @escaping ( Result<UIImage, Error>) -> Void){
        //let ref = Storage.storage().reference(forURL: url)
        let ref = Storage.storage().reference().child(url)
        let megaByte = Int64(1*1024*1024)
        var image = UIImage(named: "handsMassFirst")
        ref.getData(maxSize: megaByte) { (data, error) in
            if let error = error {
                completion(.failure(error))
                print("Error getting documents: \(error)")
                return
            }
            guard let imageData = data else{return}
            image = UIImage(data: imageData)
            completion(.success(image!))
        }
        
    }
    func loadNameFromID(ID: Int,completion: @escaping ( Result<String, Error>) -> Void) {
        database.collection("Exercise").whereField("ID", isEqualTo: ID)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    completion(.failure(err))
                    print("Error getting documents: \(err)")
                    return
                }
                guard let documents = querySnapshot?.documents else {
                    completion(.failure(NetworkError.unexpected))
                    return
                }
                let name = documents.compactMap{ ExerciseConverter.name(from: $0)}
                completion(.success(name[0]))
        }
    }
}


private final class ExerciseConverter{
    enum Key: String{
        case ID
        case name
        case description
        case photoUrl
    }
    static func exercise(from document: DocumentSnapshot)->Exercise?{
        guard
            let dict = document.data(),
            let id = dict[Key.ID.rawValue] as? Int,
            let description = dict[Key.description.rawValue] as? String,
            let name = dict[Key.name.rawValue] as? String,
            let photoUrl = dict[Key.photoUrl.rawValue] as? String
        else  {
            return nil
        }
        
        return Exercise(id: id, name: name, description: description, photoUrl: photoUrl)
    }
    static func name(from document: DocumentSnapshot)->String?{
        guard
            let dict = document.data(),
            let name = dict[Key.name.rawValue] as? String
        else  {
            return nil
        }
        return name
    }
}

struct ExerciseInfo{
    var id: Int
    var repeats: String
    var nameEx: String
}

struct Exercise : Codable {
        let id: Int
        let name: String
        let description: String
        let photoUrl: String
}
