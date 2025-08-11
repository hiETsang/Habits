//
//  DesignSystem.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/7.
//

import SwiftUI

/// MiniHabits 设计系统
/// 定义应用的视觉语言和交互准则
enum DesignSystem {
    // MARK: - 色彩系统

    enum Colors {
        /// 主色调 - 温暖的橙色，代表活力和专注
        static let primary = Color(hex: "#FF6B35")

        /// 背景色系
        static let background = Color(hex: "#FAFAFA")
        static let surfaceWhite = Color.white
        static let surfaceGray = Color(hex: "#F5F5F7")

        /// 文本色系 - 精心调制的灰度层级
        static let textPrimary = Color(hex: "#1D1D1F") // 主要文本
        static let textSecondary = Color(hex: "#86868B") // 次要文本
        static let textTertiary = Color(hex: "#C7C7CC") // 三级文本

        /// 系统状态色
        static let success = Color(hex: "#34C759") // 成功/完成
        static let warning = Color(hex: "#FF9500") // 警告
        static let error = Color(hex: "#FF3B30") // 错误/危险

        /// 习惯主题色系 - 情感化配色
        static let habitThemes: [String: Color] = [
            "fitness": Color(hex: "#4ECDC4"), // 清新薄荷 - 运动健身
            "learning": Color(hex: "#45B7D1"), // 智慧蓝 - 学习阅读
            "mindfulness": Color(hex: "#96CEB4"), // 宁静绿 - 冥想放松
            "creativity": Color(hex: "#FFEAA7"), // 创意黄 - 创作写作
            "health": Color(hex: "#74B9FF"), // 活力蓝 - 健康生活
            "social": Color(hex: "#FD79A8"), // 温暖粉 - 社交关系
        ]

        /// Tab Bar 色系
        static let tabSelected = primary
        static let tabUnselected = textTertiary
    }

    // MARK: - 字体系统

    enum Typography {
        /// 大标题 - 页面主标题
        static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)

        /// 标题1 - 区块标题
        static let title1 = Font.system(size: 28, weight: .semibold, design: .rounded)

        /// 标题2 - 卡片标题
        static let title2 = Font.system(size: 22, weight: .semibold, design: .rounded)

        /// 标题3 - 小节标题
        static let title3 = Font.system(size: 20, weight: .medium, design: .rounded)

        /// 正文 - 主要内容
        static let body = Font.system(size: 17, weight: .regular, design: .default)

        /// 说明文字 - 次要信息
        static let callout = Font.system(size: 16, weight: .regular, design: .default)

        /// 小字 - 辅助信息
        static let footnote = Font.system(size: 13, weight: .regular, design: .default)

        /// 按钮文字
        static let button = Font.system(size: 17, weight: .semibold, design: .rounded)

        /// Tab标签
        static let tabLabel = Font.system(size: 10, weight: .medium, design: .rounded)
    }

    // MARK: - 间距系统

    enum Spacing {
        /// 极小间距 - 4pt
        static let xs: CGFloat = 4

        /// 小间距 - 8pt
        static let sm: CGFloat = 8

        /// 标准间距 - 12pt
        static let md: CGFloat = 12

        /// 大间距 - 16pt
        static let lg: CGFloat = 16

        /// 超大间距 - 24pt
        static let xl: CGFloat = 24

        /// 极大间距 - 32pt
        static let xxl: CGFloat = 32

        /// 页面边距 - 20pt (黄金比例的运用)
        static let pageHorizontal: CGFloat = 20

        /// 卡片间距 - 16pt
        static let cardSpacing: CGFloat = 16

        /// 安全区域补偿
        static let safeAreaCompensation: CGFloat = 8
    }

    // MARK: - 圆角系统

    enum CornerRadius {
        /// 小圆角 - 按钮、标签
        static let small: CGFloat = 8

        /// 标准圆角 - 卡片、输入框
        static let medium: CGFloat = 12

        /// 大圆角 - 主要卡片
        static let large: CGFloat = 16

        /// 超大圆角 - 特殊容器
        static let extraLarge: CGFloat = 24

        /// 圆形 - 头像、图标
        static let circle: CGFloat = 50
    }

    // MARK: - 阴影系统

    enum Shadow {
        /// 轻微阴影 - 悬浮感
        static let subtle = ShadowStyle(
            color: Color.black.opacity(0.05),
            radius: 4,
            x: 0,
            y: 2
        )

        /// 标准阴影 - 卡片
        static let medium = ShadowStyle(
            color: Color.black.opacity(0.08),
            radius: 12,
            x: 0,
            y: 4
        )

        /// 强阴影 - 弹窗
        static let strong = ShadowStyle(
            color: Color.black.opacity(0.15),
            radius: 24,
            x: 0,
            y: 8
        )
    }

    // MARK: - 动画系统

    enum Animation {
        /// 快速动画 - 状态切换
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.2)

        /// 标准动画 - 界面切换
        static let standard = SwiftUI.Animation.easeInOut(duration: 0.3)

        /// 慢动画 - 重要状态变化
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.5)

        /// 弹性动画 - 互动反馈
        static let bouncy = SwiftUI.Animation.spring(
            response: 0.6,
            dampingFraction: 0.8,
            blendDuration: 0
        )
    }

    // MARK: - 网格系统

    enum Grid {
        /// 标准网格 - 2列卡片布局
        static let columns = [
            GridItem(.flexible(), spacing: Spacing.cardSpacing),
            GridItem(.flexible(), spacing: Spacing.cardSpacing),
        ]

        /// 卡片最小高度
        static let cardMinHeight: CGFloat = 120

        /// 卡片宽高比
        static let cardAspectRatio: CGFloat = 1.2
    }
}

// MARK: - 阴影样式

struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - Color扩展

extension Color {
    /// 十六进制颜色初始化
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
