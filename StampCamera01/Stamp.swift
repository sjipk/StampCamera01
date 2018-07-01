//
//  Stamp.swift
//  StampCamera
//
//  Created by USER on 2018/06/22.
//  Copyright © 2018年 USER. All rights reserved.
//

import UIKit

class Stamp: UIImageView {
    // ユーザが画面をタッチした時に呼ばれるメソッド
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // このクラスの親ビューを最前面に設定
        self.superview?.bringSubview(toFront: self)
    }
    
    // 画面上で指が動いた時に呼ばれるメソッド
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // タッチイベントを取得
        let touchEvent = touches.first!
        
        // ドラッグ前の座標, Swift 1.2 から
        let preDx = touchEvent.previousLocation(in: self.superview).x
        let preDy = touchEvent.previousLocation(in: self.superview).y
        
        // ドラッグ後の座標
        let newDx = touchEvent.location(in: self.superview).x
        let newDy = touchEvent.location(in: self.superview).y
        
        // ドラッグしたx座標の移動距離
        let dx = newDx - preDx
//        print("x:\(dx)")
        
        // ドラッグしたy座標の移動距離
        let dy = newDy - preDy
//        print("y:\(dy)")
        
        self.center = CGPoint(x: self.center.x + dx, y: self.center.y + dy)
    }

}
