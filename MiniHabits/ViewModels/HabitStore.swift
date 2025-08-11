//
//  HabitStore.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/7.
//

import Foundation
import SwiftData
import SwiftUI

/// 习惯数据管理类
/// 负责习惯和记录的CRUD操作，遵循MVVM架构中的ViewModel角色
@Observable
final class HabitStore {
    /// SwiftData模型上下文
    private var modelContext: ModelContext

    /// 当前选中的日期
    var selectedDate: Date = .init()

    /// 所有活跃的习惯
    private(set) var habits: [Habit] = []

    /// 是否正在加载数据
    private(set) var isLoading: Bool = false

    /// 错误信息
    private(set) var errorMessage: String?

    /// 初始化方法
    /// - Parameter modelContext: SwiftData模型上下文
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadHabits()
    }
}

// MARK: - 数据加载

extension HabitStore {
    /// 加载所有习惯
    func loadHabits() {
        isLoading = true
        errorMessage = nil

        do {
            let descriptor = FetchDescriptor<Habit>(
                predicate: #Predicate { $0.isActive == true },
                sortBy: [SortDescriptor(\.sortOrder, order: .forward)]
            )
            habits = try modelContext.fetch(descriptor)
            isLoading = false
        } catch {
            errorMessage = "加载习惯数据失败: \(error.localizedDescription)"
            isLoading = false
        }
    }

    /// 刷新数据
    func refresh() {
        loadHabits()
    }
}

// MARK: - 习惯管理

extension HabitStore {
    /// 创建新习惯
    /// - Parameter habit: 要创建的习惯
    /// - Returns: 创建是否成功
    @discardableResult
    func createHabit(_ habit: Habit) -> Bool {
        do {
            // 设置排序顺序
            habit.sortOrder = habits.count

            modelContext.insert(habit)
            try modelContext.save()

            // 重新加载数据
            loadHabits()
            return true
        } catch {
            errorMessage = "创建习惯失败: \(error.localizedDescription)"
            return false
        }
    }

    /// 更新习惯
    /// - Parameter habit: 要更新的习惯
    /// - Returns: 更新是否成功
    @discardableResult
    func updateHabit(_: Habit) -> Bool {
        do {
            try modelContext.save()
            loadHabits()
            return true
        } catch {
            errorMessage = "更新习惯失败: \(error.localizedDescription)"
            return false
        }
    }

    /// 删除习惯
    /// - Parameter habit: 要删除的习惯
    /// - Returns: 删除是否成功
    @discardableResult
    func deleteHabit(_ habit: Habit) -> Bool {
        do {
            modelContext.delete(habit)
            try modelContext.save()
            loadHabits()
            return true
        } catch {
            errorMessage = "删除习惯失败: \(error.localizedDescription)"
            return false
        }
    }

    /// 软删除习惯（设置为非活跃状态）
    /// - Parameter habit: 要软删除的习惯
    /// - Returns: 删除是否成功
    @discardableResult
    func archiveHabit(_ habit: Habit) -> Bool {
        habit.isActive = false
        return updateHabit(habit)
    }

    /// 重新排序习惯
    /// - Parameter habits: 重新排序后的习惯数组
    func reorderHabits(_ habits: [Habit]) {
        for (index, habit) in habits.enumerated() {
            habit.sortOrder = index
        }

        do {
            try modelContext.save()
            loadHabits()
        } catch {
            errorMessage = "重新排序失败: \(error.localizedDescription)"
        }
    }
}

// MARK: - 习惯记录管理

extension HabitStore {
    /// 开始习惯打卡
    /// - Parameter habit: 要打卡的习惯
    /// - Returns: 创建的习惯记录
    func startHabitRecord(for habit: Habit) -> HabitRecord? {
        // 检查今天是否已经完成
        if habit.isCompletedToday {
            errorMessage = "今天已经完成了这个习惯"
            return nil
        }

        let record = HabitRecord.createRecord(for: habit)

        do {
            modelContext.insert(record)
            try modelContext.save()
            return record
        } catch {
            errorMessage = "创建习惯记录失败: \(error.localizedDescription)"
            return nil
        }
    }

