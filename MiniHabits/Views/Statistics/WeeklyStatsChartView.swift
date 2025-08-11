//
//  WeeklyStatsChartView.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/7.
//

import SwiftUI

/// 周统计条形图组件
/// 展示本周每天的习惯完成情况，具有优雅的动画效果
struct WeeklyStatsChartView: View {
    let data: [Int]
    let maxValue: Int

    @State private var animatedHeights: [CGFloat] = Array(repeating: 0, count: 7)
    @State private var showLabels = false

    private let weekdays = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
    private let chartHeight: CGFloat = 120

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            // 图表区域
            HStack(alignment: .bottom, spacing: DesignSystem.Spacing.sm) {
                ForEach(0 ..< 7, id: \.self) { index in
                    chartBar(for: index)
                }
            }
            .frame(height: chartHeight)
            .padding(.horizontal, DesignSystem.Spacing.xs)

            // 分隔线
            Rectangle()
                .fill(DesignSystem.Colors.textTertiary.opacity(0.3))
                .frame(height: 1)
                .opacity(showLabels ? 1 : 0)
                .animation(
                    DesignSystem.Animation.standard.delay(0.8),
                    value: showLabels
                )

            // 星期标签
            HStack(spacing: DesignSystem.Spacing.sm) {
                ForEach(0 ..< 7, id: \.self) { index in
                    Text(weekdays[index])
                        .font(DesignSystem.Typography.footnote)
                        .foregroundColor(
                            isToday(index) ? DesignSystem.Colors.primary : DesignSystem.Colors.textSecondary
                        )
                        .fontWeight(isToday(index) ? .semibold : .regular)
                        .frame(maxWidth: .infinity)
                        .opacity(showLabels ? 1 : 0)
                        .animation(
                            DesignSystem.Animation.standard.delay(0.9 + Double(index) * 0.05),
                            value: showLabels
                        )
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.xs)
        }
        .onAppear {
            startAnimations()
        }
    }

    /// 创建单个条形图柱
    private func chartBar(for index: Int) -> some View {
        let value = index < data.count ? data[index] : 0
        let normalizedHeight = maxValue > 0 ? CGFloat(value) / CGFloat(maxValue) : 0
        _ = max(normalizedHeight * chartHeight, value > 0 ? 8 : 0) // 最小高度8pt

        return VStack(spacing: DesignSystem.Spacing.xs) {
            // 数值标签
            if value > 0 {
                Text("\(value)")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .opacity(showLabels ? 1 : 0)
                    .animation(
                        DesignSystem.Animation.standard.delay(1.0 + Double(index) * 0.05),
                        value: showLabels
                    )
            } else {
                Spacer()
                    .frame(height: 15) // 保持对齐
            }

            // 条形柱
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.small)
                .fill(barGradient(for: index, value: value))
                .frame(height: animatedHeights[index])
                .frame(maxWidth: .infinity)
                .overlay(
                    // 高光效果
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.small)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.3), Color.clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .opacity(value > 0 ? 1 : 0)
                )
        }
    }

    /// 获取条形图渐变色
    private func barGradient(for index: Int, value: Int) -> LinearGradient {
        let baseColor = isToday(index) ? DesignSystem.Colors.primary : DesignSystem.Colors.success
        let lightColor = baseColor.opacity(0.7)
        let darkColor = baseColor

        if value == 0 {
            return LinearGradient(
                colors: [DesignSystem.Colors.textTertiary.opacity(0.2)],
                startPoint: .top,
                endPoint: .bottom
            )
        }

        return LinearGradient(
            colors: [lightColor, darkColor],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    /// 检查是否为今天
    private func isToday(_ index: Int) -> Bool {
        let calendar = Calendar.current
        let today = Date()
        guard calendar.dateInterval(of: .weekOfYear, for: today)?.start != nil else {
            return false
        }

        let todayWeekday = calendar.component(.weekday, from: today)
        let mondayBasedIndex = (todayWeekday == 1) ? 6 : todayWeekday - 2 // 转换为周一开始的索引

        return index == mondayBasedIndex
    }

    /// 开始动画序列
    private func startAnimations() {
        // 条形图高度动画
        for index in 0 ..< 7 {
            let value = index < data.count ? data[index] : 0
            let normalizedHeight = maxValue > 0 ? CGFloat(value) / CGFloat(maxValue) : 0
            let targetHeight = max(normalizedHeight * chartHeight, value > 0 ? 8 : 0)

            withAnimation(
                DesignSystem.Animation.bouncy.delay(Double(index) * 0.1)
            ) {
                animatedHeights[index] = targetHeight
            }
        }

        // 标签显示动画
        withAnimation(
            DesignSystem.Animation.standard.delay(0.7)
        ) {
            showLabels = true
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        WeeklyStatsChartView(
            data: [2, 3, 1, 4, 2, 0, 1],
            maxValue: 4
        )
        .padding()
        .background(Color.white)
        .cornerRadius(12)

        WeeklyStatsChartView(
            data: [0, 0, 0, 0, 0, 0, 0],
            maxValue: 4
        )
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
