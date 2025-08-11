//
//  CardView.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/7.
//

import SwiftUI

/// 通用卡片容器组件
/// 提供一致的视觉语言和交互体验
struct CardView<Content: View>: View {
    let content: Content
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let shadowColor: Color
    let shadowRadius: CGFloat
    let shadowX: CGFloat
    let shadowY: CGFloat
    let padding: EdgeInsets

    /// 初始化卡片视图
    init(
        backgroundColor: Color = DesignSystem.Colors.surfaceWhite,
        cornerRadius: CGFloat = DesignSystem.CornerRadius.medium,
        shadowColor: Color = Color.black.opacity(0.05),
        shadowRadius: CGFloat = 4,
        shadowX: CGFloat = 0,
        shadowY: CGFloat = 2,
        padding: EdgeInsets = EdgeInsets(
            top: DesignSystem.Spacing.lg,
            leading: DesignSystem.Spacing.lg,
            bottom: DesignSystem.Spacing.lg,
            trailing: DesignSystem.Spacing.lg
        ),
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.shadowX = shadowX
        self.shadowY = shadowY
        self.padding = padding
    }

    var body: some View {
        content
            .padding(padding)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(
                color: shadowColor,
                radius: shadowRadius,
                x: shadowX,
                y: shadowY
            )
    }
}

// MARK: - 预览

#Preview("Card Examples") {
    VStack(spacing: DesignSystem.Spacing.lg) {
        CardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                Text("标准卡片")
                    .font(DesignSystem.Typography.title3)
                    .foregroundColor(DesignSystem.Colors.textPrimary)

                Text("这是一个描述文本")
                    .font(DesignSystem.Typography.footnote)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
        }

        CardView(
            backgroundColor: DesignSystem.Colors.primary.opacity(0.1),
            cornerRadius: DesignSystem.CornerRadius.large,
            shadowRadius: 0
        ) {
            Text("彩色卡片")
                .font(DesignSystem.Typography.title2)
                .foregroundColor(DesignSystem.Colors.primary)
        }
    }
    .padding(DesignSystem.Spacing.pageHorizontal)
    .background(DesignSystem.Colors.background)
}