    /// 完成习惯打卡
    /// - Parameters:
    ///   - record: 要完成的记录
    ///   - duration: 实际完成时长
    /// - Returns: 完成是否成功
    @discardableResult
    func completeHabitRecord(_ record: HabitRecord, duration: TimeInterval) -> Bool {
        record.markAsCompleted(duration: duration)

        do {
            try modelContext.save()
            loadHabits() // 刷新习惯状态
            return true
        } catch {
            errorMessage = "完成习惯记录失败: \(error.localizedDescription)"
            return false
        }
    }

    /// 取消习惯打卡
    /// - Parameters:
    ///   - record: 要取消的记录
    ///   - reason: 取消原因
    /// - Returns: 取消是否成功
    @discardableResult
    func cancelHabitRecord(_ record: HabitRecord, reason: String? = nil) -> Bool {
        record.markAsCancelled(reason: reason)

        do {
            try modelContext.save()
            return true
        } catch {
            errorMessage = "取消习惯记录失败: \(error.localizedDescription)"
            return false
        }
    }

    /// 标记习惯记录为失败
    /// - Parameters:
    ///   - record: 要标记失败的记录
    ///   - reason: 失败原因
    /// - Returns: 标记是否成功
    @discardableResult
    func failHabitRecord(_ record: HabitRecord, reason: String? = nil) -> Bool {
        record.markAsFailed(reason: reason)

        do {
            try modelContext.save()
            return true
        } catch {
            errorMessage = "标记失败状态失败: \(error.localizedDescription)"
            return false
        }
    }
}

// MARK: - 数据查询

extension HabitStore {
    /// 获取指定日期的所有习惯完成状态
    /// - Parameter date: 查询日期
    /// - Returns: 习惯ID和完成状态的字典
    func getHabitsCompletionStatus(for date: Date) -> [UUID: Bool] {
        var status: [UUID: Bool] = [:]

        for habit in habits {
            status[habit.id] = habit.isCompleted(on: date)
        }

        return status
    }

    /// 获取指定日期范围内的习惯记录
    /// - Parameters:
    ///   - startDate: 开始日期
    ///   - endDate: 结束日期
    /// - Returns: 习惯记录数组
    func getRecords(from startDate: Date, to endDate: Date) -> [HabitRecord] {
        do {
            let descriptor = FetchDescriptor<HabitRecord>(
                predicate: #Predicate { record in
                    record.completedAt >= startDate && record.completedAt <= endDate
                },
                sortBy: [SortDescriptor(\.completedAt, order: .reverse)]
            )
            return try modelContext.fetch(descriptor)
        } catch {
            errorMessage = "获取习惯记录失败: \(error.localizedDescription)"
            return []
        }
    }

    /// 获取今天已完成的习惯数量
    var todayCompletedCount: Int {
        return habits.filter { $0.isCompletedToday }.count
    }

    /// 获取本周完成统计
    /// - Returns: 本周每天的完成数量（周一到周日）
    func getWeeklyCompletionStats() -> [Int] {
        let calendar = Calendar.current
        let today = Date()

        // 获取本周的开始日期（周一）
        guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: today)?.start else {
            return Array(repeating: 0, count: 7)
        }

        var weekStats: [Int] = []

        for dayOffset in 0 ..< 7 {
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: weekStart) else {
                weekStats.append(0)
                continue
            }

            let dayCompletedCount = habits.filter { habit in
                habit.isCompleted(on: date)
            }.count

            weekStats.append(dayCompletedCount)
        }

        return weekStats
    }
}

// MARK: - 便利方法

extension HabitStore {
    /// 清除错误信息
    func clearError() {
        errorMessage = nil
    }

    /// 检查是否可以添加新习惯（最多4个）
    var canAddNewHabit: Bool {
        return habits.count < 4
    }

    /// 根据模板创建习惯
    /// - Parameter template: 习惯模板
    /// - Returns: 创建是否成功
    @discardableResult
    func createHabit(from template: HabitTemplate) -> Bool {
        let habit = template.createHabit()
        return createHabit(habit)
    }
}
