import Foundation
import UIKit
import SnapKit

class PointsView: UIView {
    var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.text = "Points: 12"
        label.font = UIFont(name: "AbhayaLibre-ExtraBold", size: 24)

        return label
    }()
    
    var backgroundImageView: UIImageView = {
        let image = UIImageView()
         image.image = UIImage(named: "pointsButton")
         image.sizeToFit()
         return image

    }()
    
    var pointsCount: UILabel = {
        let label = UILabel()
        label.textColor = .yellow
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "AbhayaLibre-ExtraBold", size: 18)
        label.text = "12"
        
        return label
    }()
    
    var containerView = UIView()
    
    init() {
        super.init(frame: .zero)
        clipsToBounds = true
        addSubview(backgroundImageView)
        containerView.backgroundColor = .clear
        addSubview(textLabel)
     }
    
    func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        textLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        updateLabel(value: 0)
    }
    
    func updateLabel(value: Int) {
        print("UPDATE")
        let attributedText = NSMutableAttributedString(string: "Points: \(value)")
        
        attributedText.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: attributedText.length))
        
        let digitPattern = "\\b\\d+\\b"
        if let regex = try? NSRegularExpression(pattern: digitPattern, options: []) {
            let matches = regex.matches(in: attributedText.string, options: [], range: NSRange(location: 0, length: attributedText.length))
            for match in matches {
                attributedText.addAttribute(.foregroundColor, value: UIColor.yellow, range: match.range)
            }
        }

        textLabel.attributedText = attributedText
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setNotClickable() {
    }
    
    func setClickable() {
    }
}


class MapView: UIView {
    
    var isUnlocked = true
    
    lazy var priceTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.text = "Points: 12"
        label.font = UIFont(name: "AbhayaLibre-ExtraBold", size: 20)
        return label
    }()
    
    lazy var mapImageView: UIImageView = {
        let image = UIImageView()
         image.image = UIImage(named: "selectedLevel1")
         image.sizeToFit()
        image.clipsToBounds = true
         return image
    }()
    
    lazy var mapContainer = UIView()
    
    lazy var statusImageView: UIImageView = {
        let image = UIImageView()
         image.image = UIImage(named: "available")
         image.sizeToFit()
         return image
    }()
    
    lazy var statusContainerView = UIView()
    
    lazy var pointsCount: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "AbhayaLibre-ExtraBold", size: 12)
        label.textAlignment = .center
        label.text = "500"
        return label
    }()
    
    lazy var containerView = UIView()
    
    init() {
        super.init(frame: .zero)
        isUserInteractionEnabled = true
        clipsToBounds = true
        addSubview(mapContainer)
        mapContainer.addSubview(mapImageView)
        addSubview(statusContainerView)
        containerView.backgroundColor = .clear
        mapContainer.layer.cornerRadius = mapImageView.frame.height / 2
        mapContainer.layer.borderWidth = 10
        mapContainer.layer.borderColor = UIColor.white.cgColor
     }
    
    func setupConstraints() {
        mapContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mapImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        statusContainerView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        statusContainerView.layer.cornerRadius = 25
        statusContainerView.backgroundColor = .white
    }
    
    
    func roundImage() {
        mapContainer.layer.cornerRadius = mapImageView.frame.height / 2
        mapContainer.layer.borderWidth = 10
        mapContainer.layer.borderColor = UIColor.white.cgColor
        statusContainerView.layer.masksToBounds = true
        statusContainerView.layer.cornerRadius = statusContainerView.frame.height / 2
    }
    
    func setAvailableLevel() {
        statusContainerView.removeFromSuperview()
        statusContainerView = UIView()
        addSubview(statusContainerView)
        statusContainerView.addSubview(statusImageView)
        statusImageView.image = UIImage(named: "available")
        statusContainerView.layer.cornerRadius = 25
        statusContainerView.backgroundColor = .white
        statusContainerView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        statusImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
    }
    
    func setUnavailableLevel(price: Int) {
        statusContainerView.removeFromSuperview()
        statusContainerView = UIView()
        addSubview(statusContainerView)
        statusContainerView.addSubview(statusImageView)
        statusContainerView.addSubview(pointsCount)
        statusImageView.image = UIImage(named: "gem")
        statusContainerView.layer.cornerRadius = 25
        statusContainerView.backgroundColor = .white
        statusContainerView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        pointsCount.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(15)
        }
        pointsCount.text = "\(price)"
        
        statusImageView.snp.makeConstraints { make in
            make.top.equalTo(pointsCount.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setNotClickable() {
    }
    
    func setClickable() {
    }
}

class CountView: UIView {
        
    lazy var priceTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.text = "0"
        label.font = UIFont(name: "AbhayaLibre-ExtraBold", size: 24)
        return label
    }()
    
    lazy var countImageView: UIImageView = {
        let image = UIImageView()
         image.image = UIImage(named: "countBackground")
         image.sizeToFit()
        image.clipsToBounds = true
         return image
    }()
    
    lazy var countContainer = UIView()
    
    lazy var gemImageView: UIImageView = {
        let image = UIImageView()
         image.image = UIImage(named: "gem")
         image.sizeToFit()
         return image
    }()
    
    init() {
        super.init(frame: .zero)
        clipsToBounds = true
        addSubview(countContainer)
        countContainer.addSubview(priceTextLabel)
        countContainer.addSubview(countImageView)
        countContainer.bringSubviewToFront(priceTextLabel)
        countContainer.addSubview(gemImageView)
        
     }
    
    func setupConstraints() {
        countContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        countImageView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-30)
        }
        
        priceTextLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalTo(countImageView.snp.centerX)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        gemImageView.snp.makeConstraints { make in
            make.leading.equalTo(countImageView.snp.trailing).offset(-20)
            make.centerY.equalToSuperview()
            make.height.equalTo(45)
            make.width.equalTo(45)
        }
        
        countContainer.layer.cornerRadius = 12
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setNotClickable() {
    }
    
    func setClickable() {
    }
}


class RecordBreakingView: UIView {
    
    
    lazy var nameTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.text = "Enter name:"
        label.font = UIFont(name: "AbhayaLibre-ExtraBold", size: 18)
        return label
    }()
    
    lazy var backgroundImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "recordBackground")
        image.sizeToFit()
        image.clipsToBounds = true
        return image
    }()
    
    lazy var customTextField: CustomTextField = {
        let textField = CustomTextField(placeHolder: " ")
        textField.backgroundColor = Colors.transparentWhite
        textField.layer.cornerRadius = 8
        textField.textColor = .black
        return textField
    }()
    
    lazy var delimetrLine: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        clipsToBounds = true
        addSubview(backgroundImageView)
        addSubview(nameTextLabel)
        addSubview(customTextField)
        addSubview(delimetrLine)
    }
    
    func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nameTextLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        customTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(55)
            make.top.equalTo(nameTextLabel.snp.bottom).offset(10)
        }
        
        delimetrLine.snp.makeConstraints { make in
            make.bottom.equalTo(customTextField.snp.bottom).offset(-15)
            make.leading.equalTo(customTextField.snp.leading).offset(10)
            make.trailing.equalTo(customTextField.snp.trailing).offset(-10)
            make.height.equalTo(0.8)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    

}
