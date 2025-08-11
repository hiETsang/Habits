//
//  HabitCardView.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/7.
//

import SwiftUI

/// 习惯卡片视图
/// 实现PRD中精确定义的卡片设计，每个元素的位置都经过精心计算
struct HabitCardView: View {
    let habit: Habit
    let isCompleted: Bool
    let onTap: () -> Void
    let onEdit: () -> Void
    let onMarkComplete: () -> Void
    let onDelete: () -> Void

    @State private var isPressed = false

    var body: some View {
        cardContent
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large))
            .shadow(
                color: shadowColor,
                radius: isPressed ? 2 : 8,
                x: 0,
                y: isPressed ? 1 : 4
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .onTapGesture {
                onTap()
            }
            .contextMenu {
                contextMenuContent
            }
            .aspectRatio(DesignSystem.Grid.cardAspectRatio, contentMode: .fit)
    }

    /// 上下文菜单内容
    @ViewBuilder
    private var contextMenuContent: some View {
        if !isCompleted {
            Button {
                onMarkComplete()
            } label: {
                Label("标记完成", systemImage: "checkmark.circle")
            }
        }

        Button {
            onEdit()
        } label: {
            Label("编辑习惯", systemImage: "pencil")
        }

        Divider()

        Button(role: .destructive) {
            onDelete()
        } label: {
            Label("删除习惯", systemImage: "trash")
        }
    }

    /// 卡片内容
    private var cardContent: some View {
        VStack(spacing: 0) {
            // 顶部区域：图标和状态指示器
            topSection

            Spacer()

            // 底部区域：文字内容
            bottomSection
        }
        .padding(DesignSystem.Spacing.lg)
    }

    /// 顶部区域
    private var topSection: some View {
        HStack {
            // Emoji 图标
            Text(habit.emoji)
                .font(.system(size: 24))
                .frame(width: 32, height: 32)

            Spacer()

            // 状态指示器
            statusIndicator
        }
    }

    /// 底部区域
    private var bottomSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
            // 微习惯描述（大字体）
            Text(habit.microHabit)
                .font(DesignSystem.Typography.title3)
                .fontWeight(.semibold)
                .foregroundColor(textColor)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            // 目标提示（小字体灰色）
            Text("目标：\(habit.title)")
                .font(DesignSystem.Typography.footnote)
                .foregroundColor(DesignSystem.Colors.textSecondary.opacity(0.8))
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// 状态指示器
    private var statusIndicator: some View {
        ZStack {
            Circle()
                .fill(indicatorBackgroundColor)
                .frame(width: 24, height: 24)

            if isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }

    /// 卡片背景
    private var cardBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: backgroundColors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    /// 背景色数组
    private var backgroundColors: [Color] {
        let baseColor = Color(hex: habit.themeColor)

        if isCompleted {
            return [
                baseColor.opacity(0.15),
                baseColor.opacity(0.25),
            ]
        } else {
            return [
                baseColor.opacity(0.08),
                baseColor.opacity(0.12),
            ]
        }
    }

    /// 文字颜色
    private var textColor: Color {
        if isCompleted {
            return Color(hex: habit.themeColor)
        } else {
            return DesignSystem.Colors.textPrimary
        }
    }

    /// 指示器背景色
    private var indicatorBackgroundColor: Color {
        if isCompleted {
            return DesignSystem.Colors.success
        } else {
            return DesignSystem.Colors.textTertiary.opacity(0.3)
        }
    }

    /// 阴影颜色
    private var shadowColor: Color {
        Color(hex: habit.themeColor).opacity(isCompleted ? 0.25 : 0.1)
    }
}

/// 添加习惯卡片
struct AddHabitCardView: View {
    let onTap: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: DesignSystem.Spacing.md) {
                Image(systemName: "plus")
                    .font(.system(size: 32, weight: .light))
                    .foregroundColor(DesignSystem.Colors.textSecondary)

                Text("添加习惯")
                    .font(DesignSystem.Typography.title3)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                    .stroke(
                        DesignSystem.Colors.textTertiary.opacity(0.3),
                        style: StrokeStyle(lineWidth: 2, dash: [8, 4])
                    )
                    .background(
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                            .fill(DesignSystem.Colors.surfaceWhite)
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .opacity(isPressed ? 0.7 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
            withAnimation(DesignSystem.Animation.quick) {
                isPressed = pressing
            }
        } perform: {
            // 长按不执行操作
        }
        .aspectRatio(DesignSystem.Grid.cardAspectRatio, contentMode: .fit)
    }
}

// MARK: - 预览

#Preview("Habit Cards") {
    let sampleHabits = Habit.createSampleHabits()

    ScrollView {
        LazyVGrid(columns: DesignSystem.Grid.columns, spacing: DesignSystem.Spacing.cardSpacing) {
            ForEach(Array(sampleHabits.prefix(3).enumerated()), id: \.element.id) { index, habit in
                HabitCardView(
                    habit: habit,
                    isCompleted: index == 0, // 第一个标记为已完成
                    onTap: { print("Tapped: \(habit.title)") },
                    onEdit: { print("Edit: \(habit.title)") },
                    onMarkComplete: { print("Mark complete: \(habit.title)") },
                    onDelete: { print("Delete: \(habit.title)") }
                )
            }

            AddHabitCardView {
                print("Add habit tapped")
            }
        }
        .padding(DesignSystem.Spacing.pageHorizontal)
    }
    .background(DesignSystem.Colors.background)
}
