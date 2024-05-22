import Foundation
import UIKit

class TopViewController: UIViewController {
    
    lazy var topImageView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "topImage")
        image.sizeToFit()
        return image
    }()
    
    lazy var topUsersView = PointsView()
    
    lazy var recordsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    lazy var backgroundImageView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "menuBackground")
        image.sizeToFit()
        return image
    }()
    
    lazy var playNowButton = PlayNowButton(title: "PLAY NOW")
    
    var records: [RecordObject] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("123")
        recordsCollectionView.register(TopCollectionViewCell.self, forCellWithReuseIdentifier: "TopCollectionViewCell")
        recordsCollectionView.delegate = self
        recordsCollectionView.dataSource = self
        view.addSubview(backgroundImageView)
        view.addSubview(recordsCollectionView)
        view.addSubview(topUsersView)
        view.addSubview(topImageView)
        topUsersView.setupConstraints()
        view.bringSubviewToFront(recordsCollectionView)
        topUsersView.textLabel.text = "TOP USERS"
        recordsCollectionView.backgroundColor = .clear
        recordsCollectionView.reloadData()
        setupConstraints()
    }
    
    func fetchLocalData() {
        var record = UserDefaultSettings.records
        records = []
        var newRecords: [RecordObject] = record.sorted { $0.score > $1.score }
        for newRecord in newRecords {
            if record.count < 12 {
                records.append(newRecord)
            }
        }
        while records.count < 12 {
            records.append(RecordObject(name: "No Name", score: 0))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLocalData()
    }
    
    
    func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        topImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalToSuperview().multipliedBy(0.4)
        }

        topUsersView.snp.makeConstraints { make in
            make.top.equalTo(topImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        recordsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(topUsersView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
    }
}


extension TopViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
        return CGSize(width: (self.view.frame.width * 0.78), height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return records.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCollectionViewCell.identifier, for: indexPath) as! TopCollectionViewCell
        cell.setup(title: records[indexPath.row].name, score: records[indexPath.row].score, index: indexPath.row)
            return cell
    }
}
