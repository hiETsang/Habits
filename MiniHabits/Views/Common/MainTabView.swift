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
                Label(Tab.home.title, systemImage: Tab.home.icon)
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
                Label(Tab.statistics.title, systemImage: Tab.statistics.icon)
            }
            .tag(Tab.statistics)

            // MARK: - 设置Tab
            NavigationStack {
                if let habitStore = habitStore {
                    SettingsView(habitStore: habitStore)
                } else {
                    LoadingView()
                }
            }
            .tabItem {
                Label(Tab.settings.title, systemImage: Tab.settings.icon)
            }
            .tag(Tab.settings)
        }
        .tint(DesignSystem.Colors.primary)
        .onAppear {
            initializeHabitStore()
        }
    }

    /// 初始化习惯数据管理器
    private func initializeHabitStore() {
        habitStore = HabitStore(modelContext: modelContext)
    }
}

// MARK: - 临时页面视图


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
        let weekdays = ["一", "", "三", "", "五", "", "日"]
        return index < weekdays.count ? weekdays[index] : ""
    }
}

// MARK: - 预览

#Preview("Main Tab View") {
    MainTabView()
        .modelContainer(for: [Habit.self, HabitRecord.self], inMemory: true)
}
