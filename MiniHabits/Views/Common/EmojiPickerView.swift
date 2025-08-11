//
//  EmojiPickerView.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/7.
//

import SwiftUI

/// Emoji选择器组件
/// 为习惯选择提供丰富且有序的Emoji体验，每个分类都经过精心策划
struct EmojiPickerView: View {
    @Binding var selectedEmoji: String
    @Environment(\.dismiss) private var dismiss

    @State private var selectedCategory: EmojiCategory = .fitness
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 分类标签
                categoryTabs
                
                // Emoji网格
                emojiGrid
            }
            .navigationTitle("选择表情")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.Colors.primary)
                    .fontWeight(.semibold)
                    .disabled(selectedEmoji.isEmpty)
                }
            }
            .background(DesignSystem.Colors.background)
        }
    }


    /// 分类标签
    private var categoryTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DesignSystem.Spacing.sm) {
                ForEach(EmojiCategory.allCases, id: \.self) { category in
                    categoryTab(category)
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.pageHorizontal)
        }
        .padding(.bottom, DesignSystem.Spacing.md)
    }

    /// 分类标签按钮
    private func categoryTab(_ category: EmojiCategory) -> some View {
        Button {
            withAnimation(DesignSystem.Animation.quick) {
                selectedCategory = category
            }
        } label: {
            VStack(spacing: DesignSystem.Spacing.xs) {
                Text(category.icon)
                    .font(.system(size: 20))

                Text(category.displayName)
                    .font(DesignSystem.Typography.footnote)
                    .foregroundColor(
                        selectedCategory == category
                            ? DesignSystem.Colors.primary
                            : DesignSystem.Colors.textSecondary
                    )
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.vertical, DesignSystem.Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.small)
                    .fill(
                        selectedCategory == category
                            ? DesignSystem.Colors.primary.opacity(0.1)
                            : Color.clear
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }

    /// Emoji网格
    private var emojiGrid: some View {
        ScrollView {
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: DesignSystem.Spacing.sm), count: 6),
                spacing: DesignSystem.Spacing.md
            ) {
                ForEach(filteredEmojis, id: \.self) { emoji in
                    emojiButton(emoji)
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.pageHorizontal)
            .padding(.bottom, DesignSystem.Spacing.xxl)
        }
    }

    /// Emoji按钮
    private func emojiButton(_ emoji: String) -> some View {
        Button {
            withAnimation(DesignSystem.Animation.bouncy) {
                selectedEmoji = emoji
            }

            // 触觉反馈
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        } label: {
            Text(emoji)
                .font(.system(size: 32))
                .frame(width: 48, height: 48)
                .background(
                    Circle()
                        .fill(
                            selectedEmoji == emoji
                                ? DesignSystem.Colors.primary.opacity(0.2)
                                : Color.clear
                        )
                )
                .overlay(
                    Circle()
                        .stroke(
                            selectedEmoji == emoji
                                ? DesignSystem.Colors.primary
                                : Color.clear,
                            lineWidth: 2
                        )
                )
                .scaleEffect(selectedEmoji == emoji ? 1.1 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }

    /// 过滤后的Emoji
    private var filteredEmojis: [String] {
        let categoryEmojis = selectedCategory.emojis

        if searchText.isEmpty {
            return categoryEmojis
        } else {
            // 简单的搜索逻辑（实际应该有更复杂的匹配算法）
            return categoryEmojis.filter { _ in
                selectedCategory.searchKeywords.contains { keyword in
                    keyword.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
    }
}

// MARK: - Emoji分类

enum EmojiCategory: String, CaseIterable {
    case fitness
    case learning
    case mindfulness
    case creativity
    case health
    case social
    case productivity
    case lifestyle

    var displayName: String {
        switch self {
        case .fitness: return "运动"
        case .learning: return "学习"
        case .mindfulness: return "冥想"
        case .creativity: return "创作"
        case .health: return "健康"
        case .social: return "社交"
        case .productivity: return "效率"
        case .lifestyle: return "生活"
        }
    }

    var icon: String {
        switch self {
        case .fitness: return "💪"
        case .learning: return "📚"
        case .mindfulness: return "🧘‍♀️"
        case .creativity: return "🎨"
        case .health: return "🌱"
        case .social: return "👥"
        case .productivity: return "⚡"
        case .lifestyle: return "🏠"
        }
    }

    var emojis: [String] {
        switch self {
        case .fitness:
            return ["🏃‍♂️", "🏃‍♀️", "🚴‍♂️", "🚴‍♀️", "🏋️‍♂️", "🏋️‍♀️", "🤸‍♂️", "🤸‍♀️", "🧗‍♂️", "🧗‍♀️",
                    "🏊‍♂️", "🏊‍♀️", "🏄‍♂️", "🏄‍♀️", "⛹️‍♂️", "⛹️‍♀️", "🏆", "🥇", "💪", "🔥",
                    "⚽", "🏀", "🏈", "⚾", "🎾", "🏐", "🏓", "🏸", "🥊", "🥋"]

        case .learning:
            return ["📚", "📖", "📝", "✏️", "🖊️", "📔", "📕", "📗", "📘", "📙",
                    "📓", "🎓", "🏫", "🎒", "💻", "⌨️", "🖥️", "📱", "🔬", "🧮",
                    "📐", "📏", "🗂️", "📊", "📈", "📉", "🧠", "💡", "🔍", "🌟"]

        case .mindfulness:
            return ["🧘‍♂️", "🧘‍♀️", "🕯️", "🌸", "🌺", "🌻", "🌷", "🌹", "🌿", "🍃",
                    "🌱", "🌳", "🌲", "🏔️", "🌅", "🌄", "🌈", "☀️", "🌙", "⭐",
                    "✨", "🦋", "🕊️", "🐝", "🌊", "💧", "🔮", "🎋", "🧿", "☯️"]

        case .creativity:
            return ["🎨", "🖌️", "🖍️", "✏️", "📝", "✍️", "🎭", "🎪", "🎨", "🖼️",
                    "📷", "📸", "🎥", "🎬", "🎵", "🎶", "🎼", "🎹", "🎸", "🥁",
                    "🎺", "🎷", "🎻", "🎯", "🎲", "🧩", "🎪", "🌈", "💫", "⚡"]

        case .health:
            return ["🌱", "🥗", "🥑", "🍎", "🍊", "🍇", "🫐", "🥝", "🍓", "🍑",
                    "🥕", "🥦", "🍅", "🥒", "🌶️", "💊", "🩺", "❤️", "💚", "💧",
                    "🧴", "🧼", "🦷", "😴", "🛀", "🧘‍♂️", "🧘‍♀️", "⚖️", "🌡️", "🔋"]

        case .social:
            return ["👥", "👫", "👬", "👭", "🤝", "👋", "🤗", "💝", "🎁", "🎉",
                    "🎊", "📞", "💬", "💭", "❤️", "💕", "💖", "👨‍👩‍👧‍👦", "👨‍👨‍👧‍👦", "👩‍👩‍👧‍👦",
                    "🏠", "🏡", "🎈", "🎂", "🍽️", "☕", "🍵", "🥂", "🍻", "🎪"]

        case .productivity:
            return ["⚡", "🚀", "⏰", "⏱️", "⏲️", "📅", "📆", "🗓️", "📋", "📌",
                    "📍", "🎯", "✅", "☑️", "✔️", "📈", "📊", "💼", "🗂️", "📁",
                    "💻", "⌨️", "🖥️", "📱", "🔧", "⚙️", "🔩", "🛠️", "⛽", "🔋"]

        case .lifestyle:
            return ["🏠", "🛏️", "🛋️", "🪑", "🚿", "🧹", "🧺", "👕", "👔", "👗",
                    "🧥", "👖", "👟", "👠", "🎒", "👜", "💼", "🕶️", "⌚", "💍",
                    "🍳", "🥄", "🍽️", "☕", "🫖", "🌱", "🪴", "📺", "🎮", "📚"]
        }
    }

    var searchKeywords: [String] {
        switch self {
        case .fitness:
            return ["运动", "健身", "跑步", "骑行", "游泳", "篮球", "足球", "举重", "瑜伽"]
        case .learning:
            return ["学习", "读书", "写作", "电脑", "编程", "考试", "笔记", "思考"]
        case .mindfulness:
            return ["冥想", "放松", "花朵", "自然", "平静", "专注", "呼吸", "宁静"]
        case .creativity:
            return ["创作", "艺术", "绘画", "音乐", "摄影", "设计", "写作", "创意"]
        case .health:
            return ["健康", "水果", "蔬菜", "医疗", "营养", "维生素", "锻炼", "休息"]
        case .social:
            return ["社交", "朋友", "家庭", "聚会", "沟通", "爱情", "友谊", "团队"]
        case .productivity:
            return ["效率", "工作", "任务", "时间", "目标", "计划", "完成", "进度"]
        case .lifestyle:
            return ["生活", "家居", "穿着", "购物", "烹饪", "清洁", "装饰", "休闲"]
        }
    }
}

// MARK: - 预览

#Preview("Emoji Picker") {
    EmojiPickerView(selectedEmoji: .constant("🏃‍♂️"))
}
