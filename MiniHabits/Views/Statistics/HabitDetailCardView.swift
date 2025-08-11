//
//  HabitDetailCardView.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/7.
//

import SwiftData
import SwiftUI

/// 习惯详情卡片组件
/// 展示单个习惯的详细统计信息，包含GitHub风格的贡献图
struct HabitDetailCardView: View {
    let habit: Habit
    let habitStore: HabitStore

    @State private var selectedDate: Date?
    @State private var showingStats = false
    @State private var animateAppearance = false

    private let weeksToShow = 18
    private let daysPerWeek = 7

    var body: some View {
        CardView(
            backgroundColor: DesignSystem.Colors.surfaceWhite,
            cornerRadius: DesignSystem.CornerRadius.medium,
            shadowRadius: 4,
            shadowY: 2
        ) {
            VStack(spacing: DesignSystem.Spacing.lg) {
                // 习惯信息头部
                habitHeader

                // 贡献图区域
                contributionGraphSection

                // 统计信息
                if showingStats {
                    statisticsSection
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }
            }
        }
        .onAppear {
            withAnimation(DesignSystem.Animation.standard.delay(0.1)) {
                animateAppearance = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(DesignSystem.Animation.standard) {
                    showingStats = true
                }
            }
        }
    }
}

// MARK: - 视图组件

extension HabitDetailCardView {
    /// 习惯信息头部
    private var habitHeader: some View {
        HStack(spacing: DesignSystem.Spacing.md) {
            // Emoji 图标
            Text(habit.emoji)
                .font(.system(size: 28))
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(Color(hex: habit.themeColor).opacity(0.1))
                )
                .scaleEffect(animateAppearance ? 1.0 : 0.8)
                .animation(
                    DesignSystem.Animation.bouncy.delay(0.1),
                    value: animateAppearance
                )

            // 习惯信息
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                Text(habit.title)
                    .font(DesignSystem.Typography.title3)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .lineLimit(1)

                Text(habit.microHabit)
                    .font(DesignSystem.Typography.footnote)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .lineLimit(1)
            }

            Spacer()

            // 连续天数
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(habit.streakDays)")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: habit.themeColor))

                Text("天连击")
                    .font(DesignSystem.Typography.footnote)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
            .opacity(animateAppearance ? 1 : 0)
            .animation(
                DesignSystem.Animation.standard.delay(0.2),
                value: animateAppearance
            )
        }
    }

    /// 贡献图区域
    private var contributionGraphSection: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            // 贡献图标题
            HStack {
                Text("最近18周")
                    .font(DesignSystem.Typography.footnote)
                    .foregroundColor(DesignSystem.Colors.textSecondary)

                Spacer()

                if let selectedDate = selectedDate {
                    Text(formattedSelectedDate(selectedDate))
                        .font(DesignSystem.Typography.footnote)
                        .foregroundColor(DesignSystem.Colors.primary)
                        .transition(.opacity)
                }
            }

            // GitHub风格贡献图
            ContributionGridView(
                habit: habit,
                weeksCount: weeksToShow,
                selectedDate: $selectedDate,
                animateAppearance: animateAppearance
            )
        }
    }

    /// 统计信息区域
    private var statisticsSection: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            // 分隔线
            Rectangle()
                .fill(DesignSystem.Colors.textTertiary.opacity(0.2))
                .frame(height: 1)

            // 统计数据
            HStack(spacing: DesignSystem.Spacing.xl) {
                StatisticItem(
                    title: "总完成",
                    value: "\(habit.totalCompletedDays)",
                    color: Color(hex: habit.themeColor)
                )

                StatisticItem(
                    title: "本月完成",
                    value: "\(monthlyCompletedCount)",
                    color: DesignSystem.Colors.success
                )

                StatisticItem(
                    title: "最佳连击",
                    value: "\(bestStreakDays)",
                    color: DesignSystem.Colors.warning
                )
            }
        }
    }
}

// MARK: - 数据计算

extension HabitDetailCardView {
    /// 本月完成次数
    private var monthlyCompletedCount: Int {
        let calendar = Calendar.current
        let now = Date()
        guard let monthStart = calendar.dateInterval(of: .month, for: now)?.start,
              let monthEnd = calendar.dateInterval(of: .month, for: now)?.end
        else {
            return 0
        }

        return habit.records.filter { record in
            record.isCompleted &&
                record.completedAt >= monthStart &&
                record.completedAt < monthEnd
        }.count
    }

    /// 历史最佳连击天数
    private var bestStreakDays: Int {
        // 简化实现，返回当前连击天数
        // 在实际应用中，应该计算历史最佳连击
        return max(habit.streakDays, 0)
    }

    /// 格式化选中日期
    private func formattedSelectedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: date)
    }
}

// MARK: - 统计项组件

private struct StatisticItem: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xs) {
            Text(value)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(color)

