//
//  MainTabView.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/7.
//

import SwiftData
import SwiftUI

/// 主标签视图
/// 应用的核心导航容器，承载三个主要功能模块
struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    @Environment(\.modelContext) private var modelContext
    @State private var habitStore: HabitStore?

    /// Tab枚举
    enum Tab: String, CaseIterable {
        case home
        case statistics
        case settings

        var title: String {
            switch self {
            case .home:
                return "习惯"
            case .statistics:
                return "统计"
            case .settings:
                return "设置"
            }
        }

        var icon: String {
            switch self {
            case .home:
                return "house"
            case .statistics:
                return "chart.bar"
            case .settings:
                return "gear"
            }
        }

        var selectedIcon: String {
            switch self {
            case .home:
                return "house.fill"
            case .statistics:
                return "chart.bar.fill"
            case .settings:
                return "gear.fill"
            }
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            // MARK: - 首页Tab

            NavigationStack {
                if let habitStore = habitStore {
                    HomeView(habitStore: habitStore)
                } else {
                    LoadingView()
                        .onAppear {
                            initializeHabitStore()
                        }
                }
            }
            .tabItem {
                Label(Tab.home.title, systemImage: selectedTab == .home ? Tab.home.selectedIcon : Tab.home.icon)
            }
            .tag(Tab.home)

            // MARK: - 统计Tab

            NavigationStack {
                if let habitStore = habitStore {
                    StatisticsView(habitStore: habitStore)
                } else {
                    LoadingView()
                }
            }
            .tabItem {
                Label(Tab.statistics.title, systemImage: selectedTab == .statistics ? Tab.statistics.selectedIcon : Tab.statistics.icon)
            }
            .tag(Tab.statistics)

            // MARK: - 设置Tab

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label(Tab.settings.title, systemImage: selectedTab == .settings ? Tab.settings.selectedIcon : Tab.settings.icon)
            }
            .tag(Tab.settings)
        }
        .tint(DesignSystem.Colors.primary)
        .onAppear {
            setupTabBarAppearance()
        }
    }

    /// 初始化习惯数据管理器
    private func initializeHabitStore() {
        habitStore = HabitStore(modelContext: modelContext)
    }

    /// 配置TabBar外观
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground

        // 标准状态
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(DesignSystem.Colors.tabUnselected)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(DesignSystem.Colors.tabUnselected),
            .font: UIFont.systemFont(ofSize: 10, weight: .medium),
        ]

        // 选中状态
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(DesignSystem.Colors.tabSelected)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(DesignSystem.Colors.tabSelected),
            .font: UIFont.systemFont(ofSize: 10, weight: .semibold),
        ]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

// MARK: - 临时页面视图

/// 设置页面视图占位符
struct SettingsView: View {
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xl) {
            Spacer()

            Image(systemName: "gear")
                .font(.system(size: 60))
                .foregroundColor(DesignSystem.Colors.primary)

            VStack(spacing: DesignSystem.Spacing.sm) {
                Text("设置")
                    .font(DesignSystem.Typography.title1)
                    .foregroundColor(DesignSystem.Colors.textPrimary)

                Text("个性化您的体验")
                    .font(DesignSystem.Typography.callout)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }

            VStack(spacing: DesignSystem.Spacing.md) {
                CustomButton.secondary("通知设置", icon: "bell") {}
                CustomButton.secondary("主题设置", icon: "paintbrush") {}
                CustomButton.secondary("关于应用", icon: "info.circle") {}
            }

            Spacer()
        }
        .padding(DesignSystem.Spacing.pageHorizontal)
        .background(DesignSystem.Colors.background)
        .navigationTitle("设置")
        .navigationBarTitleDisplayMode(.large)
    }
}

/// 加载视图
struct LoadingView: View {
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            Image(systemName: "leaf.fill")
                .font(.system(size: 40))
                .foregroundColor(DesignSystem.Colors.primary)
                .scaleEffect(isAnimating ? 1.2 : 1.0)
                .opacity(isAnimating ? 0.6 : 1.0)
                .animation(
                    Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                    value: isAnimating
                )

            Text("加载中...")
                .font(DesignSystem.Typography.callout)
                .foregroundColor(DesignSystem.Colors.textSecondary)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - DateFormatter扩展

extension DateFormatter {
    /// 当前日期字符串
    static var currentDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月 dd日 yyyy"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: Date())
    }

    /// 获取星期几缩写
    /// - Parameter index: 星期索引 (0=周一, 6=周日)
    /// - Returns: 星期几缩写
    static func weekdayAbbreviation(for index: Int) -> String {
        let weekdays = ["一", "二", "三", "四", "五", "六", "日"]
        return index < weekdays.count ? weekdays[index] : ""
    }
}

// MARK: - 预览

#Preview("Main Tab View") {
    MainTabView()
        .modelContainer(for: [Habit.self, HabitRecord.self], inMemory: true)
}
