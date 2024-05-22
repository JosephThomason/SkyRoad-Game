import UIKit
import SnapKit

class LoadingViewController: UIViewController {

    
    let imageView = UIImageView()
    var timer: Timer?
    weak var appDelegate: AppDelegate?
    
    lazy var loadingImageView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "loadingImage")
        image.sizeToFit()
        return image
    }()
    
    lazy var backgorundImageView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "menuBackground")
        image.sizeToFit()
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        view.addSubview(backgorundImageView)
        view.addSubview(imageView)
        view.addSubview(loadingImageView)
        setupConstraints()
        rotateImageView()
        startTimer()
    }
    
    init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func rotateImageView() {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveLinear, animations: {
            self.imageView.transform = self.imageView.transform.rotated(by: CGFloat.pi)
        }) { (_) in
            self.rotateImageView()
        }
    }
    
    func startTimer() {
         timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: false)
     }

     @objc func timerFired() {
         appDelegate?.endedLoading()
     }
    
    func setupConstraints() {
        backgorundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(120)
        }
        
        loadingImageView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.52)
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
    }
}