            Text(title)
                .font(DesignSystem.Typography.footnote)
                .foregroundColor(DesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - GitHub风格贡献图

private struct ContributionGridView: View {
    let habit: Habit
    let weeksCount: Int
    @Binding var selectedDate: Date?
    let animateAppearance: Bool

    @State private var animatedCells: Set<String> = []

    private let cellSize: CGFloat = 12
    private let cellSpacing: CGFloat = 2

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
            // 月份标签
            ScrollView(.horizontal, showsIndicators: false) {
                monthLabels
            }

            // 贡献图网格
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: cellSpacing) {
                    // 星期标签
                    weekdayLabels

                    // 日期网格
                    LazyHGrid(rows: weekdayRows, spacing: cellSpacing) {
                        ForEach(dateRange, id: \.self) { date in
                            contributionCell(for: date)
                        }
                    }
                }
            }
        }
        .onAppear {
            startCellAnimations()
        }
    }

    /// 月份标签
    private var monthLabels: some View {
        HStack(spacing: 0) {
            Spacer()
                .frame(width: 20) // 对齐星期标签

            HStack(spacing: 0) {
                ForEach(monthLabelData, id: \.month) { data in
                    Text(data.month)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                        .frame(width: data.width, alignment: .leading)
                }
            }

            Spacer()
        }
    }

    /// 星期标签
    private var weekdayLabels: some View {
        VStack(spacing: cellSpacing) {
            ForEach(["一", "", "三", "", "五", "", "日"], id: \.self) { day in
                Text(day)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .frame(width: 20, height: cellSize)
            }
        }
    }

    /// 星期列定义 - 每列代表一周的某一天
    private var weekdayColumns: [GridItem] {
        Array(repeating: GridItem(.fixed(cellSize), spacing: cellSpacing), count: weeksCount)
    }

    /// 星期行定义
    private var weekdayRows: [GridItem] {
        Array(repeating: GridItem(.fixed(cellSize), spacing: cellSpacing), count: 7)
    }

    /// 贡献图单元格
    private func contributionCell(for date: Date) -> some View {
        let isCompleted = habit.isCompleted(on: date)
        let cellId = "\(date.timeIntervalSince1970)"
        let isAnimated = animatedCells.contains(cellId)

        return RoundedRectangle(cornerRadius: 2)
            .fill(contributionColor(for: date, isCompleted: isCompleted))
            .frame(width: cellSize, height: cellSize)
            .scaleEffect(isAnimated ? 1.0 : 0.5)
            .opacity(isAnimated ? 1.0 : 0.3)
            .animation(
                DesignSystem.Animation.bouncy.delay(randomDelay()),
                value: isAnimated
            )
            .onTapGesture {
                selectedDate = date
            }
    }

    /// 贡献图颜色
    private func contributionColor(for date: Date, isCompleted: Bool) -> Color {
        let today = Calendar.current.startOfDay(for: Date())
        let cellDate = Calendar.current.startOfDay(for: date)

        // 未来日期显示为浅灰色
        if cellDate > today {
            return DesignSystem.Colors.textTertiary.opacity(0.1)
        }

        // 已完成日期使用习惯主题色
        if isCompleted {
            return Color(hex: habit.themeColor)
        }

        // 未完成日期显示为浅灰色
        return DesignSystem.Colors.textTertiary.opacity(0.2)
    }

    /// 日期范围
    private var dateRange: [Date] {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // 设置周一为每周的第一天
        let today = Date()

        // 先获取本周的开始日期（周一）
        guard let thisWeekStart = calendar.dateInterval(of: .weekOfYear, for: today)?.start else {
            return []
        }

        // 然后计算18周前的周一
        guard let startDate = calendar.date(byAdding: .weekOfYear, value: -(weeksCount - 1), to: thisWeekStart) else {
            return []
        }

        var dates: [Date] = []
        var currentDate = startDate

        for _ in 0 ..< (weeksCount * 7) {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }

        return dates
    }

    /// 月份标签数据
    private var monthLabelData: [(month: String, width: CGFloat)] {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // 设置周一为每周的第一天
        let formatter = DateFormatter()
        formatter.dateFormat = "M月"
        formatter.locale = Locale(identifier: "zh_CN")

        var monthData: [(String, CGFloat)] = []
        var processedMonths: Set<String> = [] // 改用String来区分年月

        let weekWidth = cellSize + cellSpacing

        for weekIndex in 0 ..< weeksCount {
            guard let weekDate = calendar.date(byAdding: .weekOfYear, value: weekIndex, to: dateRange.first ?? Date()) else { continue }

            let year = calendar.component(.year, from: weekDate)
            let month = calendar.component(.month, from: weekDate)
            let yearMonth = "\(year)-\(month)"

            if !processedMonths.contains(yearMonth) {
                processedMonths.insert(yearMonth)
                
                // 计算这个月占用的周数
                var monthWeekCount = 0
                for checkWeekIndex in weekIndex ..< weeksCount {
                    guard let checkWeekDate = calendar.date(byAdding: .weekOfYear, value: checkWeekIndex, to: dateRange.first ?? Date()) else { break }
                    let checkMonth = calendar.component(.month, from: checkWeekDate)
                    let checkYear = calendar.component(.year, from: checkWeekDate)
                    
                    if checkYear == year && checkMonth == month {
                        monthWeekCount += 1
                    } else {
                        break
                    }
                }
                
                let monthWidth = CGFloat(monthWeekCount) * weekWidth - cellSpacing
                monthData.append((formatter.string(from: weekDate), max(monthWidth, weekWidth)))
            }
        }

        return monthData
    }

    /// 开始单元格动画
    private func startCellAnimations() {
        for (index, date) in dateRange.enumerated() {
            let cellId = "\(date.timeIntervalSince1970)"

            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.02) {
                withAnimation {
                    _ = animatedCells.insert(cellId)
                }
            }
        }
    }

    /// 随机延迟
    private func randomDelay() -> Double {
        Double.random(in: 0 ... 0.3)
    }
}

#Preview {
    let habit = Habit(
        title: "阅读30分钟",
        emoji: "📚",
        microHabit: "读1页书",
        focusDuration: 5,
        themeColor: "#45B7D1"
    )

    let container = try! ModelContainer(for: Habit.self, HabitRecord.self)
    let habitStore = HabitStore(modelContext: container.mainContext)

    ScrollView {
        VStack(spacing: 16) {
            HabitDetailCardView(habit: habit, habitStore: habitStore)
        }
        .padding()
    }
    .background(DesignSystem.Colors.background)
}
