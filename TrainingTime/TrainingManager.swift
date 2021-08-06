//
//  TrainingManager.swift
//  TrainingTime
//
//  Created by Никита Литвинов on 01.05.2021.
//
import Foundation
import FirebaseFirestore

enum NetworkError : Error{
    case unexpected
}

protocol TrainingManagerDescription : AnyObject {
    func loadTrainings(completion : @escaping ( Result<[Training], Error>) -> Void)
}

final class TrainingManager : TrainingManagerDescription{
    
    static let shared : TrainingManagerDescription = TrainingManager()
    
    private let database = Firestore.firestore()
    
    private init(){}
    
    func loadTrainings(completion: @escaping ( Result<[Training], Error>) -> Void) {
       
        database.collection("Training").addSnapshotListener{ (querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
                return
            }
            guard let documents = querySnapshot?.documents else {
                completion(.failure(NetworkError.unexpected))
                return
            }
            
            
            let trainings = documents.compactMap{ TrainingConverter.training(from: $0)}
            completion(.success(trainings))
        }
    }
}


private final class TrainingConverter{
    
    enum Key: String{
        case ID
        case name
        case description
        case difficulty
    }
    static func training(from document: DocumentSnapshot)->Training?{
        guard
            let dict = document.data(),
            let id = dict[Key.ID.rawValue] as? Int,
            let name = dict[Key.name.rawValue] as? String,
            let description = dict[Key.description.rawValue] as? String,
            let difficulty = dict[Key.difficulty.rawValue] as? Int
        else  {
            return nil
        }
        
        return Training(id: id, name: name, description: description, difficulty: difficulty, isFavourite: false)
    }
}


struct Training : Codable {
        let id: Int
        let name: String
        let description: String
        let difficulty: Int
        var isFavourite: Bool
}
