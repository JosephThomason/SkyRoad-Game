import Foundation
import UIKit

class TopCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TopCollectionViewCell"
    
    
    lazy var backgroundImageView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "topBackground")
        image.sizeToFit()
        return image
    }()
    
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "No Name"
        label.textColor = .black
        label.font = UIFont(name: "AbhayaLibre-ExtraBold", size: 15)
        return label
    }()
    
    func setup(title: String, score: Int, index: Int) {
        addSubview(backgroundImageView)
        addSubview(titleLabel)
        titleLabel.text = "\(index + 1). \(title) - \(score)"
        setupConstraints()
    }
    
    
    func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
}
