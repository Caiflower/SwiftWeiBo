//
//  CFStatusViewModel.swift
//  花菜微博
//
//  Created by 花菜ChrisCai on 2016/12/23.
//  Copyright © 2016年 花菜ChrisCai. All rights reserved.
//

import Foundation

/// 微博视图模型
/**
如果没有任何父类,如果希望在开发时调试,输出调试信息
1. 遵守 CustomStringConvertible 协议
2. 实现 description 计算属性
 
 */
class CFStatusViewModel: CustomStringConvertible {
    
    /// 模型数据
    var status: CFStatus
    /// 会员图标
    var memberIcon: UIImage?
    /// 认证图标
    var vipIcon: UIImage?
    /// 转发
    var retweetStr: String?
    /// 评论
    var commentStr: String?
    /// 点赞
    var likeStr: String?
    /// 配图视图尺寸
    var pictureViewSize = CGSize.zero
    /// 图片模型数组
    /// 如果是被转发的微博,原创的一定没有配图
    var picUrls: [CFStatusPicture]? {
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    /// 缓存高度
    var rowHeight: CGFloat = 0
    /// 被转发的微博正文
    var retweetedText: String? {
        return "@" + (status.retweeted_status?.user?.screen_name ?? "") + ":" + (status.retweeted_status?.text ?? "")
    }
    
    init(model: CFStatus) {
        self.status = model
        setMemberlevel()
        setVerifiedType()
        setCountStrin()
        // 有原创的计算原创的,有转发的计算转发的
        pictureViewSize = calculatePictureViewSize(count: picUrls?.count ?? 0)
        // 计算高度
        updateRowHeight()
    }
    
    
    /// 设置会员等级
    func setMemberlevel() {
        if let mbrank = self.status.user?.mbrank {
            if mbrank > 0 && mbrank < 7 {
                let imageName = "common_icon_membership_level" + "\(mbrank)"
                memberIcon = UIImage(named: imageName)
            }
        }
    }
    
    /// 设置用户认证类型
    fileprivate func setVerifiedType() {
        // 认证类型 -1: 没有认证, 0: 认证用户, 2,3,5:企业认证,220:达人认证
        switch self.status.user?.verified_type ?? -1{
        case 0:
            vipIcon = UIImage(named: "avatar_vip")
        case 2,3,5:
            vipIcon = UIImage(named: "avatar_enterprise_vip")
        case 220:
            vipIcon = UIImage(named: "avatar_grassroot")
        default:
            break
        }
    }
    
    fileprivate func setCountStrin() {
        retweetStr = countString(count: self.status.reposts_count, defaultString: "转发")
        commentStr = countString(count: self.status.comments_count, defaultString: "评论")
        likeStr = countString(count: self.status.attitudes_count, defaultString: "赞")
    }
    
    /// 设置转发,评论,点赞的描述
    ///
    /// - Parameters:
    ///   - count: 转发,评论,点赞的数量
    ///   - defaultString: 默认文字
    /// - Returns: 描述文字
   fileprivate func countString(count: Int, defaultString: String) -> String {
        if count == 0 {
            return defaultString
        }
        if count < 10000 {
            return count.description
        }
        return String(format: "%.2f 万", Double(count) / 10000)
    }
    
    
    /// 计算微博配图视图的大小
    ///
    /// - Parameter count: 图片个数
    /// - Returns: 配图尺寸
    fileprivate func calculatePictureViewSize(count: Int) -> CGSize {
        if count == 0 {
            return CGSize.zero
        }
        // 计算行数
        let row = (count - 1) / 3 + 1
        // 计算高度
        let height = CFStatusPictureViewOutterMargin + CGFloat(row - 1) * CFStatusPictureViewInnerMargin + CGFloat(row) * CFStatusPictureItemWidth
        print(height,count)
        return CGSize(width: CFStatusPictureViewWidth, height: height)
    }
    
    /// 计算单张配图视图的尺寸
    ///
    /// - Parameter image: 单张的配图
    func updatePictureViewSize(image: UIImage) {
        var size = image.size
        // 添加顶部间距
        size.height += CFStatusPictureViewOutterMargin
        pictureViewSize = size
        // 重新计算行高
        updateRowHeight()
    }
    
    fileprivate func updateRowHeight() {
        // 原创微博 顶部分隔(12) + 间距(12) + 头像高度(34) + 间距(12) + 正文(计算) + 配图高度(计算) + 间距(12) + 底部工具视图高度(36)
        // 转发微博 顶部分隔(12) + 间距(12) + 头像高度(34) + 间距(12) + 正文(计算) + 间距(12) + 间距(12) + 被转发的正文(计算) + 配图高度(计算) + 间距(12) + 底部工具视图高度(36)
        // 定义行高
        var rowHeight: CGFloat = 0
        // label最大宽度
        let maxWidth: CGFloat = UIScreen.main.cf_screenWidth - 2 * CFCommonMargin
        // 顶部高度
        let topHeight: CGFloat = CFCommonMargin * 2 + CFStatusIconViewHeight + CFCommonMargin

        let textHeight: CGFloat = status.text?.calculateSize(font: UIFont.systemFont(ofSize: 15), maxWidth: maxWidth).height ?? 0
        
        rowHeight += topHeight + textHeight
        print("正文高度:\(textHeight)")
        // 被转发的微博
        if status.retweeted_status != nil {
            let retweetHeight: CGFloat = retweetedText?.calculateSize(font: UIFont.systemFont(ofSize: 14), maxWidth: maxWidth).height ?? 0
            rowHeight += CFCommonMargin * 2 + retweetHeight
        }
        rowHeight += pictureViewSize.height + CFCommonMargin + CFStatusToolbarHeight
        
        self.rowHeight = rowHeight
    }
    
    
    var description: String {
        return self.status.description
    }
    
    
    
    
    
}
