//
//  StatMetricView.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/7.
//

import SwiftUI

/// 统计指标显示组件
/// 用于展示单个统计数据，具有图标、数值和标题
struct StatMetricView: View {
    let title: String
    let value: String
    let color: Color
    let icon: String

    @State private var animateValue = false

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            // 图标背景
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
            }
            .scaleEffect(animateValue ? 1.0 : 0.8)
            .animation(
                DesignSystem.Animation.bouncy.delay(0.1),
                value: animateValue
            )

            // 数值
            Text(value)
                .font(DesignSystem.Typography.title2)
                .fontWeight(.bold)
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .opacity(animateValue ? 1 : 0)
                .animation(
                    DesignSystem.Animation.standard.delay(0.2),
                    value: animateValue
                )

            // 标题
            Text(title)
                .font(DesignSystem.Typography.footnote)
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .opacity(animateValue ? 1 : 0)
                .animation(
                    DesignSystem.Animation.standard.delay(0.3),
                    value: animateValue
                )
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            withAnimation {
                animateValue = true
            }
        }
    }
}

#Preview {
    HStack(spacing: 20) {
        StatMetricView(
            title: "已完成",
            value: "3",
            color: DesignSystem.Colors.success,
            icon: "checkmark.circle.fill"
        )

        StatMetricView(
            title: "总习惯",
            value: "4",
            color: DesignSystem.Colors.primary,
            icon: "target"
        )

        StatMetricView(
            title: "完成率",
            value: "75%",
            color: DesignSystem.Colors.warning,
            icon: "percent"
        )
    }
    .padding()
    .background(Color.white)
}
