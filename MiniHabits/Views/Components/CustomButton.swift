//
//  CustomButton.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/7.
//

import SwiftUI

/// 自定义按钮组件
/// 提供一致的交互体验和视觉反馈
struct CustomButton: View {
    let title: String
    let icon: String?
    let style: ButtonStyle
    let size: ButtonSize
    let action: () -> Void

    @State private var isPressed = false

    /// 按钮样式枚举
    enum ButtonStyle {
        case primary // 主要按钮
        case secondary // 次要按钮
        case tertiary // 三级按钮
        case destructive // 危险操作按钮
        case ghost // 幽灵按钮

        var backgroundColor: Color {
            switch self {
            case .primary:
                return DesignSystem.Colors.primary
            case .secondary:
                return DesignSystem.Colors.surfaceGray
            case .tertiary:
                return Color.clear
            case .destructive:
                return DesignSystem.Colors.error
            case .ghost:
                return Color.clear
            }
        }

        var foregroundColor: Color {
            switch self {
            case .primary, .destructive:
                return .white
            case .secondary:
                return DesignSystem.Colors.textPrimary
            case .tertiary, .ghost:
                return DesignSystem.Colors.primary
            }
        }

        var borderColor: Color {
            switch self {
            case .primary, .secondary, .destructive:
                return Color.clear
            case .tertiary, .ghost:
                return DesignSystem.Colors.primary
            }
        }

        var borderWidth: CGFloat {
            switch self {
            case .primary, .secondary, .destructive:
                return 0
            case .tertiary, .ghost:
                return 1.5
            }
        }
    }

    /// 按钮尺寸枚举
    enum ButtonSize {
        case small
        case medium
        case large

        var height: CGFloat {
            switch self {
            case .small:
                return 36
            case .medium:
                return 44
            case .large:
                return 52
            }
        }

        var horizontalPadding: CGFloat {
            switch self {
            case .small:
                return DesignSystem.Spacing.md
            case .medium:
                return DesignSystem.Spacing.lg
            case .large:
                return DesignSystem.Spacing.xl
            }
        }

        var font: Font {
            switch self {
            case .small:
                return DesignSystem.Typography.footnote
            case .medium:
                return DesignSystem.Typography.button
            case .large:
                return DesignSystem.Typography.title3
            }
        }

        var iconSize: CGFloat {
            switch self {
            case .small:
                return 14
            case .medium:
                return 16
            case .large:
                return 18
            }
        }
    }

    /// 初始化按钮
    /// - Parameters:
    ///   - title: 按钮文字
    ///   - icon: SF Symbol图标名称
    ///   - style: 按钮样式
    ///   - size: 按钮尺寸
    ///   - action: 点击事件
    init(
        _ title: String,
        icon: String? = nil,
        style: ButtonStyle = .primary,
        size: ButtonSize = .medium,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.size = size
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignSystem.Spacing.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: size.iconSize, weight: .medium))
                }

                Text(title)
                    .font(size.font)
                    .fontWeight(.semibold)
            }
            .foregroundColor(style.foregroundColor)
            .frame(height: size.height)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, size.horizontalPadding)
            .background(style.backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.small)
                    .stroke(style.borderColor, lineWidth: style.borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.small))
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .opacity(isPressed ? 0.8 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
            withAnimation(DesignSystem.Animation.quick) {
                isPressed = pressing
            }
        } perform: {
            // 长按不执行操作，只是为了获取按压状态
        }
    }
}

// MARK: - 便利构造器

extension CustomButton {
    /// 创建主要按钮
    static func primary(
        _ title: String,
        icon: String? = nil,
        size: ButtonSize = .medium,
        action: @escaping () -> Void
    ) -> CustomButton {
        CustomButton(title, icon: icon, style: .primary, size: size, action: action)
    }

    /// 创建次要按钮
    static func secondary(
        _ title: String,
        icon: String? = nil,
        size: ButtonSize = .medium,
        action: @escaping () -> Void
    ) -> CustomButton {
        CustomButton(title, icon: icon, style: .secondary, size: size, action: action)
    }

    /// 创建三级按钮
    static func tertiary(
        _ title: String,
        icon: String? = nil,
        size: ButtonSize = .medium,
        action: @escaping () -> Void
    ) -> CustomButton {
        CustomButton(title, icon: icon, style: .tertiary, size: size, action: action)
    }

    /// 创建危险按钮
    static func destructive(
        _ title: String,
        icon: String? = nil,
        size: ButtonSize = .medium,
        action: @escaping () -> Void
    ) -> CustomButton {
        CustomButton(title, icon: icon, style: .destructive, size: size, action: action)
    }

    /// 创建幽灵按钮
    static func ghost(
        _ title: String,
        icon: String? = nil,
        size: ButtonSize = .medium,
        action: @escaping () -> Void
    ) -> CustomButton {
        CustomButton(title, icon: icon, style: .ghost, size: size, action: action)
    }
}

// MARK: - 预览

#Preview("Button Showcase") {
    ScrollView {
        VStack(spacing: DesignSystem.Spacing.lg) {
            Group {
                Text("按钮样式")
                    .font(DesignSystem.Typography.title2)
                    .foregroundColor(DesignSystem.Colors.textPrimary)

                CustomButton.primary("Primary Button", icon: "star.fill") {}
                CustomButton.secondary("Secondary Button", icon: "heart") {}
                CustomButton.tertiary("Tertiary Button", icon: "plus") {}
                CustomButton.destructive("Delete", icon: "trash") {}
                CustomButton.ghost("Ghost Button", icon: "arrow.right") {}
            }

            Divider()
                .padding(.vertical, DesignSystem.Spacing.md)

            Group {
                Text("按钮尺寸")
                    .font(DesignSystem.Typography.title2)
                    .foregroundColor(DesignSystem.Colors.textPrimary)

                CustomButton.primary("Large Button", size: .large) {}
                CustomButton.primary("Medium Button", size: .medium) {}
                CustomButton.primary("Small Button", size: .small) {}
            }
        }
        .padding(DesignSystem.Spacing.pageHorizontal)
    }
    .background(DesignSystem.Colors.background)
}
