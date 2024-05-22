import Foundation
import UIKit
import SnapKit

class AllowNotificationsViewController: UIViewController {

    
    weak var appDelegate: AppDelegate?
    var timer: Timer?

    
    lazy var allowButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "allowButton"), for: .normal)
        return button
    }()
    
    lazy var boldLabel: UILabel = {
        let label = UILabel()
        label.text = "ALLOW NOTIFICATIONS ABOUT BONUSES AND PROMOS"
        label.textAlignment = .center
        let attributedString = NSMutableAttributedString(string: "ALLOW NOTIFICATIONS ABOUT BONUSES AND PROMOS")
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 8
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        label.attributedText = attributedString
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var backgorundImageView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "menuBackground")
        image.sizeToFit()
        return image
    }()
    
    lazy var regularLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        let attributedString = NSMutableAttributedString(string: "Stay tuned with all actual information about game!")
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 2
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        label.attributedText = attributedString
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .lightGray
        return label
    }()
    lazy var skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Skip", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    lazy var logoImageView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "logo")
        image.sizeToFit()
        return image
    }()
    
    init(appDelegate: AppDelegate) {
        print("ALLOW 1")
        self.appDelegate = appDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgorundImageView)
        view.addSubview(allowButton)
        view.addSubview(logoImageView)
        view.addSubview(boldLabel)
        view.addSubview(regularLabel)
        view.addSubview(skipButton)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "menuBackground")!)
        allowButton.layoutSubviews()
        allowButton.addTarget(self, action: #selector(moveToGame), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipAction), for: .touchUpInside)

        setupConstraints()
    }
    
    @objc
    func skipAction() {
        appDelegate?.showGame()
    }
    
    @objc
    func moveToGame() {
        appDelegate?.firebaseNotificationAccess()
    }
    
    func setupConstraints() {
        backgorundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(view.snp.width).multipliedBy(0.8)
            make.height.equalTo(view.snp.width).multipliedBy(0.8)
            make.top.equalToSuperview().offset(110)
        }
        boldLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(90)
            make.top.equalTo(logoImageView.snp.bottom).offset(40)
        }
        
        regularLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(boldLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().inset(30)
            make.height.equalTo(60)
        }
        

        skipButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
        allowButton.snp.makeConstraints { make in
            make.bottom.equalTo(skipButton.snp.top).offset(-20)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
    }
}
