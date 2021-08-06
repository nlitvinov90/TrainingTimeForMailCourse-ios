//
//  TrainingTime
//
//  Created by Ivan Bolshakov on 12.05.2021.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage


protocol AboutTrainingManagerDescription : AnyObject {
   
    func loadTrainingInfoFromID(ID: Int, completion: @escaping ( Result<AboutTraining, Error>) -> Void)
}

final class AboutTrainingManager : AboutTrainingManagerDescription{

    static let shared : AboutTrainingManagerDescription = AboutTrainingManager()
    
    private let database = Firestore.firestore()
    
    private init(){}

    func loadTrainingInfoFromID(ID: Int,completion: @escaping ( Result<AboutTraining, Error>) -> Void) {
        database.collection("Training").whereField("ID", isEqualTo: ID)
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
                let exercise = documents.compactMap{ AboutTrainingConvert.training(from: $0)}
                completion(.success(exercise[0]))
        }
    }
}


private final class AboutTrainingConvert{
    enum Key: String{
        case ID
        case name
        case description
        case exercises
        case difficulty
    }
    
    static func training(from document: DocumentSnapshot)->AboutTraining?{
        guard
            let dict = document.data(),
            let id = dict[Key.ID.rawValue] as? Int,
            let description = dict[Key.description.rawValue] as? String,
            let name = dict[Key.name.rawValue] as? String,
            let exsercise = dict[Key.exercises.rawValue] as? [Any],
            let difficulty = dict[Key.difficulty.rawValue] as? Int
        else  {
            return nil
        }
        var difficultySt = "difficulty1"
        switch difficulty {
        case 1:
            difficultySt = "difficulty1"
        case 2:
            difficultySt = "difficulty2"
        case 3:
            difficultySt = "difficulty3"
        default:
            difficultySt = "difficulty2"
        }
        return AboutTraining(id: id, name: name, description: description, exsercise: exsercise, difficulty: difficultySt)
    }
}


struct AboutTraining {
        let id: Int
        let name: String
        let description: String
        let exsercise: [Any]
        let difficulty: String
}
