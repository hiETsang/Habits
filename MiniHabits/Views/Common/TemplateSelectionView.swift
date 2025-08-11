//
//  TemplateSelectionView.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/7.
//

import SwiftUI

/// 模板选择视图
/// 提供精心策划的习惯模板，降低用户创建习惯的门槛
struct TemplateSelectionView: View {
    @Binding var selectedTemplate: HabitTemplate?
    @Environment(\.dismiss) private var dismiss

    @State private var selectedCategory: HabitTemplate.Category = .fitness

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 顶部描述
                headerSection

                // 分类选择
                categorySelector

                // 模板列表
                templateList
            }
            .navigationTitle("选择模板")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CustomButton.tertiary("取消", size: .small) {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    CustomButton.primary("自定义", size: .small) {
                        selectedTemplate = nil
                        dismiss()
                    }
                }
            }
            .background(DesignSystem.Colors.background)
        }
    }

    /// 顶部描述区域
    private var headerSection: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            Text("快速开始")
                .font(DesignSystem.Typography.title2)
                .foregroundColor(DesignSystem.Colors.textPrimary)

            Text("选择一个预设模板，或者创建自定义习惯")
                .font(DesignSystem.Typography.callout)
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, DesignSystem.Spacing.pageHorizontal)
        .padding(.vertical, DesignSystem.Spacing.xl)
    }

    /// 分类选择器
    private var categorySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DesignSystem.Spacing.md) {
                ForEach(HabitTemplate.Category.allCases, id: \.self) { category in
                    categoryButton(category)
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.pageHorizontal)
        }
        .padding(.bottom, DesignSystem.Spacing.lg)
    }

    /// 分类按钮
    private func categoryButton(_ category: HabitTemplate.Category) -> some View {
        Button {
            withAnimation(DesignSystem.Animation.standard) {
                selectedCategory = category
            }
        } label: {
            VStack(spacing: DesignSystem.Spacing.xs) {
                Text(category.icon)
                    .font(.system(size: 24))

                Text(category.displayName)
                    .font(DesignSystem.Typography.footnote)
                    .fontWeight(selectedCategory == category ? .semibold : .medium)
                    .foregroundColor(
                        selectedCategory == category
                            ? DesignSystem.Colors.primary
                            : DesignSystem.Colors.textSecondary
                    )
            }
            .frame(width: 80, height: 64)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                    .fill(
                        selectedCategory == category
                            ? DesignSystem.Colors.primary.opacity(0.1)
                            : DesignSystem.Colors.surfaceWhite
                    )
                    .shadow(
                        color: selectedCategory == category
                            ? DesignSystem.Colors.primary.opacity(0.2)
                            : Color.black.opacity(0.05),
                        radius: selectedCategory == category ? 8 : 2,
                        x: 0,
                        y: selectedCategory == category ? 4 : 1
                    )
            )
            .scaleEffect(selectedCategory == category ? 1.02 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }

    /// 模板列表
    private var templateList: some View {
        ScrollView {
            LazyVStack(spacing: DesignSystem.Spacing.md) {
                ForEach(filteredTemplates, id: \.id) { template in
                    TemplateCard(
                        template: template,
                        onSelect: {
                            selectedTemplate = template
                            dismiss()
                        }
                    )
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.pageHorizontal)
            .padding(.bottom, DesignSystem.Spacing.xxl)
        }
    }

    /// 过滤后的模板
    private var filteredTemplates: [HabitTemplate] {
        HabitTemplate.templates(for: selectedCategory)
    }
}

/// 模板卡片组件
private struct TemplateCard: View {
    let template: HabitTemplate
    let onSelect: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: DesignSystem.Spacing.lg) {
                // 左侧图标
                iconSection

                // 中间内容
                contentSection

                // 右侧箭头
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(DesignSystem.Colors.textTertiary)
            }
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.vertical, DesignSystem.Spacing.lg)
            .background(templateBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large))
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .shadow(
                color: themeColor.opacity(0.2),
                radius: isPressed ? 4 : 8,
                x: 0,
                y: isPressed ? 2 : 4
            )
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
            withAnimation(DesignSystem.Animation.quick) {
                isPressed = pressing
            }
        } perform: {
            // 长按不执行操作
        }
    }

    /// 图标区域
    private var iconSection: some View {
        VStack(spacing: DesignSystem.Spacing.xs) {
            Text(template.emoji)
                .font(.system(size: 32))

            Text(template.name)
                .font(DesignSystem.Typography.footnote)
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .lineLimit(1)
        }
        .frame(width: 60)
    }

    /// 内容区域
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            // 主标题
            Text(template.title)
                .font(DesignSystem.Typography.title3)
                .fontWeight(.semibold)
                .foregroundColor(themeColor)
                .lineLimit(1)

            // 微习惯描述
            Text("从「\(template.microHabit)」开始")
                .font(DesignSystem.Typography.callout)
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .lineLimit(1)

            // 时长信息
            HStack(spacing: DesignSystem.Spacing.xs) {
                Image(systemName: "clock")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(DesignSystem.Colors.textSecondary)

                Text("\(template.recommendedDuration) 分钟专注")
                    .font(DesignSystem.Typography.footnote)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }

            // 描述
            if !template.description.isEmpty {
                Text(template.description)
                    .font(DesignSystem.Typography.footnote)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// 模板背景
    private var templateBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                themeColor.opacity(0.08),
                themeColor.opacity(0.12),
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    /// 主题色
    private var themeColor: Color {
        Color(hex: template.themeColor)
    }
}

// MARK: - 预览

#Preview("Template Selection") {
    TemplateSelectionView(selectedTemplate: .constant(nil))
}

#Preview("Template Card") {
    VStack(spacing: DesignSystem.Spacing.lg) {
        TemplateCard(
            template: HabitTemplate.allTemplates[0],
            onSelect: { print("Template selected") }
        )

        TemplateCard(
            template: HabitTemplate.allTemplates[1],
            onSelect: { print("Template selected") }
        )
    }
    .padding(DesignSystem.Spacing.pageHorizontal)
    .background(DesignSystem.Colors.background)
}
