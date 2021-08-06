//
//  MyTrainingsViewController.swift
//  TrainingTime
//
//  Created by Ivan Bolshakov on 18.03.2021.
//

import UIKit
import PinLayout

class MyTrainingsViewController: BaseViewController {
    
    private let tableView = UITableView()
    var trainings: [Training] = []
    var favourites: [Int] = []
    var favouriteTrainings: [Training] = []
    private let trainingManager: TrainingManagerDescription = TrainingManager.shared
    private let userManager: UserManagerDescription = UserManager.shared
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()
    
    
    override func updateAfterAuthStateChanged() {
        super.updateAfterAuthStateChanged()
        loadAll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
 //       navigationController?.navigationBar.barTintColor = UIColor(red: 0.071, green: 0.078, blue: 0.086, alpha: 1)
        tableView.backgroundColor = backgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyTrainingTableViewCell.self, forCellReuseIdentifier: "MyTrainingTableViewCell")
        
        tableView.refreshControl = refreshControl
        
        view.addSubview(tableView)
        refreshControl.addTarget(self, action: #selector(refreshTrainingsData(_:)), for: .valueChanged)
        refreshControl.tintColor = .white
        //loadAll()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.pin
            .top(view.pin.safeArea)
            .horizontally()
            .bottom()
        
        activityIndicator.pin
            .center()
    }
    
    private func loadAll() {
        let group = DispatchGroup.init()
        group.enter()
        
        trainingManager.loadTrainings { [weak self] (result) in
            switch result {
            case .success(let trainings):
                self?.trainings = trainings
            case .failure(let error):
                print(error.localizedDescription)
            }
            group.leave()
        }
        
        if UserState.shared.isLoggedIn {
            group.enter()
            userManager.getFavourites(userId: UserState.shared.userID) { [weak self] (result) in
                switch result {
                case .success(let favourites):
                    self?.favourites = favourites
                case .failure(let error):
                    print(error.localizedDescription)
                }
                group.leave()
            }
        } else {
            self.favourites = []
        }
        
        
        group.notify(queue: .main, execute: {
            self.onlyFavouritesAndReload()
        })
        
        self.refreshControl.endRefreshing()
        self.activityIndicator.stopAnimating()
    }
    
    private func loadTrainings() {
        trainingManager.loadTrainings { [weak self] (result) in
            switch result {
            case .success(let trainings):
                self?.trainings = trainings
                self?.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getFavourites() {
        userManager.getFavourites(userId: UserState.shared.userID) {
            [weak self] (result) in switch result {
            case .success(let favourites):
                self?.favourites = favourites
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setFavouritesAndReload() {
        for i in 0..<(self.trainings.count) {
            if favourites.contains(self.trainings[i].id) {
                self.trainings[i].isFavourite = true
            } else {
                self.trainings[i].isFavourite = false
            }
        }
        self.tableView.reloadData()
    }
    
    private func onlyFavouritesAndReload() {
        favouriteTrainings = []
        for i in 0..<(self.trainings.count) {
            if favourites.contains(self.trainings[i].id) {
                self.trainings[i].isFavourite = true
                favouriteTrainings.append(self.trainings[i])
            } else {
                self.trainings[i].isFavourite = false
            }
        }
        self.tableView.reloadData()
    }
        
    private func addTrainingToFavourites(trainingId: Int) {
        userManager.addTrainingToFavourites(userId: UserState.shared.userID, trainingId: trainingId)
    }
    
    private func deleteTrainingFromFavourites(trainingId: Int) {
        userManager.deleteTrainingFromFavourites(userId: UserState.shared.userID, trainingId: trainingId)
    }
    
    @objc private func refreshTrainingsData(_ sender: Any) {
        loadAll()
    }
}
    
extension MyTrainingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        favouriteTrainings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyTrainingTableViewCell", for: indexPath) as? MyTrainingTableViewCell else {
            return .init()
        }
        
        cell.configure(with: favouriteTrainings[indexPath.section])
        cell.backgroundColor = itemColor
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.clear
            return headerView
        }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 20
       }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let exer = favouriteTrainings[indexPath.section]
        navigationController?.pushViewController(TrainingInfoViewController(exerciseID : exer.id, isFavourite: exer.isFavourite), animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MyTrainingsViewController: MyTrainingTableViewCellDelegate {
    func didTapButton(trainingId: Int, toFavourites: Bool) {
        guard UserState.shared.isLoggedIn else {
            self.present(AuthMainViewController(), animated: true, completion: nil)
            return
        }
        if toFavourites {
            addTrainingToFavourites(trainingId: trainingId)
            if !favourites.contains(trainingId) {
                favourites.append(trainingId)
            }
        } else {
            deleteTrainingFromFavourites(trainingId: trainingId)
            if let index = favourites.firstIndex(of: trainingId) {
                favourites.remove(at: index)
            }
        }
        
        print("НАЖАТА КНОПКА НА id = \(trainingId) \(toFavourites)")
        onlyFavouritesAndReload()
    }
}
