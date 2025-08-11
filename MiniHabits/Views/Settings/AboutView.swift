//
//  AboutView.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/11.
//

import SwiftUI

/// 关于页面
/// 不仅是信息展示，更是传达应用理念和价值观的地方
struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var animateContent = false
    @State private var showEasterEgg = false
    @State private var logoTapCount = 0
    
    private let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    private let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    
    var body: some View {
        NavigationView {
            ZStack {
                // 温暖渐变背景
                LinearGradient(
                    colors: [
                        DesignSystem.Colors.background,
                        DesignSystem.Colors.primary.opacity(0.05)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: DesignSystem.Spacing.xl) {
                        // 顶部间距
                        Color.clear.frame(height: DesignSystem.Spacing.lg)
                        
                        // 应用标识区域
                        appIdentitySection
                            .opacity(animateContent ? 1 : 0)
                            .offset(y: animateContent ? 0 : 30)
                            .animation(
                                DesignSystem.Animation.bouncy.delay(0.1),
                                value: animateContent
                            )
                        
                        // 理念阐述区域
                        missionSection
                            .opacity(animateContent ? 1 : 0)
                            .offset(y: animateContent ? 0 : 30)
                            .animation(
                                DesignSystem.Animation.standard.delay(0.2),
                                value: animateContent
                            )
                        
                        // 核心特性
                        featuresSection
                            .opacity(animateContent ? 1 : 0)
                            .offset(y: animateContent ? 0 : 30)
                            .animation(
                                DesignSystem.Animation.standard.delay(0.3),
                                value: animateContent
                            )
                        
                        // 团队与技术
                        teamSection
                            .opacity(animateContent ? 1 : 0)
                            .offset(y: animateContent ? 0 : 30)
                            .animation(
                                DesignSystem.Animation.standard.delay(0.4),
                                value: animateContent
                            )
                        
                        // 版本信息
                        versionSection
                            .opacity(animateContent ? 1 : 0)
                            .offset(y: animateContent ? 0 : 30)
                            .animation(
                                DesignSystem.Animation.standard.delay(0.5),
                                value: animateContent
                            )
                        
                        // 底部间距
                        Color.clear.frame(height: DesignSystem.Spacing.xxl)
                    }
                    .padding(.horizontal, DesignSystem.Spacing.pageHorizontal)
                }
            }
            .navigationTitle("关于 MiniHabits")
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
            withAnimation {
                animateContent = true
            }
        }
        .alert("🎉 彩蛋发现！", isPresented: $showEasterEgg) {
            Button("太棒了！") { }
        } message: {
            Text("感谢您如此仔细地探索这个应用！您的每一次点击都让我们感动。愿微习惯的力量伴随您的每一天！")
        }
    }
    
    /// 应用标识区域
    private var appIdentitySection: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            // 应用图标
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                .fill(
                    LinearGradient(
                        colors: [
                            DesignSystem.Colors.primary,
                            DesignSystem.Colors.primary.opacity(0.8)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 100, height: 100)
                .overlay {
                    Text("🎯")
                        .font(.system(size: 50))
                }
                .onTapGesture {
                    handleLogoTap()
                }
                .scaleEffect(showEasterEgg ? 1.1 : 1.0)
                .animation(DesignSystem.Animation.bouncy, value: showEasterEgg)
            
            // 应用名称和标语
            VStack(spacing: DesignSystem.Spacing.sm) {
                Text("MiniHabits")
                    .font(DesignSystem.Typography.title1)
                    .fontWeight(.bold)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Text("小得不可思议的改变，大得超乎想象的结果")
                    .font(DesignSystem.Typography.callout)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    /// 理念阐述区域
    private var missionSection: some View {
        infoCard(
            title: "我们的理念",
            icon: "lightbulb.circle.fill"
        ) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                philosophyPoint(
                    title: "微习惯的力量",
                    description: "一个俯卧撑胜过零个俯卧撑，一页书胜过零页书。微小的行动蕴含着巨大的力量。"
                )
                
                philosophyPoint(
                    title: "无压力成长",
                    description: "摆脱完美主义的枷锁，拥抱每一个微小的进步。成长应该是愉悦的，而不是痛苦的。"
                )
                
                philosophyPoint(
                    title: "专注当下",
                    description: "不追求数量的堆砌，只专注当下这一刻的专注和投入。质量永远比数量更重要。"
                )
            }
        }
    }
    
    /// 理念要点组件
    private func philosophyPoint(title: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
            Text(title)
                .font(DesignSystem.Typography.callout)
                .fontWeight(.semibold)
                .foregroundColor(DesignSystem.Colors.primary)
            
            Text(description)
                .font(DesignSystem.Typography.footnote)
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    /// 核心特性区域
    private var featuresSection: some View {
        infoCard(
            title: "核心特性",
            icon: "star.circle.fill"
        ) {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: DesignSystem.Spacing.lg) {
                featureItem(icon: "target", title: "微习惯设计", subtitle: "小得不可思议")
                featureItem(icon: "timer", title: "专注倒计时", subtitle: "沉浸式体验")
                featureItem(icon: "chart.bar", title: "进度可视化", subtitle: "GitHub风格")
                featureItem(icon: "heart", title: "温暖设计", subtitle: "情感化交互")
            }
        }
    }
    
    /// 特性项目组件
    private func featureItem(icon: String, title: String, subtitle: String) -> some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(DesignSystem.Colors.primary)
            
            Text(title)
                .font(DesignSystem.Typography.footnote)
                .fontWeight(.semibold)
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            Text(subtitle)
                .font(.system(size: 11))
                .foregroundColor(DesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(DesignSystem.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                .fill(DesignSystem.Colors.primary.opacity(0.05))
        )
    }
    
    /// 团队与技术区域
    private var teamSection: some View {
        infoCard(
            title: "团队与技术",
            icon: "person.2.circle.fill"
        ) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                teamInfo(
                    title: "设计理念",
                    description: "受到 Dieter Rams 和 Jonathan Ive 的设计哲学启发，追求功能与美的完美统一。"
                )
                
                teamInfo(
                    title: "技术栈",
                    description: "采用 SwiftUI + SwiftData 构建，遵循 MVVM 架构和 SOLID 原则，确保代码质量。"
                )
                
                teamInfo(
                    title: "开发团队",
                    description: "由一群热爱生活、追求完美的开发者组成。我们相信技术应该让生活更美好。"
                )
            }
        }
    }
    
    /// 团队信息组件
    private func teamInfo(title: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
            Text(title)
                .font(DesignSystem.Typography.callout)
                .fontWeight(.semibold)
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            Text(description)
                .font(DesignSystem.Typography.footnote)
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    /// 版本信息区域
    private var versionSection: some View {
        infoCard(
            title: "版本信息",
            icon: "info.circle.fill"
        ) {
            VStack(spacing: DesignSystem.Spacing.md) {
                HStack {
                    Text("当前版本")
                        .font(DesignSystem.Typography.callout)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                    
                    Spacer()
                    
                    Text("v\(appVersion) (\(buildNumber))")
                        .font(DesignSystem.Typography.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(DesignSystem.Colors.primary)
                }
                
                Divider()
                    .background(DesignSystem.Colors.textTertiary)
                
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                    Text("版本特性")
                        .font(DesignSystem.Typography.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                    
                    Text("• 全新的设置页面体验\n• 更加智能的通知系统\n• 优化的用户界面和交互\n• 提升的整体性能")
                        .font(DesignSystem.Typography.footnote)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
    
    /// 通用信息卡片
    private func infoCard<Content: View>(
        title: String,
        icon: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        CardView(
            backgroundColor: DesignSystem.Colors.surfaceWhite,
            cornerRadius: DesignSystem.CornerRadius.large,
            shadowRadius: 6,
            shadowY: 2
        ) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                // 区域标题
                HStack(spacing: DesignSystem.Spacing.sm) {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(DesignSystem.Colors.primary)
                    
                    Text(title)
                        .font(DesignSystem.Typography.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                }
                
                content()
            }
            .padding(DesignSystem.Spacing.xl)
        }
    }
    
    /// 处理 Logo 点击
    private func handleLogoTap() {
        logoTapCount += 1
        
        if logoTapCount >= 5 {
            showEasterEgg = true
            logoTapCount = 0
        }
        
        // 触觉反馈
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
}

#Preview {
    AboutView()
}