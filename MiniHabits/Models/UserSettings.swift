//
//  UserSettings.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/11.
//

import Foundation
import SwiftData

/// 用户设置数据模型
/// 存储用户的个人偏好和应用配置
@Model
final class UserSettings {
    /// 用户昵称 - 个性化标识
    var nickname: String
    
    /// 通知设置开关
    var notificationEnabled: Bool
    
    /// 是否第一次使用应用
    var isFirstLaunch: Bool
    
    /// 设置创建时间
    var createdAt: Date
    
    /// 最后更新时间
    var updatedAt: Date
    
    /// 初始化用户设置
    /// - Parameters:
    ///   - nickname: 用户昵称
    ///   - notificationEnabled: 通知开关状态
    init(
        nickname: String = "习惯达人",
        notificationEnabled: Bool = true
    ) {
        self.nickname = nickname
        self.notificationEnabled = notificationEnabled
        self.isFirstLaunch = true
        
        let now = Date()
        self.createdAt = now
        self.updatedAt = now
    }
    
    /// 更新设置
    func updateSettings(nickname: String? = nil, notificationEnabled: Bool? = nil) {
        if let nickname = nickname {
            self.nickname = nickname
        }
        
        if let notificationEnabled = notificationEnabled {
            self.notificationEnabled = notificationEnabled
        }
        
        self.updatedAt = Date()
        
        // 标记不再是第一次启动
        if isFirstLaunch {
            self.isFirstLaunch = false
        }
    }
}

// MARK: - 用户设置扩展

extension UserSettings {
    /// 获取个性化问候语
    var personalizedGreeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        let timeGreeting = switch hour {
        case 6..<12: "早上好"
        case 12..<18: "下午好" 
        case 18..<22: "晚上好"
        default: "深夜好"
        }
        return "\(timeGreeting)，\(nickname)"
    }
    
    /// 使用天数
    var daysUsingApp: Int {
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: createdAt, to: Date()).day ?? 0
        return max(days, 1) // 至少1天
    }
}