//
//  HomeView.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/7.
//

import SwiftData
import SwiftUI

/// 首页视图
/// 实现PRD中完整定义的首页功能，每个交互都经过精心设计
struct HomeView: View {
    var habitStore: HabitStore
    @State private var selectedDate = Date()
    @State private var selectedHabit: Habit?
    @State private var focusHabit: Habit?

    @State private var showingAddHabit = false
    @State private var notificationBanner: NotificationBanner?

    var body: some View {
        ZStack(alignment: .top) {
            // 主要内容
            mainContent

            // 通知横幅
            if let banner = notificationBanner {
                VStack {
                    banner
                    Spacer()
                }
                .zIndex(1)
            }
        }
        .background(DesignSystem.Colors.background)
        .navigationBarHidden(true)
        .refreshable {
            habitStore.refresh()
        }
        .sheet(isPresented: $showingAddHabit) {
            HabitFormView(habitStore: habitStore, editingHabit: nil)
        }
        .sheet(item: $selectedHabit) { habit in
            HabitFormView(habitStore: habitStore, editingHabit: habit)
        }
        .fullScreenCover(item: $focusHabit) { habit in
            FocusTimerView(habit: habit, habitStore: habitStore)
        }
        .onAppear {
            setupInitialData()
        }
    }

    /// 主要内容
    private var mainContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: DesignSystem.Spacing.xl) {
                // 顶部间距（为通知横幅留空间）
                Spacer()
                    .frame(height: notificationBanner != nil ? 80 : 20)

                // 顶部导航栏
                topNavigationBar

                // 周视图导航
                WeekNavigationView(selectedDate: $selectedDate)

                // 习惯列表标题
                habitSectionHeader

                // 习惯卡片网格
                habitGrid

                // 底部安全间距
                Spacer()
                    .frame(height: DesignSystem.Spacing.xxl)
            }
        }
    }

    /// 顶部导航栏
    private var topNavigationBar: some View {
        HStack {
            Text("MiniHabits")
                .font(DesignSystem.Typography.title1)
                .foregroundColor(DesignSystem.Colors.textPrimary)

            Spacer()

            Text(currentDateString)
                .font(DesignSystem.Typography.callout)
                .foregroundColor(DesignSystem.Colors.textSecondary)
        }
        .padding(.horizontal, DesignSystem.Spacing.pageHorizontal)
    }

    /// 习惯区域标题
    private var habitSectionHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                Text(sectionTitle)
                    .font(DesignSystem.Typography.title2)
                    .foregroundColor(DesignSystem.Colors.textPrimary)

                if !todayHabits.isEmpty {
                    Text(progressText)
                        .font(DesignSystem.Typography.footnote)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }
            }

            Spacer()

            if !todayHabits.isEmpty {
                Text("See all")
                    .font(DesignSystem.Typography.footnote)
                    .foregroundColor(DesignSystem.Colors.primary)
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.pageHorizontal)
    }

    /// 习惯卡片网格
    private var habitGrid: some View {
        LazyVGrid(
            columns: DesignSystem.Grid.columns,
            spacing: DesignSystem.Spacing.cardSpacing
        ) {
            // 习惯卡片
            ForEach(displayHabits) { habit in
                HabitCardView(
                    habit: habit,
                    isCompleted: habit.isCompleted(on: selectedDate),
                    onTap: {
                        handleHabitTap(habit.id)
                    },
                    onEdit: {
                        if let fullHabit = habitStore.getHabit(by: habit.id) {
                            selectedHabit = fullHabit
                        }
                    },
                    onMarkComplete: {
                        if let fullHabit = habitStore.getHabit(by: habit.id) {
                            markHabitComplete(fullHabit)
                        }
                    },
                    onDelete: {
                        if let fullHabit = habitStore.getHabit(by: habit.id) {
                            deleteHabit(fullHabit)
                        }
                    }
                )
            }

            // 添加习惯卡片（仅当习惯数量少于4个时显示）
            if habitStore.canAddNewHabit {
                AddHabitCardView {
                    showingAddHabit = true
                }
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.pageHorizontal)
    }
}

// MARK: - 数据处理

extension HomeView {
    /// 当前日期字符串
    private var currentDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月 dd YYYY"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: Date())
    }

    /// 今日习惯
    private var todayHabits: [Habit] {
        return habitStore.habits
    }

    /// 显示的习惯（最多4个）
    private var displayHabits: [Habit] {
        return Array(todayHabits.prefix(4))
    }

    /// 区域标题
    private var sectionTitle: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(selectedDate) {
            return "Tuesday habit"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            formatter.locale = Locale(identifier: "en_US")
            return "\(formatter.string(from: selectedDate)) habit"
        }
    }

    /// 进度文本
    private var progressText: String {
        let completedCount = todayHabits.filter { $0.isCompleted(on: selectedDate) }.count
        let totalCount = todayHabits.count
        return "\(completedCount)/\(totalCount) completed"
    }

    /// 设置初始数据
    private func setupInitialData() {
        // 如果没有习惯，创建示例数据
        if habitStore.habits.isEmpty {
            let sampleHabits = Habit.createSampleHabits()
            for habit in sampleHabits {
                habitStore.createHabit(habit)
            }
        }
    }

    /// 关闭通知
    private func dismissNotification() {
        withAnimation(DesignSystem.Animation.standard) {
            notificationBanner = nil
        }
    }
}

// MARK: - 交互处理

extension HomeView {
    /// 处理习惯卡片点击
    private func handleHabitTap(_ habitId: UUID) {
        // 通过ID重新获取完整的Habit对象，确保数据完整性
        if let habit = habitStore.getHabit(by: habitId) {
            print("Found habit: \(habit.title), emoji: \(habit.emoji)")
            focusHabit = habit
        } else {
            print("Habit not found for ID: \(habitId)")
        }
    }

    /// 标记习惯完成
    private func markHabitComplete(_ habit: Habit) {
        guard let record = habitStore.startHabitRecord(for: habit) else {
            showErrorNotification("无法创建习惯记录")
            return
        }

        // 模拟完成（实际应该从倒计时页面返回）
        let success = habitStore.completeHabitRecord(record, duration: TimeInterval(habit.focusDuration * 60))

        if success {
            showSuccessNotification("恭喜！你完成了今天的\(habit.title)")
        } else {
            showErrorNotification("标记完成失败")
        }
    }

    /// 删除习惯
    private func deleteHabit(_ habit: Habit) {
        let success = habitStore.deleteHabit(habit)

        if success {
            showSuccessNotification("习惯已删除")
        } else {
            showErrorNotification("删除失败")
        }
    }

    /// 显示成功通知
    private func showSuccessNotification(_ message: String) {
        withAnimation(DesignSystem.Animation.standard) {
            notificationBanner = NotificationBanner.success(message: message) {
                dismissNotification()
            }
        }

        // 3秒后自动关闭
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            dismissNotification()
        }
    }

    /// 显示错误通知
    private func showErrorNotification(_ message: String) {
        withAnimation(DesignSystem.Animation.standard) {
            notificationBanner = NotificationBanner.error(message: message) {
                dismissNotification()
            }
        }

        // 5秒后自动关闭
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            dismissNotification()
        }
    }
}

// MARK: - 预览

#Preview("Home View") {
    let container = try! ModelContainer(for: Habit.self, HabitRecord.self)
    let habitStore = HabitStore(modelContext: container.mainContext)

    HomeView(habitStore: habitStore)
        .modelContainer(container)
}
