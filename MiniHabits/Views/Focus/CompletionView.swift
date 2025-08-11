//
//  CompletionView.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/7.
//

import SwiftUI

/// 完成庆祝视图
/// 让用户感受到成就的喜悦，每个动画都在强化正向反馈
struct CompletionView: View {
    let habit: Habit
    let actualDuration: TimeInterval
    let onSave: (String?) -> Void
    let onSkip: () -> Void

    @State private var notes = ""
    @State private var showingConfetti = false
    @State private var celebrationScale = 0.1
    @State private var celebrationOpacity = 0.0
    @State private var titleOffset: CGFloat = 50
    @State private var contentOffset: CGFloat = 100

    var body: some View {
        NavigationStack {
            ZStack {
                // 背景
                backgroundGradient

                // 主要内容
                ScrollView {
                    VStack(spacing: DesignSystem.Spacing.xl) {
                        Spacer()
                            .frame(height: 40)

                        // 庆祝动画区域
                        celebrationSection

                        // 统计信息
                        statsSection

                        // 笔记输入
                        notesSection

                        // 操作按钮
                        actionButtons

                        Spacer()
                            .frame(height: 40)
                    }
                    .padding(.horizontal, DesignSystem.Spacing.pageHorizontal)
                }
            }
            .navigationBarHidden(true)
            .preferredColorScheme(.dark)
            .onAppear {
                startCelebrationAnimation()
            }
        }
    }

    /// 背景渐变
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: habit.themeColor).opacity(0.4),
                Color(hex: habit.themeColor).opacity(0.2),
                Color.black.opacity(0.9),
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .overlay(
            // 星星背景
            ForEach(0 ..< 20, id: \.self) { _ in
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: CGFloat.random(in: 2 ... 6))
                    .position(
                        x: CGFloat.random(in: 0 ... UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0 ... UIScreen.main.bounds.height)
                    )
                    .opacity(showingConfetti ? 1.0 : 0.0)
                    .animation(
                        .easeInOut(duration: 2.0).delay(Double.random(in: 0 ... 1.0)),
                        value: showingConfetti
                    )
            }
        )
    }

    /// 庆祝动画区域
    private var celebrationSection: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            // 大emoji庆祝
            ZStack {
                // 背景光环
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color(hex: habit.themeColor).opacity(0.3),
                                Color.clear,
                            ]),
                            center: .center,
                            startRadius: 20,
                            endRadius: 80
                        )
                    )
                    .frame(width: 120, height: 120)
                    .scaleEffect(celebrationScale)
                    .opacity(celebrationOpacity)

                Text(habit.emoji)
                    .font(.system(size: 72))
                    .scaleEffect(celebrationScale)
                    .opacity(celebrationOpacity)
            }

            // 庆祝文字
            VStack(spacing: DesignSystem.Spacing.sm) {
                Text("🎉 太棒了！")
                    .font(DesignSystem.Typography.title1)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .offset(y: titleOffset)
                    .opacity(titleOffset == 0 ? 1.0 : 0.0)

                Text("你成功完成了\(habit.title)")
                    .font(DesignSystem.Typography.title3)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .offset(y: titleOffset)
                    .opacity(titleOffset == 0 ? 1.0 : 0.0)
            }
        }
    }

    /// 统计信息区域
    private var statsSection: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            // 本次专注时长
            StatCard(
                icon: "timer",
                title: "专注时长",
                value: formattedDuration,
                subtitle: "目标：\(habit.focusDuration)分钟",
                themeColor: habit.themeColor
            )
            .offset(y: contentOffset)
            .opacity(contentOffset == 0 ? 1.0 : 0.0)

            // 微习惯完成
            StatCard(
                icon: "checkmark.circle.fill",
                title: "微习惯",
                value: habit.microHabit,
                subtitle: "✅ 已完成",
                themeColor: habit.themeColor
            )
            .offset(y: contentOffset)
            .opacity(contentOffset == 0 ? 1.0 : 0.0)
        }
    }

    /// 笔记输入区域
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack {
                Image(systemName: "note.text")
                    .foregroundColor(.white.opacity(0.8))
                Text("记录感受 (可选)")
                    .font(DesignSystem.Typography.title3)
                    .foregroundColor(.white)
                Spacer()
            }

            TextField("今天的专注感觉如何？有什么收获吗？", text: $notes, axis: .vertical)
                .textFieldStyle(NotesTextFieldStyle())
                .lineLimit(3 ... 6)
        }
        .offset(y: contentOffset)
        .opacity(contentOffset == 0 ? 1.0 : 0.0)
    }

    /// 操作按钮
    private var actionButtons: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            // 保存按钮
            Button {
                onSave(notes.isEmpty ? nil : notes)
            } label: {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("保存完成记录")
                }
                .font(DesignSystem.Typography.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                        .fill(Color(hex: habit.themeColor))
                        .shadow(color: Color(hex: habit.themeColor).opacity(0.4), radius: 16, x: 0, y: 8)
                )
            }
            .buttonStyle(ScaleButtonStyle())

            // 跳过按钮
            Button {
                onSkip()
            } label: {
                Text("跳过记录")
                    .font(DesignSystem.Typography.callout)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .offset(y: contentOffset)
        .opacity(contentOffset == 0 ? 1.0 : 0.0)
    }

    /// 格式化的时长字符串
    private var formattedDuration: String {
        let minutes = Int(actualDuration) / 60
        let seconds = Int(actualDuration) % 60

        if minutes > 0 {
            return "\(minutes)分\(seconds)秒"
        } else {
            return "\(seconds)秒"
        }
    }

    /// 开始庆祝动画
    private func startCelebrationAnimation() {
        // 触觉反馈
        let successFeedback = UINotificationFeedbackGenerator()
        successFeedback.notificationOccurred(.success)

        // 分阶段动画
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
            celebrationScale = 1.0
            celebrationOpacity = 1.0
        }

        withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
            titleOffset = 0
        }

        withAnimation(.easeOut(duration: 0.8).delay(0.6)) {
            contentOffset = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showingConfetti = true
        }
    }
}

/// 统计卡片组件
private struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    let themeColor: String

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.lg) {
            // 图标
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Color(hex: themeColor))
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(Color(hex: themeColor).opacity(0.2))
                )

            // 内容
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                Text(title)
                    .font(DesignSystem.Typography.footnote)
                    .foregroundColor(.white.opacity(0.7))

                Text(value)
                    .font(DesignSystem.Typography.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Text(subtitle)
                    .font(DesignSystem.Typography.footnote)
                    .foregroundColor(.white.opacity(0.6))
            }

            Spacer()
        }
        .padding(DesignSystem.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                .fill(.ultraThinMaterial)
        )
    }
}

/// 笔记文本框样式
private struct NotesTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(DesignSystem.Typography.body)
            .foregroundColor(.white)
            .padding(DesignSystem.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
    }
}

/// 缩放按钮样式
private struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - 预览

#Preview("Completion View") {
    let sampleHabit = Habit.createSampleHabits()[0]

    CompletionView(
        habit: sampleHabit,
        actualDuration: 180, // 3分钟
        onSave: { notes in
            print("Saved with notes: \(notes ?? "none")")
        },
        onSkip: {
            print("Skipped notes")
        }
    )
}
