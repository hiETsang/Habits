//
//  StatisticsView.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/7.
//

import SwiftData
import SwiftUI

/// 统计页面主视图
/// 展示用户的习惯完成数据，包含周统计图表和习惯详情
struct StatisticsView: View {
    let habitStore: HabitStore

    @State private var selectedDate = Date()
    @State private var showingDateRange = false
    @State private var animateAppearance = false

    var body: some View {
        ZStack {
            // 背景
            DesignSystem.Colors.background
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: DesignSystem.Spacing.xl) {
                    // 页面顶部间距
                    Color.clear.frame(height: 1)

                    // 概览统计卡片
                    overviewSection
                        .opacity(animateAppearance ? 1 : 0)
                        .offset(y: animateAppearance ? 0 : 20)
                        .animation(
                            DesignSystem.Animation.standard.delay(0.1),
                            value: animateAppearance
                        )

                    // 周统计图表
                    weeklyStatsSection
                        .opacity(animateAppearance ? 1 : 0)
                        .offset(y: animateAppearance ? 0 : 20)
                        .animation(
                            DesignSystem.Animation.standard.delay(0.2),
                            value: animateAppearance
                        )

                    // 习惯详情列表
                    if !habitStore.habits.isEmpty {
                        habitDetailsSection
                            .opacity(animateAppearance ? 1 : 0)
                            .offset(y: animateAppearance ? 0 : 20)
                            .animation(
                                DesignSystem.Animation.standard.delay(0.3),
                                value: animateAppearance
                            )
                    }

                    // 底部安全间距
                    Color.clear.frame(height: DesignSystem.Spacing.xxl)
                }
                .padding(.horizontal, DesignSystem.Spacing.pageHorizontal)
            }
        }
        .navigationTitle("统计")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            withAnimation {
                animateAppearance = true
            }
        }
        .refreshable {
            habitStore.refresh()
        }
    }
}

// MARK: - 视图组件

extension StatisticsView {
    /// 概览统计卡片
    private var overviewSection: some View {
        CardView(
            backgroundColor: DesignSystem.Colors.surfaceWhite,
            cornerRadius: DesignSystem.CornerRadius.large,
            shadowRadius: 8,
            shadowY: 2
        ) {
            VStack(spacing: DesignSystem.Spacing.lg) {
                // 标题
                HStack {
                    Text("今日概览")
                        .font(DesignSystem.Typography.title3)
                        .foregroundColor(DesignSystem.Colors.textPrimary)

                    Spacer()

                    Text(formattedDate)
                        .font(DesignSystem.Typography.footnote)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }

                // 统计数据
                HStack(spacing: DesignSystem.Spacing.xl) {
                    StatMetricView(
                        title: "已完成",
                        value: "\(todayCompletedCount)",
                        color: DesignSystem.Colors.success,
                        icon: "checkmark.circle.fill"
                    )

                    StatMetricView(
                        title: "总习惯",
                        value: "\(habitStore.habits.count)",
                        color: DesignSystem.Colors.primary,
                        icon: "target"
                    )

                    StatMetricView(
                        title: "完成率",
                        value: completionPercentage,
                        color: DesignSystem.Colors.warning,
                        icon: "percent"
                    )
                }
            }
        }
    }

    /// 周统计图表区域
    private var weeklyStatsSection: some View {
        CardView(
            backgroundColor: DesignSystem.Colors.surfaceWhite,
            cornerRadius: DesignSystem.CornerRadius.large,
            shadowRadius: 8,
            shadowY: 2
        ) {
            VStack(spacing: DesignSystem.Spacing.lg) {
                // 标题
                HStack {
                    Text("本周统计")
                        .font(DesignSystem.Typography.title3)
                        .foregroundColor(DesignSystem.Colors.textPrimary)

                    Spacer()

                    Text("已完成 \(weeklyTotalCount) 次")
                        .font(DesignSystem.Typography.footnote)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }

                // 条形图
                WeeklyStatsChartView(
                    data: weeklyStats,
                    maxValue: max(habitStore.habits.count, 1)
                )
                .frame(height: 180)
            }
        }
    }

    /// 习惯详情区域
    private var habitDetailsSection: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            // 区域标题
            HStack {
                Text("习惯详情")
                    .font(DesignSystem.Typography.title3)
                    .foregroundColor(DesignSystem.Colors.textPrimary)

                Spacer()

                Text("最近18周")
                    .font(DesignSystem.Typography.footnote)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }

            // 习惯列表
            LazyVStack(spacing: DesignSystem.Spacing.md) {
                ForEach(habitStore.habits) { habit in
                    HabitDetailCardView(habit: habit, habitStore: habitStore)
                }
            }
        }
    }
}

// MARK: - 数据计算

extension StatisticsView {
    /// 今日完成数量
    private var todayCompletedCount: Int {
        habitStore.todayCompletedCount
    }

    /// 完成率百分比
    private var completionPercentage: String {
        let total = habitStore.habits.count
        guard total > 0 else { return "0%" }
        let percentage = (todayCompletedCount * 100) / total
        return "\(percentage)%"
    }

    /// 周统计数据
    private var weeklyStats: [Int] {
        habitStore.getWeeklyCompletionStats()
    }

    /// 本周总完成次数
    private var weeklyTotalCount: Int {
        weeklyStats.reduce(0, +)
    }

    /// 格式化日期
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月dd日"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: Date())
    }
}

// MARK: - 预览

#Preview("Statistics View") {
    let container = try! ModelContainer(for: Habit.self, HabitRecord.self)
    let habitStore = HabitStore(modelContext: container.mainContext)

    NavigationStack {
        StatisticsView(habitStore: habitStore)
    }
    .modelContainer(container)
}
