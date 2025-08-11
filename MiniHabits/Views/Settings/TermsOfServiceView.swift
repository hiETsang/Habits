//
//  TermsOfServiceView.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/11.
//

import SwiftUI

/// 服务条款页面
/// 清晰透明地说明使用条款和责任
struct TermsOfServiceView: View {
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
                        
                        // 服务概述
                        termsSection(
                            title: "服务说明",
                            icon: "app.badge",
                            content: """
                            MiniHabits 是一款个人习惯养成应用，旨在帮助您：
                            
                            • 建立和追踪微习惯
                            • 提供专注倒计时功能
                            • 可视化展示进度数据
                            • 智能提醒和激励
                            
                            本应用完全免费，不包含广告或内购。
                            """
                        )
                        
                        // 使用许可
                        termsSection(
                            title: "使用许可",
                            icon: "checkmark.seal",
                            content: """
                            您可以：
                            
                            • 在任何支持的设备上使用本应用
                            • 创建和管理个人习惯数据
                            • 享受所有功能，无任何限制
                            • 通过 iCloud 同步数据到多设备
                            
                            您不得：
                            
                            • 逆向工程、反编译或破解应用
                            • 将应用用于非法目的
                            • 恶意传播或销售应用
                            """
                        )
                        
                        // 用户责任
                        termsSection(
                            title: "用户责任",
                            icon: "person.badge.shield.checkmark",
                            content: """
                            作为用户，您需要：
                            
                            • 合理使用应用功能
                            • 保护您的设备和账户安全
                            • 遵守当地法律法规
                            • 不滥用通知或系统功能
                            
                            我们建议：
                            
                            • 定期备份重要数据
                            • 保持应用更新到最新版本
                            • 合理设置专注时间，保护健康
                            """
                        )
                        
                        // 服务限制
                        termsSection(
                            title: "服务限制",
                            icon: "exclamationmark.triangle",
                            content: """
                            请注意以下限制：
                            
                            • 应用功能可能因设备或系统版本不同而异
                            • 我们不保证应用 100% 无错误运行
                            • 系统更新可能影响部分功能
                            • 某些功能需要设备权限支持
                            
                            我们承诺：
                            
                            • 持续改进应用质量
                            • 及时修复发现的问题
                            • 提供优质的用户体验
                            """
                        )
                        
                        // 免责声明
                        termsSection(
                            title: "免责声明",
                            icon: "shield.lefthalf.filled",
                            content: """
                            本应用按"现状"提供服务：
                            
                            • 我们不对数据丢失负责（建议定期备份）
                            • 不对因使用应用导致的任何损失负责
                            • 不保证应用完全符合您的特定需求
                            • 第三方服务（如 iCloud）的问题不在我们控制范围内
                            
                            但我们承诺：
                            
                            • 尽最大努力保障应用稳定运行
                            • 积极响应用户反馈和问题
                            • 持续改进产品质量
                            """
                        )
                        
                        // 条款变更
                        termsSection(
                            title: "条款变更",
                            icon: "doc.on.doc",
                            content: """
                            关于条款更新：
                            
                            • 我们可能会不时更新这些条款
                            • 重要变更会通过应用更新通知您
                            • 继续使用应用即表示接受新条款
                            • 您可以随时查看最新版本条款
                            
                            联系方式：
                            
                            • 邮箱：legal@minihabits.app
                            • 我们重视每一个用户的意见和建议
                            
                            本服务条款最后更新：2025年8月11日
                            生效日期：2025年8月11日
                            """
                        )
                        
                        // 底部间距
                        Color.clear.frame(height: DesignSystem.Spacing.xxl)
                    }
                    .padding(.horizontal, DesignSystem.Spacing.pageHorizontal)
                }
            }
            .navigationTitle("服务条款")
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
    
    /// 条款条目
    private func termsSection(title: String, icon: String, content: String) -> some View {
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
    TermsOfServiceView()
}