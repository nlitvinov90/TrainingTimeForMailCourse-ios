import UIKit
import PinLayout

class AboutTrainingViewController: UIViewController {
    var newExerciseID = 1
        init(with exerciseID: Int){
            super.init(nibName: nil, bundle: nil)
            newExerciseID = exerciseID
        }
        required init?(coder aDecoder: NSCoder) {
                super.init(coder: aDecoder)
        }

    
    private var myScrollView = UIScrollView()
    private var exerciseImageView = UIImageView()
    private let exerciseDescription = UILabel()
    
    private var exercise: Exercise?
    private let exerciseManager: ExerciseManagerDescription = ExerciseManager.shared
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.071, green: 0.078, blue: 0.086, alpha: 1)
        let textAttributes = [NSAttributedString.Key.foregroundColor:contentColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        view.backgroundColor = backgroundColor
        myScrollView.frame = self.view.bounds
        exerciseDescription.numberOfLines = 0
        exerciseDescription.textAlignment = .left
        exerciseDescription.textColor = textColor
        exerciseImageView.layer.cornerRadius = 30
        exerciseImageView.clipsToBounds = true
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        loadExercises()
        myScrollView.addSubview(exerciseImageView)
        myScrollView.addSubview(exerciseDescription)
        self.view.addSubview(myScrollView)
        
        myScrollView.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        exerciseImageView.pin
            .top(view.safeAreaInsets.top + 35)
            .hCenter()
            .width(85%)
            .aspectRatio()
        
        exerciseDescription.pin
            .below(of: exerciseImageView)
            .marginTop(15)
            .hCenter()
            .width(85%)
            .sizeToFit(.width)
        
        activityIndicator.pin
            .center()

            var contentRect = CGRect.zero
            for view in self.myScrollView.subviews {
               contentRect = contentRect.union(view.frame)
            }
            self.myScrollView.contentSize = contentRect.size
            self.myScrollView.contentSize.height = self.myScrollView.contentSize.height + 30
    }
    
    private func loadExercises() {
        exerciseManager.loadExerciseFromID(ID: newExerciseID) { [weak self] (result) in
                switch result {
                case .success(let exercises):
                    self?.exercise = exercises
                    self?.exerciseDescription.text = self?.exercise?.description
                    self?.exerciseManager.downloadImage(url: (self?.exercise?.photoUrl) ?? "exercises/exercise14.jpeg") { [weak self] (result) in
                            switch result {
                            case .success(let image):
                                self?.exerciseImageView.image  = image
                                self?.view.setNeedsLayout()
                                
                                self?.myScrollView.isHidden = false
                                self?.activityIndicator.isHidden = true
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
}
