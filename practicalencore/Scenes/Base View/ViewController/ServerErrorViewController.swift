//
//  ServerErrorViewController.swift
//  practicalencore
//
//  Created by Mac Mini on 12/11/20.
//  
//

import UIKit

final class ServerErrorViewController: BaseViewController {

    var tryAgainClouser:(() -> Void)?
    
    @IBOutlet weak var btnTryAgain: UIButton!
    
    override var description: String {
        return "No-Internet Screen"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnTryAgain.addTarget(self, action: #selector(self.btnTryAgainClick), for: .touchUpInside)
    }
    
    @objc func btnTryAgainClick() {
    }

}
