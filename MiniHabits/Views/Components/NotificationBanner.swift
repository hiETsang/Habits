//
//  NotificationBanner.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/7.
//

import SwiftUI

/// 通知横幅组件
/// 参考图片中的黑色通知栏设计，用于显示习惯提醒和反馈
struct NotificationBanner: View {
    let message: String
    let subtitle: String?
    let icon: String?
    let backgroundColor: Color
    let onTap: (() -> Void)?
    let onDismiss: (() -> Void)?

    @State private var isVisible = true

    /// 初始化通知横幅
    /// - Parameters:
    ///   - message: 主要消息
    ///   - subtitle: 副标题（可选）
    ///   - icon: SF Symbol图标名称（可选）
    ///   - backgroundColor: 背景色
    ///   - onTap: 点击事件（可选）
    ///   - onDismiss: 关闭事件（可选）
    init(
        message: String,
        subtitle: String? = nil,
        icon: String? = nil,
        backgroundColor: Color = Color.black.opacity(0.9),
        onTap: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.message = message
        self.subtitle = subtitle
        self.icon = icon
        self.backgroundColor = backgroundColor
        self.onTap = onTap
        self.onDismiss = onDismiss
    }

    var body: some View {
        if isVisible {
            notificationContent
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal: .move(edge: .top).combined(with: .opacity)
                ))
        }
    }

    /// 通知内容
    private var notificationContent: some View {
        Button(action: onTap ?? {}) {
            HStack(spacing: DesignSystem.Spacing.md) {
                // 图标区域
                if let icon = icon {
                    iconView(icon)
                }

                // 文本区域
                textContent

                Spacer()

                // 关闭按钮
                if onDismiss != nil {
                    dismissButton
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.vertical, DesignSystem.Spacing.md)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium))
            .shadow(
                color: Color.black.opacity(0.2),
                radius: 8,
                x: 0,
                y: 4
            )
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, DesignSystem.Spacing.pageHorizontal)
    }

    /// 图标视图
    private func iconView(_ iconName: String) -> some View {
        Image(systemName: iconName)
            .font(.system(size: 20, weight: .medium))
            .foregroundColor(.white)
            .frame(width: 32, height: 32)
            .background(
                Circle()
                    .fill(Color.white.opacity(0.2))
            )
    }

    /// 文本内容
    private var textContent: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
            Text(message)
                .font(DesignSystem.Typography.callout)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .lineLimit(2)

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(DesignSystem.Typography.footnote)
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// 关闭按钮
    private var dismissButton: some View {
        Button {
            dismissNotification()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 24, height: 24)
        }
        .buttonStyle(PlainButtonStyle())
    }

    /// 关闭通知
    private func dismissNotification() {
        withAnimation(DesignSystem.Animation.standard) {
            isVisible = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onDismiss?()
        }
    }
}

// MARK: - 便利构造器

extension NotificationBanner {
    /// 创建习惯提醒通知
    static func habitReminder(
        habitName _: String,
        habitEmoji _: String,
        onTap: @escaping () -> Void,
        onDismiss: @escaping () -> Void
    ) -> NotificationBanner {
        NotificationBanner(
            message: "Notification!",
            subtitle: "Now is the time to read the book, you can change it in settings.",
            icon: "book.fill",
            backgroundColor: Color.black.opacity(0.9),
            onTap: onTap,
            onDismiss: onDismiss
        )
    }

    /// 创建成功通知
    static func success(
        message: String,
        onDismiss: @escaping () -> Void
    ) -> NotificationBanner {
        NotificationBanner(
            message: message,
            icon: "checkmark.circle.fill",
            backgroundColor: DesignSystem.Colors.success,
            onDismiss: onDismiss
        )
    }

    /// 创建错误通知
    static func error(
        message: String,
        onDismiss: @escaping () -> Void
    ) -> NotificationBanner {
        NotificationBanner(
            message: message,
            icon: "exclamationmark.triangle.fill",
            backgroundColor: DesignSystem.Colors.error,
            onDismiss: onDismiss
        )
    }

    /// 创建信息通知
    static func info(
        message: String,
        subtitle: String? = nil,
        onTap: (() -> Void)? = nil,
        onDismiss: @escaping () -> Void
    ) -> NotificationBanner {
        NotificationBanner(
            message: message,
            subtitle: subtitle,
            icon: "info.circle.fill",
            backgroundColor: DesignSystem.Colors.primary,
            onTap: onTap,
            onDismiss: onDismiss
        )
    }
}

// MARK: - 预览

#Preview("Notification Banners") {
    VStack(spacing: DesignSystem.Spacing.lg) {
        NotificationBanner.habitReminder(
            habitName: "阅读",
            habitEmoji: "📚",
            onTap: { print("Habit reminder tapped") },
            onDismiss: { print("Habit reminder dismissed") }
        )

        NotificationBanner.success(
            message: "恭喜！你完成了今天的阅读习惯"
        ) {
            print("Success dismissed")
        }

        NotificationBanner.info(
            message: "今日进度",
            subtitle: "你已完成 2/4 个习惯",
            onTap: { print("Info tapped") }
        ) {
            print("Info dismissed")
        }

        Spacer()
    }
    .padding(.top, DesignSystem.Spacing.xl)
    .background(DesignSystem.Colors.background)
}
