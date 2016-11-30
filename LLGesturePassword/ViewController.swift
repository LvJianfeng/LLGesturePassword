//
//  ViewController.swift
//  LLGesturePassword
//
//  Created by LvJianfeng on 2016/11/29.
//  Copyright © 2016年 LvJianfeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var testView2: LLGestureView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 纯代码初始化
        
//        let testView = LLGestureView.init(frame: CGRect.init(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width))
//        testView.ll_BackgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
//        testView.ll_ButtonWH = 60
//        testView.ll_LayoutStyle = .layoutView
//        testView.ll_PasswordPrefix = "LL"
//        testView.ll_PasswordCharacterPrefix = "GP"
//        testView.initDidSelectedGestrue(didError: { password, error in
//            print("password:\(password) error:\(error)")
//        }, didSelected: {password in
//            print("password:\(password)")
//        })
//        
//        self.view.addSubview(testView)
        
        
        // xib
        // 设置布局style
        testView2.ll_LayoutStyle = .layoutView // 这个style的时候需要设置ll_ButtonXPadding，xib里有此属性修改，也可以代码修改
                                               // 如果是style是layoutButton，则设置ll_ButtonWH，xib里有此属性，也可以代码修改
        
        
        testView2.initDidSelectedGestrue(didError: { password, error in
            print("password:\(password) error:\(error)")
        }, didSelected: {password in
            print("password:\(password)")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

