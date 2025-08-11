//
//  NotificationToggleView.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/11.
//

import SwiftUI
import UserNotifications

/// 通知设置开关组件
/// 不仅是功能开关，更是用户与应用建立信任的桥梁
struct NotificationToggleView: View {
    @Binding var isEnabled: Bool
    
    @State private var permissionStatus: UNAuthorizationStatus = .notDetermined
    @State private var showingPermissionAlert = false
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            // 通知说明卡片
            notificationExplanationCard
            
            // 开关控制区域
            toggleControlSection
        }
        .onAppear {
            checkNotificationPermission()
        }
        .alert("需要通知权限", isPresented: $showingPermissionAlert) {
            Button("去设置") {
                openSettings()
            }
            
            Button("暂时不用", role: .cancel) {
                isEnabled = false
            }
        } message: {
            Text("为了在合适的时间提醒您，我们需要发送通知的权限。您可以随时在系统设置中修改。")
        }
    }
    
    /// 通知说明卡片
    private var notificationExplanationCard: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            // 标题和图标
            HStack(spacing: DesignSystem.Spacing.sm) {
                Image(systemName: "bell.circle.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isEnabled ? DesignSystem.Colors.primary : DesignSystem.Colors.textTertiary)
                    .animation(DesignSystem.Animation.quick, value: isEnabled)
                
                Text("智能提醒")
                    .font(DesignSystem.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
            }
            
            // 说明文字
            Text(notificationDescription)
                .font(DesignSystem.Typography.footnote)
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(DesignSystem.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                .fill(
                    isEnabled ? 
                    DesignSystem.Colors.primary.opacity(0.05) : 
                    DesignSystem.Colors.surfaceGray
                )
                .animation(DesignSystem.Animation.quick, value: isEnabled)
        )
    }
    
    /// 开关控制区域
    private var toggleControlSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                Text("推送通知")
                    .font(DesignSystem.Typography.callout)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Text(statusText)
                    .font(DesignSystem.Typography.footnote)
                    .foregroundColor(
                        isEnabled ? 
                        DesignSystem.Colors.success : 
                        DesignSystem.Colors.textSecondary
                    )
                    .animation(DesignSystem.Animation.quick, value: isEnabled)
            }
            
            Spacer()
            
            // 自定义开关
            customToggle
        }
    }
    
    /// 自定义开关组件
    private var customToggle: some View {
        ZStack {
            // 背景轨道
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    isEnabled ? 
                    DesignSystem.Colors.primary : 
                    DesignSystem.Colors.textTertiary.opacity(0.3)
                )
                .frame(width: 52, height: 32)
                .animation(DesignSystem.Animation.quick, value: isEnabled)
            
            // 滑块
            HStack {
                if isEnabled {
                    Spacer()
                }
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 28, height: 28)
                    .shadow(
                        color: Color.black.opacity(0.1),
                        radius: 2,
                        x: 0,
                        y: 1
                    )
                    .overlay {
                        if isAnimating {
                            // 涟漪动画
                            Circle()
                                .stroke(DesignSystem.Colors.primary.opacity(0.3), lineWidth: 2)
                                .scaleEffect(isAnimating ? 1.5 : 1.0)
                                .opacity(isAnimating ? 0 : 1)
                                .animation(
                                    Animation.easeOut(duration: 0.6).repeatCount(3),
                                    value: isAnimating
                                )
                        }
                    }
                
                if !isEnabled {
                    Spacer()
                }
            }
            .padding(.horizontal, 2)
        }
        .onTapGesture {
            toggleNotification()
        }
        .animation(DesignSystem.Animation.bouncy, value: isEnabled)
    }
    
    /// 通知描述文字
    private var notificationDescription: String {
        if isEnabled {
            return "已开启智能提醒，我们会在合适的时间温柔地提醒您完成习惯。您的专注时间，我们来守护。"
        } else {
            return "关闭通知后，您需要主动记住完成习惯。不过别担心，应用内的进度跟踪仍会正常工作。"
        }
    }
    
    /// 状态文字
    private var statusText: String {
        switch (isEnabled, permissionStatus) {
        case (true, .authorized):
            return "已开启，智能提醒中"
        case (true, .provisional):
            return "已开启，部分功能可用"
        case (true, .denied):
            return "需要在系统设置中开启"
        case (true, .notDetermined):
            return "等待授权中..."
        case (false, _):
            return "已关闭"
        @unknown default:
            return "状态未知"
        }
    }
}

// MARK: - 业务逻辑

extension NotificationToggleView {
    /// 检查通知权限
    private func checkNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                permissionStatus = settings.authorizationStatus
            }
        }
    }
    
    /// 切换通知设置
    private func toggleNotification() {
        // 触觉反馈
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        
        if !isEnabled {
            // 开启通知
            requestNotificationPermission()
        } else {
            // 关闭通知
            isEnabled = false
            withAnimation(DesignSystem.Animation.quick) {
                isAnimating = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isAnimating = false
            }
        }
    }
    
    /// 请求通知权限
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]
        ) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    isEnabled = true
                    permissionStatus = .authorized
                    
                    // 成功动画
                    withAnimation(DesignSystem.Animation.bouncy) {
                        isAnimating = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        isAnimating = false
                    }
                } else {
                    // 被拒绝或出错
                    permissionStatus = .denied
                    showingPermissionAlert = true
                }
            }
        }
    }
    
    /// 打开系统设置
    private func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        UIApplication.shared.open(settingsUrl)
    }
}

#Preview {
    VStack(spacing: 24) {
        NotificationToggleView(isEnabled: .constant(true))
        NotificationToggleView(isEnabled: .constant(false))
    }
    .padding()
    .background(DesignSystem.Colors.background)
}