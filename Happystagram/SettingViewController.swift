//
//  SettingViewController.swift
//  Happystagram
//
//  Created by 三上大河 on 2018/09/25.
//  Copyright © 2018年 三上大河. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet var userNameTextField: UITextField!
    
    @IBOutlet var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.delegate = self
    
    }
    
    @IBAction func changeProfile(_ sender: Any) {
        let alertViewController = UIAlertController(title: "選択してください", message: "入力欄が空の状態です", preferredStyle: .alert)
        
        let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler: { (action: UIAlertAction!) -> Void in
            self.openCamera()
        })
        let photoAction = UIAlertAction(title: "アルバム", style: .default, handler: { (action: UIAlertAction!) -> Void in
            self.openPhoto()
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertViewController.addAction(cameraAction)
        alertViewController.addAction(photoAction)
        alertViewController.addAction(cancelAction)
        
        present(alertViewController, animated: true, completion: nil)
    }
    
    //　撮影が完了時した時に呼ばれる
    func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            profileImageView.contentMode = .scaleToFill
            profileImageView.image = pickedImage
            
        }
        
        //カメラ画面(アルバム画面)を閉じる処理
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func logout(_ sender: Any) {
        try! Auth.auth().signOut()
        UserDefaults.standard.removeObject(forKey: "check")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        var data: NSData = NSData()
        if let image = profileImageView.image {
            data = image.jpegData(compressionQuality: 0.1)! as NSData
        }
        let userName = userNameTextField.text
        let base64String = data.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters) as String
        // アプリ内へ保存する
        UserDefaults.standard.set(base64String, forKey: "profileImage")
        UserDefaults.standard.set(userName, forKey: "userName")
        dismiss(animated: true, completion: nil)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (userNameTextField.isFirstResponder) {
            userNameTextField.resignFirstResponder()
        }
    }
}
