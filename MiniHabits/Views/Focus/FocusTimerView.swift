//
//  FocusTimerView.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/7.
//

import SwiftData
import SwiftUI

/// 专注倒计时视图
/// 创造沉浸式的专注体验，每个细节都旨在帮助用户进入心流状态
struct FocusTimerView: View {
    @Environment(\.dismiss) private var dismiss

    let habit: Habit
    let habitStore: HabitStore

    // 计时器状态
    @State private var timeRemaining: TimeInterval
    @State private var totalTime: TimeInterval
    @State private var timerState: TimerState = .ready
    @State private var timer: Timer?

    // UI状态
    @State private var showingCompleteSheet = false
    @State private var showingCancelAlert = false
    @State private var pulseAnimation = false
    @State private var breatheAnimation = false

    /// 计时器状态枚举
    enum TimerState {
        case ready // 准备开始
        case running // 运行中
        case paused // 暂停
        case completed // 已完成
        case cancelled // 已取消
    }

    init(habit: Habit, habitStore: HabitStore) {
        self.habit = habit
        self.habitStore = habitStore
        let duration = TimeInterval(habit.focusDuration * 60)
        _timeRemaining = State(initialValue: duration)
        _totalTime = State(initialValue: duration)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景渐变
                backgroundGradient

                // 主要内容
                VStack(spacing: 0) {
                    // 顶部信息
                    topSection

                    Spacer()

                    // 中央圆形计时器
                    timerCircle
                        .frame(width: min(geometry.size.width * 0.8, 280))

                    Spacer()

                    // 底部控制按钮
                    controlButtons

                    // 底部安全区域
                    Spacer()
                        .frame(height: 40)
                }
                .padding(.horizontal, DesignSystem.Spacing.pageHorizontal)
            }
        }
        .navigationBarHidden(true)
        .preferredColorScheme(.dark)
        .onAppear {
            startBreathingAnimation()
        }
        .onDisappear {
            cleanupTimer()
        }
        .sheet(isPresented: $showingCompleteSheet) {
            completionSheet
        }
        .alert("确认取消", isPresented: $showingCancelAlert) {
            Button("继续专注", role: .cancel) {}
            Button("取消专注", role: .destructive) {
                cancelTimer()
            }
        } message: {
            Text("确定要取消这次专注吗？你的进度将不会被保存。")
        }
    }

    /// 背景渐变
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: habit.themeColor).opacity(0.3),
                Color(hex: habit.themeColor).opacity(0.1),
                Color.black.opacity(0.8),
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        .overlay(
            // 呼吸动画背景
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(hex: habit.themeColor).opacity(0.2),
                            Color.clear,
                        ]),
                        center: .center,
                        startRadius: 50,
                        endRadius: 200
                    )
                )
                .scaleEffect(breatheAnimation ? 1.2 : 0.8)
                .opacity(breatheAnimation ? 0.3 : 0.1)
                .animation(
                    Animation.easeInOut(duration: 4.0).repeatForever(autoreverses: true),
                    value: breatheAnimation
                )
        )
    }

    /// 顶部信息区域
    private var topSection: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            // 关闭按钮
            HStack {
                Button {
                    if timerState == .running {
                        showingCancelAlert = true
                    } else {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.8))
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(.ultraThinMaterial))
                }

                Spacer()
            }

            // 习惯信息
            VStack(spacing: DesignSystem.Spacing.sm) {
                Text(habit.emoji)
                    .font(.system(size: 48))
                    .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                        value: pulseAnimation
                    )

                Text(habit.title)
                    .font(DesignSystem.Typography.title1)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Text("专注于：\(habit.microHabit)")
                    .font(DesignSystem.Typography.title3)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.top, 20)
    }

    /// 中央圆形计时器
    private var timerCircle: some View {
        ZStack {
            // 背景圆环
            Circle()
                .stroke(Color.white.opacity(0.2), lineWidth: 8)

            // 进度圆环
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: habit.themeColor),
                            Color(hex: habit.themeColor).opacity(0.6),
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)

            // 内部圆形背景
            Circle()
                .fill(.ultraThinMaterial)
                .scaleEffect(0.8)

            // 时间显示
            VStack(spacing: DesignSystem.Spacing.sm) {
                Text(timeString)
                    .font(.system(size: 48, weight: .thin, design: .monospaced))
                    .foregroundColor(.white)

                Text(stateText)
                    .font(DesignSystem.Typography.callout)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
    }

    /// 底部控制按钮
    private var controlButtons: some View {
        HStack(spacing: DesignSystem.Spacing.xl) {
            if timerState == .ready || timerState == .paused {
                // 开始/继续按钮
                Button {
                    startTimer()
                } label: {
                    Image(systemName: timerState == .ready ? "play.fill" : "play.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 64, height: 64)
                        .background(
                            Circle()
                                .fill(Color(hex: habit.themeColor))
                                .shadow(color: Color(hex: habit.themeColor).opacity(0.4), radius: 16, x: 0, y: 8)
                        )
                }
                .buttonStyle(ScaleButtonStyle())
            } else if timerState == .running {
                // 暂停按钮
                Button {
                    pauseTimer()
                } label: {
                    Image(systemName: "pause.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 64, height: 64)
                        .background(
                            Circle()
                                .fill(.ultraThinMaterial)
                        )
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
    }

    /// 完成页面
    private var completionSheet: some View {
        CompletionView(
            habit: habit,
            actualDuration: totalTime - timeRemaining,
            onSave: { notes in
                completeHabit(notes: notes)
            },
            onSkip: {
                completeHabit(notes: nil)
            }
        )
    }

    /// 当前进度（0-1）
    private var progress: Double {
        guard totalTime > 0 else { return 0 }
        return max(0, min(1, (totalTime - timeRemaining) / totalTime))
    }

    /// 时间字符串显示
    private var timeString: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    /// 状态文本
    private var stateText: String {
        switch timerState {
        case .ready:
            return "准备开始"
        case .running:
            return "专注中..."
        case .paused:
            return "已暂停"
        case .completed:
            return "完成！"
        case .cancelled:
            return "已取消"
        }
    }
}

// MARK: - 计时器逻辑

extension FocusTimerView {
    /// 开始计时器
    private func startTimer() {
        timerState = .running
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                completeTimer()
            }
        }
    }

    /// 暂停计时器
    private func pauseTimer() {
        timerState = .paused
        timer?.invalidate()
        timer = nil
    }

    /// 完成计时器
    private func completeTimer() {
        timerState = .completed
        timer?.invalidate()
        timer = nil

        // 触觉反馈
        let successFeedback = UINotificationFeedbackGenerator()
        successFeedback.notificationOccurred(.success)

        // 显示完成页面
        showingCompleteSheet = true
    }

    /// 取消计时器
    private func cancelTimer() {
        timerState = .cancelled
        timer?.invalidate()
        timer = nil
        dismiss()
    }

    /// 清理计时器
    private func cleanupTimer() {
        timer?.invalidate()
        timer = nil
    }

    /// 完成习惯
    private func completeHabit(notes _: String?) {
        guard let record = habitStore.startHabitRecord(for: habit) else { return }

        let actualDuration = totalTime - timeRemaining
        let success = habitStore.completeHabitRecord(record, duration: actualDuration)

        if success {
            dismiss()
        }
    }

    /// 开始呼吸动画
    private func startBreathingAnimation() {
        withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
            breatheAnimation = true
        }

        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            pulseAnimation = true
        }
    }
}

/// 缩放按钮样式
private struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - 预览

#Preview("Focus Timer") {
    let container = try! ModelContainer(for: Habit.self, HabitRecord.self)
    let habitStore = HabitStore(modelContext: container.mainContext)
    let sampleHabit = Habit.createSampleHabits()[0]

    FocusTimerView(habit: sampleHabit, habitStore: habitStore)
}
