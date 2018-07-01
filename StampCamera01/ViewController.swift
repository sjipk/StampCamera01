//
//  ViewController.swift
//  StampCamera
//
//  Created by USER on 2018/06/20.
//  Copyright © 2018年 USER. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIActionSheetDelegate,
UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var mainImageView : UIImageView!
    
    // スタンプ画像を配置するUIView
    @IBOutlet var canvasView: UIView!
    // AppDelegateを使う為の変数
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // 画面表示の直前に呼ばれるメソッド
    override func viewWillAppear(_ animated: Bool) {
        //viewWillAppearを上書きする時に必要な処理
        super.viewWillAppear(animated)
        // 新規スタンプ画像フラグがtrueの場合、実行する処理
        if appDelegate.isNewStampAdded == true {
            // stampArrayの最後に入っている要素を取得
            let stamp = appDelegate.stampArray.last!
            // スタンプのフレームを設定
            stamp.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            // スタンプの設置座標を写真画像の中心に設定
            stamp.center = mainImageView.center
            // スタンプのタッチ操作を許可
            stamp.isUserInteractionEnabled = true
            // スタンプを自分で配置したViewに設置
            canvasView.addSubview(stamp)
            // 新規スタンプ画像フラグをfalseに設定
            appDelegate.isNewStampAdded = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // アクションシート表示メソッド
    @IBAction func cameraTapped() {
        // UIActionSheetを使う為の定数を作成
        let sheet = UIAlertController(title: "タイトル", message: "メッセージ", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        // カメラアクション
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in
            print("カメラが選択されました。")
            
            let sourceType:UIImagePickerControllerSourceType =
                UIImagePickerControllerSourceType.camera
            // カメラが利用可能かチェック
            if UIImagePickerController.isSourceTypeAvailable(
                UIImagePickerControllerSourceType.camera){
                // インスタンスの作成
                let cameraPicker = UIImagePickerController()
                cameraPicker.sourceType = sourceType
                cameraPicker.delegate = self
                self.present(cameraPicker, animated: true, completion: nil)
                
            }
            else{
                //                label.text = "error"
                
            }
            
        })
        sheet.addAction(cameraAction)
        
        // ライブラリアクション
        let libraryAction = UIAlertAction(title: "Library", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in
            print("ライブラリが選択されました。")
            
            let sourceType:UIImagePickerControllerSourceType =
                UIImagePickerControllerSourceType.photoLibrary
            // カメラが利用可能かチェック
            if UIImagePickerController.isSourceTypeAvailable(
                UIImagePickerControllerSourceType.photoLibrary){
                // インスタンスの作成
                let photoLibraryPicker = UIImagePickerController()
                photoLibraryPicker.sourceType = sourceType
                photoLibraryPicker.delegate = self
                self.present(photoLibraryPicker, animated: true, completion: nil)
                
            }
            else{
                //                label.text = "error"
                
            }
            
        })
        sheet.addAction(libraryAction)
        
        // キャンセルアクション
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(action: UIAlertAction!) in
            print("キャンセルが選択されました。")
        })
        sheet.addAction(cancelAction)
        
        //アクションを表示する
        self.present(sheet, animated: true, completion: nil)
        
    }
    
    //　撮影が完了時した時に呼ばれる
    func imagePickerController(_ imagePicker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage]
            as? UIImage {
            
            mainImageView.contentMode = .scaleAspectFit
            mainImageView.image = pickedImage
            
        }
        
        //閉じる処理
        imagePicker.dismiss(animated: true, completion: nil)
        //        label.text = "Tap the [Save] to save a picture"
        
    }
    
    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        //        label.text = "Canceled"
    }
    
    // スタンプ選択画面遷移メソッド
    @IBAction func stampTapped() {
        //SegueのIdentifierを設定
        self.performSegue(withIdentifier: "ToStampList", sender: self)
    }
    
    // スタンプ画像の削除
    @IBAction func deleteTapped() {
        // canvasViewのサブビューの数が１より大きかったら実行
        if canvasView.subviews.count > 1 {
            // canvasViewの子ビューの最後のものを取り出す
            let lastStamp = canvasView.subviews.last as! Stamp
            // canvasViewからlastStampを削除する。
            lastStamp.removeFromSuperview()
            // lastStampが格納されているstampArrayのインデックス番号を取得
            if let index = appDelegate.stampArray.index(of: lastStamp) {
                // stampArrayからlastStampを削除
                appDelegate.stampArray.remove(at: index)
            }
        }
    }
    
    
    // 画像をレンダリングして保存
    @IBAction func saveTapped() {
        // 画像コンテキストをサイズ、透過の有無、スケールを指定して作成
        UIGraphicsBeginImageContextWithOptions(canvasView.bounds.size, canvasView.isOpaque, 0.0)
        // canvasViewのレイヤーをレンダリング
        canvasView.layer.render(in: UIGraphicsGetCurrentContext()!)
        // レンダリングした画像を取得
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 画像コンテキストを破棄
        UIGraphicsEndImageContext()
        // 取得した画像をフォトライブラリーへ保存
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(self.didFinishSavingImage(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    // 写真の保存後に呼ばれるメソッド
    @objc func didFinishSavingImage(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
        
        let alert: UIAlertController = UIAlertController(title: "保存", message: "保存完了です。", preferredStyle:  UIAlertControllerStyle.alert)
        
        // Actionの設定
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
        })
        // UIAlertControllerにActionを追加
        alert.addAction(defaultAction)
        
        // Alertを表示
        present(alert, animated: true, completion: nil)
        
    }
    
}

