//
//  HabitTemplate.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/7.
//

import Foundation

/// 习惯模板数据模型
/// 提供常用的习惯预设，便于用户快速创建习惯
struct HabitTemplate: Identifiable, Codable {
    /// 模板唯一标识符
    let id: UUID

    /// 模板名称
    let name: String

    /// 模板分类
    let category: Category

    /// 习惯标题（大目标）
    let title: String

    /// Emoji 图标
    let emoji: String

    /// 微习惯描述
    let microHabit: String

    /// 推荐的专注时长（分钟）
    let recommendedDuration: Int

    /// 主题色
    let themeColor: String

    /// 模板描述
    let description: String

    /// 初始化方法
    init(
        name: String,
        category: Category,
        title: String,
        emoji: String,
        microHabit: String,
        recommendedDuration: Int = 3,
        themeColor: String,
        description: String = ""
    ) {
        id = UUID()
        self.name = name
        self.category = category
        self.title = title
        self.emoji = emoji
        self.microHabit = microHabit
        self.recommendedDuration = recommendedDuration
        self.themeColor = themeColor
        self.description = description
    }
}

// MARK: - 模板分类

extension HabitTemplate {
    /// 习惯模板分类
    enum Category: String, CaseIterable, Codable {
        /// 运动健身
        case fitness
        /// 学习阅读
        case learning
        /// 冥想放松
        case mindfulness
        /// 创作写作
        case creativity
        /// 健康生活
        case health
        /// 社交关系
        case social

        /// 分类显示名称
        var displayName: String {
            switch self {
            case .fitness:
                return "运动健身"
            case .learning:
                return "学习阅读"
            case .mindfulness:
                return "冥想放松"
            case .creativity:
                return "创作写作"
            case .health:
                return "健康生活"
            case .social:
                return "社交关系"
            }
        }

        /// 分类图标
        var icon: String {
            switch self {
            case .fitness:
                return "💪"
            case .learning:
                return "📚"
            case .mindfulness:
                return "🧘‍♀️"
            case .creativity:
                return "🎨"
            case .health:
                return "🌱"
            case .social:
                return "👥"
            }
        }
    }
}

// MARK: - 便利方法

extension HabitTemplate {
    /// 转换为Habit对象
    /// - Returns: 基于模板创建的Habit实例
    func createHabit() -> Habit {
        return Habit(
            title: title,
            emoji: emoji,
            microHabit: microHabit,
            focusDuration: recommendedDuration,
            themeColor: themeColor
        )
    }
}

// MARK: - 预设模板数据

extension HabitTemplate {
    /// 获取所有预设模板
    static var allTemplates: [HabitTemplate] {
        return [
            // 运动健身类
            HabitTemplate(
                name: "骑行锻炼",
                category: .fitness,
                title: "骑行3公里",
                emoji: "🚴‍♂️",
                microHabit: "骑行10米",
                recommendedDuration: 3,
                themeColor: "#4ECDC4",
                description: "每天骑行锻炼，从10米开始培养运动习惯"
            ),
            HabitTemplate(
                name: "俯卧撑",
                category: .fitness,
                title: "做50个俯卧撑",
                emoji: "💪",
                microHabit: "做1个俯卧撑",
                recommendedDuration: 2,
                themeColor: "#FF6B6B",
                description: "简单的力量训练，从一个俯卧撑开始"
            ),
            HabitTemplate(
                name: "步行运动",
                category: .fitness,
                title: "走1万步",
                emoji: "🚶‍♂️",
                microHabit: "走50步",
                recommendedDuration: 1,
                themeColor: "#4ECDC4",
                description: "日常步行锻炼，从50步开始建立习惯"
            ),

            // 学习阅读类
            HabitTemplate(
                name: "阅读习惯",
                category: .learning,
                title: "阅读30分钟",
                emoji: "📚",
                microHabit: "读1页书",
                recommendedDuration: 2,
                themeColor: "#45B7D1",
                description: "培养每日阅读习惯，从一页开始"
            ),
            HabitTemplate(
                name: "英语学习",
                category: .learning,
                title: "背100个单词",
                emoji: "🇬🇧",
                microHabit: "背1个单词",
                recommendedDuration: 2,
                themeColor: "#A8E6CF",
                description: "每日英语学习，从一个单词开始积累"
            ),
            HabitTemplate(
                name: "技能学习",
                category: .learning,
                title: "学习新技能1小时",
                emoji: "🎓",
                microHabit: "学习5分钟",
                recommendedDuration: 5,
                themeColor: "#FFD93D",
                description: "持续学习新技能，从5分钟开始"
            ),

            // 冥想放松类
            HabitTemplate(
                name: "冥想练习",
                category: .mindfulness,
                title: "冥想20分钟",
                emoji: "🧘‍♀️",
                microHabit: "深呼吸3次",
                recommendedDuration: 1,
                themeColor: "#96CEB4",
                description: "通过冥想放松身心，从深呼吸开始"
            ),
            HabitTemplate(
                name: "正念练习",
                category: .mindfulness,
                title: "正念练习15分钟",
                emoji: "🌸",
                microHabit: "觉察1分钟",
                recommendedDuration: 1,
                themeColor: "#FFEAA7",
                description: "培养正念意识，从一分钟觉察开始"
            ),

            // 创作写作类
            HabitTemplate(
                name: "写作练习",
                category: .creativity,
                title: "写作500字",
                emoji: "✍️",
                microHabit: "写20字",
                recommendedDuration: 5,
                themeColor: "#FFEAA7",
                description: "每日写作练习，从20字开始表达"
            ),
            HabitTemplate(
                name: "绘画创作",
                category: .creativity,
                title: "绘画30分钟",
                emoji: "🎨",
                microHabit: "画一条线",
                recommendedDuration: 3,
                themeColor: "#FF7675",
                description: "艺术创作习惯，从一条线开始"
            ),

            // 健康生活类
            HabitTemplate(
                name: "喝水习惯",
                category: .health,
                title: "喝8杯水",
                emoji: "💧",
                microHabit: "喝一口水",
                recommendedDuration: 1,
                themeColor: "#74B9FF",
                description: "保持充足水分摄入，从一口开始"
            ),
            HabitTemplate(
                name: "早睡习惯",
                category: .health,
                title: "11点前睡觉",
                emoji: "😴",
                microHabit: "准备睡觉",
                recommendedDuration: 2,
                themeColor: "#A29BFE",
                description: "建立良好作息，从准备睡觉开始"
            ),
        ]
    }

    /// 根据分类获取模板
    /// - Parameter category: 模板分类
    /// - Returns: 该分类下的所有模板
    static func templates(for category: Category) -> [HabitTemplate] {
        return allTemplates.filter { $0.category == category }
    }

    /// 获取推荐模板（每个分类选一个）
    static var recommendedTemplates: [HabitTemplate] {
        var recommended: [HabitTemplate] = []
        for category in Category.allCases {
            if let template = templates(for: category).first {
                recommended.append(template)
            }
        }
        return recommended
    }
}
