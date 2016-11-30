//
//  LLGestureView.swift
//  LLGesturePassword
//
//  Created by LvJianfeng on 2016/11/29.
//  Copyright © 2016年 LvJianfeng. All rights reserved.
//

import UIKit

public typealias didSelectedError = (String, String) -> Void
public typealias didSelectedGesturePassword = (String) -> Void

public enum GestureViewLayoutStyle {
    // 根据button大小计算间隔大小
    case layoutButton
    // 根据间隔大小计算显示button大小
    case layoutView
}

// MARK: Gesture View
open class LLGestureView: UIView {
    // MARK: Size
    // Default Width
    @IBInspectable open var ll_ButtonWH: CGFloat = 50
    // Default Padding
    @IBInspectable open var ll_ButtonXPadding: CGFloat = 50
    // Default LineWidth
    @IBInspectable open var ll_LineWidth: CGFloat = 7
    // Default Password Length
    @IBInspectable open var ll_passwordLength: NSInteger = 4
    
    // MARK: Style
    // Default GestureViewLayoutStyle
    open var ll_LayoutStyle: GestureViewLayoutStyle = .layoutButton {
        didSet {
            setupButtonView()
        }
    }
    
    // MARK: Color
    // Default Line Color
    @IBInspectable open var ll_LineColor: UIColor = UIColor.lightGray
    // Default Background Color
    @IBInspectable open var ll_BackgroundColor: UIColor = UIColor.white{
        didSet {
            setupButtonView()
        }
    }
    
    @IBInspectable open var ll_PasswordPrefix: String?
    @IBInspectable open var ll_PasswordCharacterPrefix: String?
    // 闭包
    // 绘制错误回调
    open var didSelectedError: didSelectedError?
    // 绘制手势密码后回调
    open var didSelectedGesturePassword: didSelectedGesturePassword?
    
    fileprivate var selectedLLButtons = [LLGestureButton]()
    fileprivate var currentTouchLocation: CGPoint?
    fileprivate var passwordPath: String?
    
    open func initDidSelectedGestrue(didError: didSelectedError? = nil, didSelected: didSelectedGesturePassword? = nil) {
        if didError != nil {
            didSelectedError = didError
        }
        
        if didSelected != nil {
            didSelectedGesturePassword = didSelected
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupButtonView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButtonView()
    }
    
    fileprivate func setupButtonView() {
        // Clear
        clear()
        // Background Color
        self.backgroundColor = ll_BackgroundColor
        // GestureButton
        for index in 0 ..< 9 {
            if ll_LayoutStyle == .layoutView {
                ll_ButtonWH = (self.frame.size.width - ll_ButtonXPadding * 4) / 3
            }
            let button:  LLGestureButton = LLGestureButton.init(frame: CGRect.init(x: 0, y: 0, width: ll_ButtonWH, height: ll_ButtonWH))
            button.tag = index
            self.addSubview(button)
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        for index in 0 ..< self.subviews.count {
            let button: LLGestureButton = self.subviews[index] as! LLGestureButton
            // Column
            let col = index % 3
            // Row
            let row = index / 3
            // Style
            
            // 计算间隔空间
            var marginXY = (self.frame.size.width - ll_ButtonWH * 3) / 4
            
            if ll_LayoutStyle == .layoutView {
                marginXY = ll_ButtonXPadding
            }
            button.frame = CGRect.init(x: marginXY + CGFloat(col) * (ll_ButtonWH + marginXY), y: marginXY + CGFloat(row) * (ll_ButtonWH + marginXY), width: ll_ButtonWH, height: ll_ButtonWH)

        }
    }
    
    // MARK: Touch Began
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesMoved(touches, with: event)
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let location = touch.location(in: touch.view)
        for subview in self.subviews {
            if let buttonView = (subview as? LLGestureButton) {
                if (buttonView.ll_TouchFrame?.contains(location))!{
                    buttonView.isSelected = true
                    if !selectedLLButtons.contains(buttonView) {
                        selectedLLButtons.append(buttonView)
                    }
                }
            }
            currentTouchLocation = location
        }
        setNeedsDisplay()
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let ll_PasswordPrefix = ll_PasswordPrefix {
            passwordPath = ll_PasswordPrefix
        }else{
            passwordPath = String()
        }
        
        for button in selectedLLButtons {
            button.isSelected = false
            
            if let ll_PasswordCharacterPrefix = ll_PasswordCharacterPrefix {
                passwordPath!.append("\(ll_PasswordCharacterPrefix)\(button.tag)")
            }else{
                passwordPath!.append("\(button.tag)")
            }
        }
        
        if selectedLLButtons.count < ll_passwordLength {
            if let didSelectedError = didSelectedError {
                didSelectedError(passwordPath!, "连接点不能少于\(ll_passwordLength)个点")
            }
        }else{
            if let didSelectedGesturePassword = didSelectedGesturePassword {
                didSelectedGesturePassword(passwordPath!)
            }
        }

        self.selectedLLButtons.removeAll()
        setNeedsDisplay()
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    // MARK: Draw
    override open func draw(_ rect: CGRect) {
        if selectedLLButtons.isEmpty { return }
        let path = UIBezierPath()
        
        for index in 0 ..< selectedLLButtons.count {
            let button = selectedLLButtons[index]
            if 0 == index {
                path.move(to: button.center)
            }else{
                path.addLine(to: button.center)
            }
        }
        if selectedLLButtons.count > 0 {
            path.addLine(to: currentTouchLocation!)
        }
        
        ll_LineColor.set()
        path.lineWidth = ll_LineWidth
        path.lineCapStyle = .round
        path.lineJoinStyle = .bevel
        
        path.stroke()
    }
    
    // MARK: Clear
    func clear() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
}


// MARK: Gestrue Button
class LLGestureButton: UIButton {
    // Default Width
    open var ll_ButtonWH: CGFloat = 60
    // Touch Frame
    open var ll_TouchFrame: CGRect?

    override init(frame: CGRect) {
        super.init(frame: frame)
        ll_ButtonWH = frame.size.width
        // isUserInteractionEnabled
        self.isUserInteractionEnabled = false
        // State = .normal
        self.setBackgroundImage(#imageLiteral(resourceName: "zhiwen_un"), for: .normal)
        // State = .selected
        self.setBackgroundImage(#imageLiteral(resourceName: "zhiwen"), for: .selected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("LLGestureButton: init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ll_TouchFrame = CGRect.init(x: self.center.x - ll_ButtonWH * 0.5, y: self.center.y - ll_ButtonWH * 0.5, width: ll_ButtonWH, height: ll_ButtonWH)
    }
}
