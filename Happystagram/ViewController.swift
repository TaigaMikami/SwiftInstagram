//
//  ViewController.swift
//  Happystagram
//
//  Created by 三上大河 on 2018/09/24.
//  Copyright © 2018年 三上大河. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    var items = [NSDictionary]()
    let refreshControl = UIRefreshControl()
    var passImage: UIImage = UIImage()

    var nowtableViewImage = UIImage()
    var nowtableViewUserName = String()
    var nowtableViewUserImage = UIImage()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if UserDefaults.standard.object(forKey: "check") != nil {
            
        } else {
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "login")
            self.present(loginViewController!, animated: true, completion: nil)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        
        items = [NSDictionary]()
        loadAllData()
        tableView.reloadData()
    }
    
    @objc func refresh() {
        // データを読んでくる
        // tableViewリロード
        items = [NSDictionary]()
        loadAllData()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // TableViewのデリゲートメソッド
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let dict = items[(indexPath as NSIndexPath).row]
        
        
        //プロフィール
        let profileImageView = cell.viewWithTag(1) as! UIImageView
        
        //デコードしたデータをUIImage型へ変換してimageviewへ反映する
        let decodeData = (base64Encoded:dict["profileImage"])
        let decodedData = NSData(base64Encoded: decodeData as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        let decodedImage = UIImage(data:decodedData! as  Data)
        profileImageView.layer.cornerRadius = 8.0
        profileImageView.clipsToBounds = true
        
        profileImageView.image = decodedImage
        
        
        
        //ユーザー名
        let userNameLabel = cell.viewWithTag(2) as! UILabel
        userNameLabel.text = dict["username"] as? String
        
        
        
        //投稿画像
        let postedImageView = cell.viewWithTag(3) as! UIImageView
        //abv
        let decodeData2 = (base64Encoded:dict["postImage"])
        let decodedData2 = NSData(base64Encoded: decodeData2 as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        let decodedImage2 = UIImage(data:decodedData2! as  Data)
        postedImageView.image = decodedImage2
        
        //コメント
        let commentTextView = cell.viewWithTag(4) as! UITextView
        commentTextView.text = dict["comment"] as? String
        
        
        
        return cell
    }
    
    // データベースからデータをとってきて、配列の中に入れた
    func loadAllData() {
        // https://happystagram60.firebaseio.com/
        UIApplication.shared.isNetworkActivityIndicatorVisible = true // くるくる
//        var firebase: DatabaseReference!
        let firebase = Database.database().reference(fromURL: "https://happystagram60.firebaseio.com/").child("Posts")
        
        firebase.queryLimited(toLast: 10).observe(.value) { (snapshot, error) in
            var tempItems = [NSDictionary]()
            for item in(snapshot.children) {
                let child = item as! DataSnapshot
                let dict = child.value
                tempItems.append(dict as! NSDictionary)
            }
            self.items = tempItems
            self.items = self.items.reversed()
            NSLog("アイテム", self.items)
            self.tableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = items[(indexPath as NSIndexPath).row]
        
        // デコードして取り出す
        let decodeData = (base64Encoded:dict["profileImage"])
        let decodedData = NSData(base64Encoded: decodeData as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        let decodedImage = UIImage(data: decodedData! as
            Data)
        nowtableViewUserImage = decodedImage!
        
        nowtableViewUserName = (dict["username"] as? String)!
        
        let decodeData2 = (base64Encoded:dict["postImage"])
        let decodedData2 = NSData(base64Encoded: decodeData2 as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        let decodedImage2 = UIImage(data: decodedData2! as
            Data)
        nowtableViewImage = decodedImage2!
        
        performSegue(withIdentifier: "sns", sender: nil)
        
    }
    
    func openCamera() {
        let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
        }
    }
    
    func openPhoto() {
        let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func showCamera(_ sender: Any) {
        openCamera()
    }
    

    @IBAction func showPhotos(_ sender: Any) {
        openPhoto()
    }
    
    //　撮影が完了時した時に呼ばれる
    func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            passImage = pickedImage
            performSegue(withIdentifier: "next", sender: nil)
        }
        
        //カメラ画面(アルバム画面)を閉じる処理
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "next") {
            let editVC: EditViewController = segue.destination as! EditViewController
            editVC.willEditImage = passImage
        }
        if (segue.identifier == "sns") {
            let snsVC:SnsViewController = segue.destination as! SnsViewController
            snsVC.detailImage = nowtableViewUserImage
            snsVC.detailProfileImage = nowtableViewUserImage
            snsVC.detailUserName = nowtableViewUserName
        }
    }

}

