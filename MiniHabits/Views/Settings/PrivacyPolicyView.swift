//
//  PrivacyPolicyView.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/11.
//

import SwiftUI

/// 隐私政策页面
/// 透明地展示我们如何保护用户隐私
struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var animateContent = false
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: DesignSystem.Spacing.xl) {
                        // 顶部间距
                        Color.clear.frame(height: DesignSystem.Spacing.md)
                        
                        // 概述
                        policySection(
                            title: "隐私保护承诺",
                            icon: "shield.checkered",
                            content: """
                            MiniHabits 深知隐私的重要性。我们承诺：
                            
                            • 您的个人数据完全存储在您的设备上
                            • 我们不会收集、存储或分享您的个人信息
                            • 所有习惯数据仅在您的设备本地处理
                            • 不会有任何数据传输到我们的服务器
                            """
                        )
                        
                        // 数据收集
                        policySection(
                            title: "数据收集说明",
                            icon: "doc.text",
                            content: """
                            我们收集的信息类型：
                            
                            1. 个人信息
                            • 您设置的昵称（仅存储在本地）
                            • 习惯数据和完成记录（仅存储在本地）
                            
                            2. 使用统计
                            • 我们不收集任何使用统计信息
                            • 不使用第三方分析服务
                            
                            3. 设备信息
                            • 仅用于优化应用性能，不会传输
                            """
                        )
                        
                        // 数据使用
                        policySection(
                            title: "数据使用方式",
                            icon: "gear",
                            content: """
                            您的数据如何被使用：
                            
                            • 提供核心的习惯跟踪功能
                            • 生成个人进度统计和可视化
                            • 发送本地通知提醒（如果您开启）
                            • 同步数据到您的其他设备（通过 iCloud）
                            
                            我们绝不会：
                            • 将您的数据出售给第三方
                            • 用于广告目的
                            • 进行数据挖掘或分析
                            """
                        )
                        
                        // 数据安全
                        policySection(
                            title: "数据安全保障",
                            icon: "lock.shield",
                            content: """
                            我们如何保护您的数据：
                            
                            • 所有数据使用设备级加密存储
                            • 利用 iOS 系统的安全特性
                            • 不存在数据泄露风险（因为没有服务器）
                            • 遵循苹果的安全和隐私准则
                            """
                        )
                        
                        // 用户权利
                        policySection(
                            title: "您的权利",
                            icon: "person.crop.circle",
                            content: """
                            您对自己的数据拥有完全控制权：
                            
                            • 随时删除应用以清除所有数据
                            • 通过设置控制通知和其他功能
                            • 数据完全属于您，无需担心隐私问题
                            • 可以通过 iCloud 备份和恢复数据
                            """
                        )
                        
                        // 联系方式
                        policySection(
                            title: "联系我们",
                            icon: "envelope",
                            content: """
                            如果您对隐私政策有任何疑问：
                            
                            • 邮箱：privacy@minihabits.app
                            • 我们承诺在 24 小时内回复您的询问
                            
                            本隐私政策最后更新：2025年8月11日
                            """
                        )
                        
                        // 底部间距
                        Color.clear.frame(height: DesignSystem.Spacing.xxl)
                    }
                    .padding(.horizontal, DesignSystem.Spacing.pageHorizontal)
                }
            }
            .navigationTitle("隐私政策")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                    .font(DesignSystem.Typography.callout)
                    .foregroundColor(DesignSystem.Colors.primary)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                animateContent = true
            }
        }
    }
    
    /// 政策条目
    private func policySection(title: String, icon: String, content: String) -> some View {
        CardView(
            backgroundColor: DesignSystem.Colors.surfaceWhite,
            cornerRadius: DesignSystem.CornerRadius.large,
            shadowRadius: 4,
            shadowY: 2
        ) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                // 标题
                HStack(spacing: DesignSystem.Spacing.sm) {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(DesignSystem.Colors.primary)
                    
                    Text(title)
                        .font(DesignSystem.Typography.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                }
                
                // 内容
                Text(content)
                    .font(DesignSystem.Typography.footnote)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(2)
            }
            .padding(DesignSystem.Spacing.lg)
        }
        .opacity(animateContent ? 1 : 0)
        .offset(x: animateContent ? 0 : 20)
        .animation(
            DesignSystem.Animation.standard.delay(Double.random(in: 0...0.3)),
            value: animateContent
        )
    }
}

#Preview {
    PrivacyPolicyView()
}