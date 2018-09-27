//
//  SnsViewController.swift
//  Happystagram
//
//  Created by 三上大河 on 2018/09/27.
//  Copyright © 2018年 三上大河. All rights reserved.
//

import UIKit
import Social

class SnsViewController: UIViewController {

    // 投稿されている画像
    var detailImage = UIImage()
    // プロフィール画像
    var detailProfileImage = UIImage()
    var detailUserName = String()
    
    var myComposeView:SLComposeViewController!
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var label: UILabel!
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileImageView.image = detailProfileImage
        label.text = detailUserName
        imageView.image = detailImage
        profileImageView.layer.cornerRadius = 8.0
        profileImageView.clipsToBounds = true
    }

    @IBAction func shareTwitter(_ sender: Any) {
        myComposeView = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        
        // 投稿するテキスト
        let string = "#Happystagram" + "photo by" + label.text!
        myComposeView.setInitialText(string)
        myComposeView.add(imageView.image)
        
        // 表示する
        self.present(myComposeView, animated: true, completion: nil)
        
    }
}
