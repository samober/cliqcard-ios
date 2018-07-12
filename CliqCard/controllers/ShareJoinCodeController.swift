//
//  ShareJoinCodeController.swift
//  CliqCard
//
//  Created by Sam Ober on 7/8/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SnapKit
import QRCode

class ShareJoinCodeController: UIViewController {
    
    var code: String
    
    lazy var codeLabel: UILabel! = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = UIFont(name: "Lato-Bold", size: 48)
        view.textColor = Colors.darkestGray
        view.textAlignment = .center
        
        return view
    }()
    
    lazy var qrCodeView: UIImageView! = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.layer.borderColor = Colors.lightGray.cgColor
        view.layer.borderWidth = 2.0
        
        return view
    }()
    
    init(code: String) {
        self.code = code
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white

        self.title = "Join Code"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close))
        
        self.view.addSubview(self.codeLabel)
        self.codeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        self.view.addSubview(self.qrCodeView)
        self.qrCodeView.snp.makeConstraints { make in
            make.top.equalTo(self.codeLabel.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(self.qrCodeView.snp.width)
        }
        
        self.codeLabel.text = self.code
        
        // generate a qr code
        let qrCode = QRCode(self.code)
        // set the image
        self.qrCodeView.image = qrCode?.image
    }

    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }

}
