import Foundation
import UIKit

class CustomErrorView: UIView {
        
    lazy var mainErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.text = "No Internet Connection"
        label.font = UIFont(name: "AbhayaLibre-ExtraBold", size: 44)
        return label
    }()
    
    lazy var subtleErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.text = "Please check internet connection and try again"
        label.font = UIFont(name: "AbhayaLibre-ExtraBold", size: 30)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        clipsToBounds = true
        addSubview(mainErrorLabel)
        addSubview(subtleErrorLabel)
     }
    
    func setupConstraints() {
        mainErrorLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
            make.centerY.equalToSuperview().offset(-50)
        }
        
        subtleErrorLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
            make.top.equalTo(mainErrorLabel.snp.bottom)
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
