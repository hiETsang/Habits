//
//  Habit.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/7.
//

import Foundation
import SwiftData

/// 习惯数据模型
/// 遵循微习惯理论，每个习惯包含大目标和微小行动
@Model
final class Habit {
    /// 习惯的唯一标识符
    var id: UUID

    /// 习惯标题（大目标描述，如"骑行3公里"）
    var title: String

    /// Emoji 图标标识
    var emoji: String

    /// 微习惯描述（微小行动，如"骑行10米"）
    var microHabit: String

    /// 启动时间（分钟），用于专注倒计时
    var focusDuration: Int

    /// 创建时间
    var createdAt: Date

    /// 习惯主题色（十六进制字符串）
    var themeColor: String

    /// 是否启用该习惯
    var isActive: Bool

    /// 排序顺序
    var sortOrder: Int

    /// 关联的习惯记录
    @Relationship(deleteRule: .cascade, inverse: \HabitRecord.habit)
    var records: [HabitRecord] = []

    /// 初始化方法
    /// - Parameters:
    ///   - title: 习惯标题（大目标）
    ///   - emoji: Emoji图标
    ///   - microHabit: 微习惯描述
    ///   - focusDuration: 专注时长（分钟）
    ///   - themeColor: 主题色
    ///   - sortOrder: 排序顺序
    init(
        title: String,
        emoji: String,
        microHabit: String,
        focusDuration: Int = 3,
        themeColor: String = "#FF6B6B",
        sortOrder: Int = 0
    ) {
        id = UUID()
        self.title = title
        self.emoji = emoji
        self.microHabit = microHabit
        self.focusDuration = focusDuration
        self.themeColor = themeColor
        self.sortOrder = sortOrder
        createdAt = Date()
        isActive = true
    }
}

// MARK: - 便利方法

extension Habit {
    /// 获取今天是否已完成该习惯
    var isCompletedToday: Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return records.contains { record in
            record.isCompleted &&
                Calendar.current.isDate(record.completedAt, inSameDayAs: today)
        }
    }

    /// 获取指定日期是否完成该习惯
    /// - Parameter date: 查询日期
    /// - Returns: 是否完成
    func isCompleted(on date: Date) -> Bool {
        let targetDay = Calendar.current.startOfDay(for: date)
        return records.contains { record in
            record.isCompleted &&
                Calendar.current.isDate(record.completedAt, inSameDayAs: targetDay)
        }
    }

    /// 获取连续完成天数
    var streakDays: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var streak = 0

        // 从今天开始往前计算连续天数
        var currentDate = today
        while true {
            if isCompleted(on: currentDate) {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }

        return streak
    }

    /// 获取总完成天数
    var totalCompletedDays: Int {
        return records.filter { $0.isCompleted }.count
    }
}

// MARK: - 示例数据

extension Habit {
    /// 创建示例习惯数据
    static func createSampleHabits() -> [Habit] {
        return [
            Habit(
                title: "骑行3公里",
                emoji: "🚴‍♂️",
                microHabit: "骑行10米",
                focusDuration: 3,
                themeColor: "#4ECDC4",
                sortOrder: 0
            ),
            Habit(
                title: "阅读30分钟",
                emoji: "📚",
                microHabit: "读1页书",
                focusDuration: 2,
                themeColor: "#45B7D1",
                sortOrder: 1
            ),
            Habit(
                title: "冥想10分钟",
                emoji: "🧘‍♀️",
                microHabit: "深呼吸3次",
                focusDuration: 1,
                themeColor: "#96CEB4",
                sortOrder: 2
            ),
            Habit(
                title: "写作500字",
                emoji: "✍️",
                microHabit: "写20字",
                focusDuration: 5,
                themeColor: "#FFEAA7",
                sortOrder: 3
            ),
        ]
    }
}
