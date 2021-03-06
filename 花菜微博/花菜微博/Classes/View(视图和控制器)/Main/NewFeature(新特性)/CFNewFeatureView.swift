//
//  CFNewFeatureView.swift
//  花菜微博
//
//  Created by 花菜ChrisCai on 2016/12/19.
//  Copyright © 2016年 花菜ChrisCai. All rights reserved.
//

import UIKit

fileprivate let maxImageCount = 4
class CFNewFeatureView: UIView {
    /// 进入微博按钮
    fileprivate lazy var enterButton: UIButton = UIButton(title: "进入微博", fontSize: 17, color: UIColor.white, highlightedColor: UIColor.white, imageName: nil, backgroundImageName: "new_feature_finish_button")
    /// 分页控件
    fileprivate lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = maxImageCount
        pageControl.pageIndicatorTintColor = UIColor.black
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        // 禁用交互
        pageControl.isUserInteractionEnabled = false
        pageControl.sizeToFit()
        return pageControl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        setupOwerViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - 添加子视图
extension CFNewFeatureView {
    fileprivate func setupOwerViews() {
        // 添加图片容器视图
        setupContentView()
        // 添加进入微博按钮
        addSubview(enterButton)
        // 添加分页控件
        addSubview(pageControl)
        // 配置子控件
        configSubviews()
    }
    
    private func configSubviews() {
        // 隐藏进入按钮
        enterButton.isHidden = true
        enterButton.addTarget(self, action: #selector(enterStatus), for: .touchUpInside)
    }
    
    private func setupContentView() {
        // 获取主屏幕尺寸
        let rect = UIScreen.main.bounds
        // 添加内容视图
        let scrollView = UIScrollView(frame: rect)
        addSubview(scrollView)
        // 设置代理
        scrollView.delegate = self
        // 取出滚动条
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        // 取消弹簧效果
        scrollView.bounces = false
        // 开启分页
        scrollView.isPagingEnabled = true
        // 设置背景色
        scrollView.backgroundColor = UIColor.clear
        for i in 0..<maxImageCount {
            let imageName =  "new_feature_" + "\(i + 1)"
            let iv = UIImageView(image: UIImage(named: imageName))
            iv.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            scrollView.addSubview(iv)
        }
        // 添加额外的滚动区域
        scrollView.contentSize = CGSize(width: CGFloat(maxImageCount + 1) * rect.width, height: rect.height)
    }
    
    /// 布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        let rect = UIScreen.main.bounds
        enterButton.frame.origin.x = (rect.width - enterButton.frame.width) * 0.5
        enterButton.frame.origin.y = rect.height - enterButton.frame.height - 200
        pageControl.center.x = enterButton.center.x
        pageControl.frame.origin.y = enterButton.frame.maxY + 10
    }
}

extension CFNewFeatureView: UIScrollViewDelegate {
    
    /// 滚动时调用
    ///
    /// - Parameter scrollView: scrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width + 0.5)
        pageControl.currentPage = page
        enterButton.isHidden = true
        pageControl.isHidden = page == scrollView.subviews.count
    }
    
    /// 减速时调用
    ///
    /// - Parameter scrollView: scrollView
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        // 移除视图
        if page == scrollView.subviews.count {
            removeFromSuperview()
        }
        // 倒数第二页显示进入微博按钮
        enterButton.isHidden = page != scrollView.subviews.count - 1
    }
}


// MARK: - 按钮点击方法处理
extension CFNewFeatureView {

    @objc fileprivate func enterStatus() {
        self.removeFromSuperview()
    }
}
