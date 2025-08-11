//
//  WeekNavigationView.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/7.
//

import SwiftUI

/// 周视图导航组件
/// 精确实现PRD中要求的周导航功能，每个细节都经过精心调制
struct WeekNavigationView: View {
    @Binding var selectedDate: Date
    @State private var currentWeekStartDate: Date = Date().startOfWeek

    private let calendar = Calendar.current

    /// 一周的日期数组
    private var weekDates: [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: currentWeekStartDate) else {
            return []
        }

        var dates: [Date] = []
        var date = weekInterval.start

        for _ in 0 ..< 7 {
            dates.append(date)
            date = calendar.date(byAdding: .day, value: 1, to: date) ?? date
        }

        return dates
    }

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            // 月份标题
            monthHeader

            // 日期选择器
            weekDatePicker
        }
    }

    /// 月份标题
    private var monthHeader: some View {
        HStack {
            Text(monthYearText)
                .font(DesignSystem.Typography.title3)
                .foregroundColor(DesignSystem.Colors.textPrimary)

            Spacer()

            // 左右切换按钮和回到今日圆点
            HStack(spacing: DesignSystem.Spacing.sm) {
                navigationButton(direction: .previous)
                todayDotButton
                navigationButton(direction: .next)
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.pageHorizontal)
    }

    /// 周日期选择器
    private var weekDatePicker: some View {
        HStack(spacing: 0) {
            ForEach(weekDates, id: \.self) { date in
                DateButton(
                    date: date,
                    isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                    isToday: calendar.isDateInToday(date)
                ) {
                    withAnimation(DesignSystem.Animation.bouncy) {
                        selectedDate = date
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.pageHorizontal)
    }

    /// 月年文本
    private var monthYearText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月 yyyy"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: selectedDate)
    }
    
    /// 当前周是否包含今天
    private var isCurrentWeekContainsToday: Bool {
        weekDates.contains { calendar.isDateInToday($0) }
    }
    
    /// 回到今天
    private func goToToday() {
        withAnimation(DesignSystem.Animation.bouncy) {
            let today = Date()
            selectedDate = today
            currentWeekStartDate = today.startOfWeek
        }
    }

    /// 导航方向
    enum NavigationDirection {
        case previous, next

        var iconName: String {
            switch self {
            case .previous: return "chevron.left"
            case .next: return "chevron.right"
            }
        }
    }

    /// 回到今日圆点按钮
    private var todayDotButton: some View {
        Button {
            goToToday()
        } label: {
            Circle()
                .fill(isCurrentWeekContainsToday ? DesignSystem.Colors.primary : DesignSystem.Colors.textTertiary)
                .frame(width: 8, height: 8)
                .frame(width: 32, height: 32) // 保持与左右按钮相同的点击区域
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    /// 导航按钮
    private func navigationButton(direction: NavigationDirection) -> some View {
        Button {
            navigateWeek(direction: direction)
        } label: {
            Image(systemName: direction.iconName)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(DesignSystem.Colors.surfaceGray)
                )
        }
        .buttonStyle(ScaleButtonStyle())
    }

    /// 切换周
    private func navigateWeek(direction: NavigationDirection) {
        withAnimation(DesignSystem.Animation.standard) {
            let weekOffset = direction == .next ? 1 : -1
            if let newDate = calendar.date(byAdding: .weekOfYear, value: weekOffset, to: currentWeekStartDate) {
                currentWeekStartDate = newDate

                // 如果选中的日期不在新的周范围内，自动选择周一
                let newWeekDates = weekDates
                if !newWeekDates.contains(where: { calendar.isDate($0, inSameDayAs: selectedDate) }) {
                    selectedDate = newWeekDates.first ?? selectedDate
                }
            }
        }
    }
}

/// 日期按钮组件
private struct DateButton: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let action: () -> Void

    private let calendar = Calendar.current

    var body: some View {
        Button(action: action) {
            VStack(spacing: DesignSystem.Spacing.xs) {
                // 星期几
                Text(weekdayText)
                    .font(DesignSystem.Typography.footnote)
                    .foregroundColor(textColor)

                // 日期数字
                Text(dayText)
                    .font(DesignSystem.Typography.title3)
                    .fontWeight(isSelected ? .bold : .medium)
                    .foregroundColor(textColor)
            }
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                    .fill(backgroundColor)
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }

    /// 星期几文本
    private var weekdayText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        formatter.locale = Locale(identifier: "zh_CN")
        let weekday = formatter.string(from: date)
        return weekday.replacingOccurrences(of: "周", with: "")
    }

    /// 日期数字文本
    private var dayText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: date)
    }

    /// 背景色
    private var backgroundColor: Color {
        if isSelected {
            return DesignSystem.Colors.primary
        } else if isToday {
            return DesignSystem.Colors.primary.opacity(0.1)
        } else {
            return Color.clear
        }
    }

    /// 文本颜色
    private var textColor: Color {
        if isSelected {
            return .white
        } else if isToday {
            return DesignSystem.Colors.primary
        } else {
            return DesignSystem.Colors.textSecondary
        }
    }
}

/// 缩放按钮样式
private struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(DesignSystem.Animation.quick, value: configuration.isPressed)
    }
}

// MARK: - Date 扩展

extension Date {
    /// 获取周的开始日期（周一）
    var startOfWeek: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components) ?? self
    }
}

// MARK: - 预览

#Preview("Week Navigation") {
    VStack {
        WeekNavigationView(selectedDate: .constant(Date()))

        Spacer()
    }
    .background(DesignSystem.Colors.background)
}
