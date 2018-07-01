//
//  StampSelectViewController.swift
//  StampCamera
//
//  Created by USER on 2018/06/22.
//  Copyright © 2018年 USER. All rights reserved.
//

import UIKit

class StampSelectViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    // 画像を格納する配列
    var imageArray:[UIImage] = []

    // スタンプ画像を配置するUIView
    @IBOutlet var canvasView: UIView!
    // AppDelegateを使う為の変数
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 配列imageArrayに1〜6.pngの画像データを格納
        for i in 1...6 {
            imageArray.append(UIImage(named: "\(i).png")!)
        }
    }
    
    // 画面表示の直前に呼ばれる関数
    override func viewWillAppear(_ animated: Bool) {
        //
    }
    // コレクションビューのアイテム数を設定
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 戻り値にimageArrayのアイテム数を設定
        return imageArray.count
    }
    // コレクションビューのセルを設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //UICollectionViewCellを使う為の変数を作成する
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as UICollectionViewCell
        //セルの中の画像を表示するImageViewのタグを指定
        let imageView = cell.viewWithTag(1) as! UIImageView
        // セルの中のImageViewに配列の中の画像データを表示
        imageView.image = imageArray[indexPath.row]
        // 設定したセルを戻り値にする
        return cell
    }
    
    // コレクションビューのセルが選択された時のメソッド
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Stampのインスタンスを作成
        let stamp = Stamp()
        // stampにインデックスパスからスタンプ画像を設定
        stamp.image = imageArray[indexPath.row]
        // AppDelegateのインスタンスを取得
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // 配列stampArrayにstampを追加
        appDelegate.stampArray.append(stamp)
        // 新規スタンプ追加フラグをtrueに設定
        appDelegate.isNewStampAdded = true
        // スタンプの選択画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // スタンプ選択画面を閉じるメソッド
    @IBAction func closeTapped() {
        // モーダルで表示した画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }

}
