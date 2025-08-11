//
//  HabitRecord.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/7.
//

import Foundation
import SwiftData

/// 习惯记录数据模型
/// 记录每次习惯的执行情况
@Model
final class HabitRecord {
    /// 记录的唯一标识符
    var id: UUID

    /// 关联的习惯
    var habit: Habit?

    /// 开始时间
    var startedAt: Date

    /// 完成时间
    var completedAt: Date

    /// 实际专注时长（秒）
    var actualDuration: TimeInterval

    /// 是否完成（true: 完成, false: 取消/失败）
    var isCompleted: Bool

    /// 完成状态类型
    var status: CompletionStatus

    /// 备注信息（可选）
    var notes: String?

    /// 初始化方法
    /// - Parameters:
    ///   - habit: 关联的习惯
    ///   - startedAt: 开始时间
    ///   - completedAt: 完成时间
    ///   - actualDuration: 实际时长
    ///   - status: 完成状态
    ///   - notes: 备注
    init(
        habit: Habit?,
        startedAt: Date = Date(),
        completedAt: Date = Date(),
        actualDuration: TimeInterval = 0,
        status: CompletionStatus = .inProgress,
        notes: String? = nil
    ) {
        id = UUID()
        self.habit = habit
        self.startedAt = startedAt
        self.completedAt = completedAt
        self.actualDuration = actualDuration
        isCompleted = status == .completed
        self.status = status
        self.notes = notes
    }
}

// MARK: - 完成状态枚举

extension HabitRecord {
    /// 习惯完成状态
    enum CompletionStatus: String, CaseIterable, Codable {
        /// 进行中
        case inProgress = "in_progress"
        /// 已完成
        case completed
        /// 用户取消
        case cancelled
        /// 应用切换失败
        case failed

        /// 状态描述
        var description: String {
            switch self {
            case .inProgress:
                return "进行中"
            case .completed:
                return "已完成"
            case .cancelled:
                return "已取消"
            case .failed:
                return "已失败"
            }
        }

        /// 状态图标
        var icon: String {
            switch self {
            case .inProgress:
                return "⏳"
            case .completed:
                return "✅"
            case .cancelled:
                return "❌"
            case .failed:
                return "⚠️"
            }
        }
    }
}

// MARK: - 便利方法

extension HabitRecord {
    /// 格式化的持续时间字符串
    var formattedDuration: String {
        let minutes = Int(actualDuration) / 60
        let seconds = Int(actualDuration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    /// 是否为今天的记录
    var isToday: Bool {
        Calendar.current.isDateInToday(completedAt)
    }

    /// 格式化的完成日期
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: completedAt)
    }

    /// 标记为完成
    /// - Parameter duration: 实际完成时长
    func markAsCompleted(duration: TimeInterval) {
        completedAt = Date()
        actualDuration = duration
        status = .completed
        isCompleted = true
    }

    /// 标记为取消
    /// - Parameter reason: 取消原因
    func markAsCancelled(reason: String? = nil) {
        completedAt = Date()
        status = .cancelled
        isCompleted = false
        if let reason = reason {
            notes = reason
        }
    }

    /// 标记为失败
    /// - Parameter reason: 失败原因
    func markAsFailed(reason: String? = nil) {
        completedAt = Date()
        status = .failed
        isCompleted = false
        if let reason = reason {
            notes = reason
        }
    }
}

// MARK: - 静态方法

extension HabitRecord {
    /// 创建新的习惯记录
    /// - Parameter habit: 关联的习惯
    /// - Returns: 新的习惯记录
    static func createRecord(for habit: Habit) -> HabitRecord {
        return HabitRecord(
            habit: habit,
            startedAt: Date(),
            completedAt: Date(),
            actualDuration: 0,
            status: .inProgress
        )
    }

    /// 获取指定日期范围内的记录
    /// - Parameters:
    ///   - habit: 关联的习惯
    ///   - startDate: 开始日期
    ///   - endDate: 结束日期
    /// - Returns: 符合条件的记录数组
    static func getRecords(
        for habit: Habit,
        from startDate: Date,
        to endDate: Date
    ) -> [HabitRecord] {
        return habit.records.filter { record in
            record.completedAt >= startDate && record.completedAt <= endDate
        }.sorted { $0.completedAt > $1.completedAt }
    }
}
