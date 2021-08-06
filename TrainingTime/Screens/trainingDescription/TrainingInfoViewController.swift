//
//  TrainingInfoViewController.swift
//  TrainingTime
//
//  Created by Ivan Bolshakov on 18.03.2021.
//

import UIKit
import PinLayout

protocol BaseCell {
    func heigth()->CGFloat
    func getName()->String
    func getId() -> Int
}

struct TitleCell: BaseCell {
    func getId() -> Int {
        return id
    }
    
    func getName() -> String {
        return name
    }
    
    func heigth() -> CGFloat {
        return 220
    }
    
    let id: Int
    let name: String
    let descripT: String
    let imageHard: String
}

struct ExerciseCell: BaseCell{
    func getName() -> String {
        return name
    }
    
    func heigth() -> CGFloat {
        return 120
    }
    
    func getId() -> Int {
        return id
    }
    
    let name: String
    let time: String
    let id: Int
}

func getStringSizeForFont(font: UIFont, myText: String) -> CGSize {
    let fontAttributes = [NSAttributedString.Key.font: font]
    let size = (myText as NSString).size(withAttributes: fontAttributes)
    return size
}

class TrainingInfoViewController: BaseViewController {
    
    var newExerciseID = 1
    var isFavourite = false
    private let userManager: UserManagerDescription = UserManager.shared
    
    init(exerciseID: Int, isFavourite: Bool){
        super.init(nibName: nil, bundle: nil)
        self.newExerciseID = exerciseID
        self.isFavourite = isFavourite
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private let tableView = UITableView()
    
    private var height: CGFloat?
    
    private var aboutTraining: AboutTraining?
    
    private var exerciseInfo: [ExerciseInfo]?
    
    private let exerciseManager: ExerciseManagerDescription = ExerciseManager.shared
    private let aboutTrainingManager: AboutTrainingManagerDescription = AboutTrainingManager.shared
    
    private var exercises: [BaseCell] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = backgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        loadTrain()
        tableView.register(ExercisesTableViewCell.self, forCellReuseIdentifier: "exercisesTableViewCell")
        tableView.register(HeaderTableViewCell.self, forCellReuseIdentifier: "HeaderTableViewCell")
        
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.pin.all()
    }
}
extension TrainingInfoViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let exerciseModel = exercises[indexPath.row] as? ExerciseCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "exercisesTableViewCell", for: indexPath) as? ExercisesTableViewCell else {
                return.init()
            }
            
            cell.configure(with: exerciseModel)
            return cell
        }
        if let titleModel = exercises[indexPath.row] as? TitleCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell", for: indexPath) as? HeaderTableViewCell else {
                return.init()
            }
            cell.delegate = self
            cell.configure(with: titleModel, isFavourite: isFavourite, id: newExerciseID)
            return cell
        }
        return .init()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if exercises[indexPath.row] is TitleCell {

            return height ?? 5
//            return UITableView.automaticDimension
        }
        else{
            return exercises[indexPath.row].heigth()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if exercises[indexPath.row] is ExerciseCell {
            let exer = exercises[indexPath.row]
            let newInfo = AboutTrainingViewController(with: exer.getId())
            newInfo.title = exer.getName()
            let navigationController = UINavigationController(rootViewController: newInfo)
            present(navigationController, animated: true, completion: nil)
       }
    }
    
    
    private func loadTrain() {
        aboutTrainingManager.loadTrainingInfoFromID(ID: newExerciseID) { [weak self] (result) in
                switch result {
                case .success(let info):
                    self?.aboutTraining = info
                    
                    let stringSizeAsText: CGSize = getStringSizeForFont(font: UIFont(name: "Avenir", size: 20)!, myText: info.name)
                    let stringSizeAsDesc: CGSize = getStringSizeForFont(font: UIFont(name: "Avenir", size: 17)!, myText: info.description)
                    let labelWidth: CGFloat = UIScreen.main.bounds.width * 0.85
                    let labelLines: CGFloat = CGFloat(ceil(Float(stringSizeAsText.width/labelWidth)))
                    let labelLinesDesc: CGFloat = CGFloat(ceil(Float(stringSizeAsDesc.width/labelWidth)))

                    self!.height = CGFloat(labelLines*stringSizeAsText.height) + CGFloat(labelLinesDesc*stringSizeAsDesc.height) + 30 + 50
                    self?.loadExercises(with: info)
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    enum KeyEx: String{
        case id
        case count
        case repeats
        case time
    }
    
    private func loadExercises(with info: AboutTraining) {
        
        for exserciseNum in info.exsercise {
            guard let exs = exserciseNum as? [String: Any],
            let idEx = exs[KeyEx.id.rawValue] as? Int,
            let count = exs[KeyEx.count.rawValue] as? Int,
            let repeats = exs[KeyEx.repeats.rawValue] as? Int,
            let time = exs[KeyEx.time.rawValue] as? String
            else {
                return
            }
            self.exerciseManager.loadNameFromID(ID: idEx) { (result) in
                switch result {
                case .success(let name):
                    if(time != ""){
                        self.exercises.append(ExerciseCell(name: name, time: "\(repeats) x \(time)", id: idEx))
                    }
                    else{
                        self.exercises.append(ExerciseCell(name: name, time: "\(repeats) x  \(count)", id: idEx))
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self.tableView.reloadData()
                }
        }
        self.exercises.append(TitleCell(id: info.id, name: info.name, descripT: info.description, imageHard: info.difficulty))
        self.tableView.reloadData()
    }
    
    private func addTrainingToFavourites(trainingId: Int) {
        userManager.addTrainingToFavourites(userId: UserState.shared.userID, trainingId: trainingId)
    }
    
    private func deleteTrainingFromFavourites(trainingId: Int) {
        userManager.deleteTrainingFromFavourites(userId: UserState.shared.userID, trainingId: trainingId)
    }
}

    extension TrainingInfoViewController {
        func didTapButton(trainingId: Int, toFavourites: Bool) {
            guard UserState.shared.isLoggedIn else {
                self.present(AuthMainViewController(), animated: true, completion: nil)
                return
            }
            if toFavourites {
                addTrainingToFavourites(trainingId: trainingId)
            } else {
                deleteTrainingFromFavourites(trainingId: trainingId)
            }
        }
    }
