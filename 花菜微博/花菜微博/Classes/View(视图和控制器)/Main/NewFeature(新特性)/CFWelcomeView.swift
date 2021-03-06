//
//  CFWelcomeView.swift
//  花菜微博
//
//  Created by 花菜ChrisCai on 2016/12/19.
//  Copyright © 2016年 花菜ChrisCai. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
class CFWelcomeView: UIView {
    fileprivate lazy var iconView =  UIImageView(image: UIImage(named: "avatar_default_big"))
    fileprivate lazy var label: UILabel = UILabel(text: "欢迎回来", fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.red
        setupOwerViews()
        setupLayoutConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI界面相关
extension CFWelcomeView {
    /// 添加子控件
    fileprivate func setupOwerViews() {
        // 背景图片
        let backImageView = UIImageView(image: UIImage(named: "ad_background"))
        backImageView.frame = UIScreen.main.bounds
        addSubview(backImageView)
        // 头像
        addSubview(iconView)
        // 文字
        addSubview(label)
        label.alpha = 0
        // 设置图片
        guard let urlString = CFNetworker.shared.userAccount.avatar_large,
            let url = URL(string: urlString) else {
            return
        }
        
        iconView.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar_default_big"))
        // 设置圆角半径
        iconView.cornerRadius = 85 * 0.5
    }
    
    
}

/// 添加约束
extension CFWelcomeView {
    fileprivate func setupLayoutConstraint() {
        iconView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-200)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(85)
        }
        
        label.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - 动画相关
extension CFWelcomeView {
    // 视图添加到window上,标识视图已经显示
    override func didMoveToWindow() {
        super.didMoveToWindow()
        // 强制更新约束
        self.layoutIfNeeded()
        // 更新头像的底部约束
        iconView.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(-(UIScreen.main.bounds.height - 200))
        }
        // 执行动画
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            // 更新约束
            self.layoutIfNeeded()
        }) { (_) in
            // 透明度动画
            UIView.animate(withDuration: 1, animations: { 
                self.label.alpha = 1
            }, completion: { (_) in
                // 动画完成后移除欢迎页
                self.removeFromSuperview()
            })
        }
    }
 
}

