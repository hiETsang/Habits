//
//  ContentView.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/7.
//

import SwiftData
import SwiftUI

/// 应用主内容视图
/// 作为应用的入口点，承载主要的导航结构
struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Habit.self, HabitRecord.self], inMemory: true)
}
