//
//  HabitFormView.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/7.
//

import SwiftData
import SwiftUI

struct HabitFormView: View {
    @Environment(\.dismiss) private var dismiss

    let habitStore: HabitStore
    let editingHabit: Habit?

    @State private var habitTitle = ""
    @State private var selectedEmoji = ""
    @State private var microHabit = ""
    @State private var focusDuration: Double = 3
    @State private var showingEmojiPicker = false
    @State private var showingTemplateSelection = false
    @State private var selectedTemplate: HabitTemplate?

    private var isEditing: Bool {
        editingHabit != nil
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // 顶部空间
                    Color.clear.frame(height: DesignSystem.Spacing.lg)
                    
                    // 模板选择卡片（仅新建时显示）
                    if !isEditing {
                        templateSelectionCard
                            .padding(.horizontal, DesignSystem.Spacing.pageHorizontal)
                            .padding(.bottom, DesignSystem.Spacing.xl)
                    }
                    
                    // 主表单卡片
                    mainFormCard
                        .padding(.horizontal, DesignSystem.Spacing.pageHorizontal)
                    
                    // 底部安全间距
                    Color.clear.frame(height: DesignSystem.Spacing.xxl)
                }
            }
            .background(DesignSystem.Colors.background)
            .navigationTitle(isEditing ? "编辑习惯" : "新建习惯")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "保存" : "创建") {
                        saveHabit()
                    }
                    .foregroundColor(DesignSystem.Colors.primary)
                    .fontWeight(.semibold)
                    .disabled(!isFormValid)
                }
            }
            .onAppear {
                setupForm()
            }
        }
        .sheet(isPresented: $showingEmojiPicker) {
            EmojiPickerView(selectedEmoji: $selectedEmoji)
        }
        .sheet(isPresented: $showingTemplateSelection) {
            TemplateSelectionView(selectedTemplate: $selectedTemplate)
                .onDisappear {
                    if let template = selectedTemplate {
                        applyTemplate(template)
                    }
                }
        }
    }

    private var isFormValid: Bool {
        !habitTitle.isEmpty && !microHabit.isEmpty && !selectedEmoji.isEmpty
    }
    
    /// 模板选择卡片
    private var templateSelectionCard: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            VStack(spacing: DesignSystem.Spacing.md) {
                HStack {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                        Text("快速开始")
                            .font(DesignSystem.Typography.title3)
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                        
                        Text("从习惯模板中选择，快速创建你的习惯")
                            .font(DesignSystem.Typography.footnote)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showingTemplateSelection = true
                    }) {
                        HStack(spacing: DesignSystem.Spacing.xs) {
                            Image(systemName: "square.grid.2x2")
                                .font(.system(size: 14, weight: .medium))
                            Text("选择模板")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(DesignSystem.Colors.primary)
                        .padding(.horizontal, DesignSystem.Spacing.md)
                        .padding(.vertical, DesignSystem.Spacing.sm)
                        .background(
                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                .fill(DesignSystem.Colors.primary.opacity(0.1))
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(DesignSystem.Spacing.lg)
        }
    }
    
    /// 主表单卡片
    private var mainFormCard: some View {
        CardView {
            VStack(spacing: DesignSystem.Spacing.xl) {
                // Emoji和基本信息
                emojiAndTitleSection
                
                // 分隔线
                Divider()
                    .background(DesignSystem.Colors.textTertiary.opacity(0.3))
                
                // 习惯详情
                habitDetailsSection
                
                // 专注时长
                focusDurationSection
            }
            .padding(DesignSystem.Spacing.xl)
        }
    }
    
    /// Emoji和标题区域
    private var emojiAndTitleSection: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            // Emoji选择器
            Button(action: {
                showingEmojiPicker = true
            }) {
                ZStack {
                    Circle()
                        .fill(selectedEmoji.isEmpty ? 
                              DesignSystem.Colors.surfaceGray : 
                              DesignSystem.Colors.primary.opacity(0.1))
                        .frame(width: 80, height: 80)
                    
                    if selectedEmoji.isEmpty {
                        VStack(spacing: DesignSystem.Spacing.xs) {
                            Image(systemName: "face.smiling")
                                .font(.system(size: 24, weight: .light))
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                            Text("选择表情")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                        }
                    } else {
                        Text(selectedEmoji)
                            .font(.system(size: 40))
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            // 习惯标题
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                Text("习惯名称")
                    .font(DesignSystem.Typography.footnote)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                
                TextField("输入习惯名称", text: $habitTitle)
                    .font(DesignSystem.Typography.callout)
                    .padding(DesignSystem.Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                            .fill(DesignSystem.Colors.surfaceGray)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                            .stroke(habitTitle.isEmpty ? 
                                   Color.clear : 
                                   DesignSystem.Colors.primary.opacity(0.3), lineWidth: 1)
                    )
            }
        }
    }
    
    /// 习惯详情区域
    private var habitDetailsSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text("微习惯")
                .font(DesignSystem.Typography.footnote)
                .foregroundColor(DesignSystem.Colors.textSecondary)
            
            TextField("具体要做的小动作", text: $microHabit)
                .font(DesignSystem.Typography.callout)
                .padding(DesignSystem.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                        .fill(DesignSystem.Colors.surfaceGray)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                        .stroke(microHabit.isEmpty ? 
                               Color.clear : 
                               DesignSystem.Colors.primary.opacity(0.3), lineWidth: 1)
                )
            
            Text("例如：做1个俯卧撑、读1页书、喝1杯水")
                .font(.system(size: 12))
                .foregroundColor(DesignSystem.Colors.textTertiary)
        }
    }
    
    /// 专注时长区域
    private var focusDurationSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack {
                Text("专注时长")
                    .font(DesignSystem.Typography.footnote)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                
                Spacer()
                
                Text("\(Int(focusDuration)) 分钟")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(DesignSystem.Colors.primary)
            }
            
            Slider(value: $focusDuration, in: 1...30, step: 1) {
                Text("专注时长")
            } minimumValueLabel: {
                Text("1")
                    .font(.system(size: 12))
                    .foregroundColor(DesignSystem.Colors.textTertiary)
            } maximumValueLabel: {
                Text("30")
                    .font(.system(size: 12))
                    .foregroundColor(DesignSystem.Colors.textTertiary)
            }
            .tint(DesignSystem.Colors.primary)
            
            Text("专注训练的时长，建议从短时间开始")
                .font(.system(size: 12))
                .foregroundColor(DesignSystem.Colors.textTertiary)
        }
    }

    private func setupForm() {
        if let habit = editingHabit {
            habitTitle = habit.title
            selectedEmoji = habit.emoji
            microHabit = habit.microHabit
            focusDuration = Double(habit.focusDuration)
        }
    }
    
    /// 应用模板
    private func applyTemplate(_ template: HabitTemplate) {
        habitTitle = template.title
        selectedEmoji = template.emoji
        microHabit = template.microHabit
        focusDuration = Double(template.recommendedDuration)
    }

    private func saveHabit() {
        if let editingHabit = editingHabit {
            editingHabit.title = habitTitle
            editingHabit.emoji = selectedEmoji
            editingHabit.microHabit = microHabit
            editingHabit.focusDuration = Int(focusDuration)
            _ = habitStore.updateHabit(editingHabit)
        } else {
            let habit = Habit(
                title: habitTitle,
                emoji: selectedEmoji,
                microHabit: microHabit,
                focusDuration: Int(focusDuration)
            )
            _ = habitStore.createHabit(habit)
        }
        dismiss()
    }
}

#Preview {
    let container = try! ModelContainer(for: Habit.self, HabitRecord.self)
    let habitStore = HabitStore(modelContext: container.mainContext)

    HabitFormView(habitStore: habitStore, editingHabit: nil)
}
