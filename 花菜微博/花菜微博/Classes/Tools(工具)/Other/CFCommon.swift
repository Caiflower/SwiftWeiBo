//
//  CFCommon.swift
//  花菜微博
//
//  Created by 花菜ChrisCai on 2016/12/18.
//  Copyright © 2016年 花菜ChrisCai. All rights reserved.
//

import Foundation

// MARK: - 全局通知
/// 用户是否登录通知
let kUserShoudLoginNotification = "userShoudLoginNotification"
/// 用户登录成功通知
let kUserLoginSuccessNotification = "kUserLoginSuccessNotification"
/// 用户token过期通知
let kUserTokenDidExpireNotification = "kUserTokenDidExpireNotification"

// MARK: - 应用程序信息

/// 新浪微博Appkey
let SinaAppKey = "941749531"
/// 应用程序加密信息
let SinaAppSecret = "96e15facd4e5d81626e66dd4a41bb5b7"
/// 回到地址 - 登录成功完成跳转的URL
let SinaRedirectURI = "http://caiflower.com"


// MARK: - 各种key
let CFBoundelVersionKey = "CFBoundelVersionKey"


// MARK: - 微博常数
/// 头像高度
let CFStatusIconViewHeight: CGFloat = 34
/// 底部工具条高度
let CFStatusToolbarHeight: CGFloat = 36
/// 通用间距
let CFCommonMargin: CGFloat = 12
/// 微博配图外部间距
let CFStatusPictureViewOutterMargin: CGFloat = CFCommonMargin
/// 微博配图内部间距
let CFStatusPictureViewInnerMargin: CGFloat = 3
/// 微博配图视图宽度
let CFStatusPictureViewWidth: CGFloat = UIScreen.main.cf_screenWidth - 2 * CFStatusPictureViewOutterMargin
/// 微博配图单个配图宽高
let CFStatusPictureItemWidth: CGFloat = (CFStatusPictureViewWidth - 2 * CFStatusPictureViewInnerMargin) / 3


		
