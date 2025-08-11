//
//  SettingsView.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/11.
//

import SwiftData
import SwiftUI
import UserNotifications

/// 设置页面主视图 - 极简优雅设计，符合Apple人机交互指南
struct SettingsView: View {
    let habitStore: HabitStore
    
    @State private var userSettings: UserSettings?
    @State private var isEditingNickname = false
    @State private var tempNickname = ""
    @State private var showingAbout = false
    @State private var showingPrivacy = false
    @State private var showingTerms = false
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            List {
                // 用户信息区域
                personalSection
                
                // 通知设置
                notificationSection
                
                // 应用相关
                appSection
                
                // 法律条款
                legalSection
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            loadUserSettings()
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
        .sheet(isPresented: $showingPrivacy) {
            PrivacyPolicyView()
        }
        .sheet(isPresented: $showingTerms) {
            TermsOfServiceView()
        }
    }
}

// MARK: - 视图组件

extension SettingsView {
    /// 个人信息区域
    private var personalSection: some View {
        Section {
            HStack(spacing: DesignSystem.Spacing.md) {
                // 用户头像
                Circle()
                    .fill(DesignSystem.Colors.primary)
                    .frame(width: 50, height: 50)
                    .overlay {
                        Text(userSettings?.nickname.first?.uppercased() ?? "M")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(userSettings?.nickname ?? "MiniHabits 用户")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Text("\(habitStore.habits.count) 个习惯 · 坚持 \(userSettings?.daysUsingApp ?? 1) 天")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button("编辑") {
                    startEditingNickname()
                }
                .font(.system(size: 15))
                .foregroundColor(DesignSystem.Colors.primary)
            }
            .padding(.vertical, 4)
        } header: {
            Text("用户信息")
        }
        .alert("编辑昵称", isPresented: $isEditingNickname) {
            TextField("输入新昵称", text: $tempNickname)
                .textInputAutocapitalization(.never)
            
            Button("取消", role: .cancel) {
                tempNickname = ""
            }
            
            Button("保存") {
                saveNickname()
            }
        } message: {
            Text("设置一个专属的昵称")
        }
    }
    
    /// 通知设置区域
    private var notificationSection: some View {
        Section {
            HStack {
                Image(systemName: "bell")
                    .foregroundColor(DesignSystem.Colors.primary)
                    .frame(width: 20)
                
                Text("通知提醒")
                    .font(.system(size: 17))
                
                Spacer()
                
                Toggle("", isOn: Binding(
                    get: { userSettings?.notificationEnabled ?? true },
                    set: { newValue in
                        updateNotificationSetting(newValue)
                    }
                ))
                .tint(DesignSystem.Colors.primary)
            }
        } header: {
            Text("通知设置")
        } footer: {
            Text("开启后会在适当时间提醒您完成习惯")
        }
    }
    
    /// 应用相关区域
    private var appSection: some View {
        Section {
            settingRow(
                title: "分享给朋友",
                icon: "square.and.arrow.up",
                action: shareApp
            )
            
            settingRow(
                title: "App Store 评分",
                icon: "star",
                action: rateApp
            )
            
            settingRow(
                title: "意见反馈",
                icon: "envelope",
                action: sendFeedback
            )
            
            settingRow(
                title: "关于 MiniHabits",
                icon: "info.circle",
                action: { showingAbout = true }
            )
        } header: {
            Text("应用")
        }
    }
    
    /// 法律条款区域
    private var legalSection: some View {
        Section {
            settingRow(
                title: "隐私政策",
                icon: "hand.raised",
                action: { showingPrivacy = true }
            )
            
            settingRow(
                title: "服务条款",
                icon: "doc.text",
                action: { showingTerms = true }
            )
        } header: {
            Text("法律条款")
        }
    }
    
    /// 标准设置行组件
    private func settingRow(
        title: String,
        icon: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(DesignSystem.Colors.primary)
                    .frame(width: 20)
                
                Text(title)
                    .font(.system(size: 17))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(UIColor.tertiaryLabel))
            }
        }
    }
}

// MARK: - 数据操作

extension SettingsView {
    /// 加载用户设置
    private func loadUserSettings() {
        do {
            let descriptor = FetchDescriptor<UserSettings>()
            let settings = try modelContext.fetch(descriptor)
            
            if let existingSetting = settings.first {
                userSettings = existingSetting
            } else {
                // 创建默认设置
                let newSettings = UserSettings()
                modelContext.insert(newSettings)
                try modelContext.save()
                userSettings = newSettings
            }
        } catch {
            print("加载用户设置失败: \(error)")
            // 创建默认设置作为备选
            let defaultSettings = UserSettings()
            userSettings = defaultSettings
        }
    }
    
    /// 开始编辑昵称
    private func startEditingNickname() {
        tempNickname = userSettings?.nickname ?? "MiniHabits 用户"
        isEditingNickname = true
    }
    
    /// 保存昵称
    private func saveNickname() {
        guard !tempNickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        userSettings?.updateSettings(nickname: tempNickname)
        
        do {
            try modelContext.save()
        } catch {
            print("保存昵称失败: \(error)")
        }
        
        tempNickname = ""
    }
    
    /// 更新通知设置
    private func updateNotificationSetting(_ enabled: Bool) {
        userSettings?.updateSettings(notificationEnabled: enabled)
        
        do {
            try modelContext.save()
        } catch {
            print("保存通知设置失败: \(error)")
        }
        
        // 如果开启通知，请求权限
        if enabled {
            requestNotificationPermission()
        }
    }
    
    /// 请求通知权限
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]
        ) { granted, error in
            if let error = error {
                print("通知权限请求失败: \(error)")
            }
        }
    }
    
    /// 分享应用
    private func shareApp() {
        let shareText = "发现了一个超棒的习惯养成应用 MiniHabits！通过微小的改变，让生活变得更美好 ✨"
        
        let activityController = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        // iPad 支持
        if let popover = activityController.popoverPresentationController {
            popover.sourceView = UIApplication.shared.windows.first
            popover.sourceRect = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityController, animated: true)
        }
    }
    
    /// 评分应用
    private func rateApp() {
        if let url = URL(string: "itms-apps://apps.apple.com/app/id123456789?action=write-review") {
            UIApplication.shared.open(url)
        }
    }
    
    /// 发送反馈
    private func sendFeedback() {
        if let url = URL(string: "mailto:feedback@minihabits.app?subject=MiniHabits 用户反馈&body=请在这里输入您的反馈意见...") {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: Habit.self, HabitRecord.self, UserSettings.self)
    let habitStore = HabitStore(modelContext: container.mainContext)
    
    NavigationStack {
        SettingsView(habitStore: habitStore)
    }
    .modelContainer(container)
}