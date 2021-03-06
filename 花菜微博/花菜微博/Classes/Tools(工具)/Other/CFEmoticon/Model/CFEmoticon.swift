//
//  CFEmoticon.swift
//  CFEmoticon
//
//  Created by 花菜Caiflower on 2017/1/8.
//  Copyright © 2017年 花菜ChrisCai. All rights reserved.
//

import UIKit


/// 表情类型
public class CFEmoticon: NSObject {
    /// 表情包类型 false -> 图片表情 / true -> emoji
    public var type = false
    /// 表情字符串，发送给服务器(节约流量),本地根据字符创加载对应图片/表情
    public var chs: String?
    /// 表情图片名称，用于本地图文混排
    public var png: String?
    /// emoji 的十六进制编码
    public var code: String? {
        didSet {
            guard let code = code else {
                return
            }
            
            let scanner = Scanner(string: code)
            
            var result: UInt32 = 0
            scanner.scanHexInt32(&result)
            
            emoji = String(Character(UnicodeScalar(result)!))
        }
    }
    /// 表情使用次数
    public var times: Int = 0
    /// emoji 的字符串
    public var emoji: String?
    /// 表情模型所在的目录
    public var directory: String?
    /// '图片'表情对应的图像
    public var image: UIImage? {
        // 判断表情类型
        if type {
            return nil
        }
        guard let directory = directory,
            let png = png
            else {
                return nil
        }
        return UIImage(named: "\(directory)/\(png)", in: CFEmoticonBundle, compatibleWith: nil)
    }
    
    /// 将当前的图像转换生成图片的属性文本
    public func imageText(font: UIFont) -> NSAttributedString {
        // 判断图像是否存在
        guard let image = image else {
            return NSAttributedString(string: "")
        }
        // 创建文本附件
        let attachment = CFEmoticonAttachment()
        // 设置图片
        attachment.image = image
        // 设置表情纯文本
        attachment.chs = chs
        // 获取线高
        let height = font.lineHeight
        // 设置bounds
        attachment.bounds = CGRect(x: 0, y: -4, width: height, height: height)
        // 获取属性文本
        let attr = NSAttributedString(attachment: attachment)
        // 转为可变
        let attrM = NSMutableAttributedString(attributedString: attr)
        // 添加字体属性
        attrM.addAttributes([NSFontAttributeName: font], range: NSRange(location: 0, length: 1))
        
        return attrM
    }
    
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override public func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
