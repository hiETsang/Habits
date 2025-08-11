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

    private var isEditing: Bool {
        editingHabit != nil
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: DesignSystem.Spacing.xl) {
                // Emoji选择
                Button {
                    showingEmojiPicker = true
                } label: {
                    ZStack {
                        Circle()
                            .fill(DesignSystem.Colors.primary.opacity(0.1))
                            .frame(width: 80, height: 80)

                        if selectedEmoji.isEmpty {
                            Image(systemName: "plus")
                                .font(.system(size: 24))
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                        } else {
                            Text(selectedEmoji)
                                .font(.system(size: 40))
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())

                // 表单字段
                VStack(spacing: DesignSystem.Spacing.lg) {
                    TextField("习惯标题", text: $habitTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("微习惯", text: $microHabit)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    VStack {
                        Text("专注时长: \(Int(focusDuration)) 分钟")
                        Slider(value: $focusDuration, in: 1 ... 30, step: 1)
                    }
                }

                // 保存按钮
                CustomButton.primary(isEditing ? "保存" : "创建") {
                    saveHabit()
                }
                .disabled(!isFormValid)

                Spacer()
            }
            .padding(DesignSystem.Spacing.pageHorizontal)
            .navigationTitle(isEditing ? "编辑习惯" : "新建习惯")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                setupForm()
            }
        }
        .sheet(isPresented: $showingEmojiPicker) {
            EmojiPickerView(selectedEmoji: $selectedEmoji)
        }
    }

    private var isFormValid: Bool {
        !habitTitle.isEmpty && !microHabit.isEmpty && !selectedEmoji.isEmpty
    }

    private func setupForm() {
        if let habit = editingHabit {
            habitTitle = habit.title
            selectedEmoji = habit.emoji
            microHabit = habit.microHabit
            focusDuration = Double(habit.focusDuration)
        }
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
