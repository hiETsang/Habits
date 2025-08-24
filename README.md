# MiniHabits - 微习惯养成应用

<div align="center">
  <img src="MiniHabits/Assets.xcassets/AppIcon.appiconset/微习惯应用抽象扁平Logo%20(2).png" alt="MiniHabits Logo" width="120" height="120" style="border-radius: 20px;">
  
  <h3>基于《微习惯》理论的极简习惯养成应用</h3>
  
  <p>通过"小得不可思议"的目标设定，帮助用户无压力地建立持久的好习惯</p>
  
  [![Swift Version](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
  [![iOS Version](https://img.shields.io/badge/iOS-17.0%2B-blue.svg)](https://developer.apple.com/ios/)
  [![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-green.svg)](https://developer.apple.com/xcode/swiftui/)
  [![Architecture](https://img.shields.io/badge/Architecture-MVVM-purple.svg)](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel)
</div>

## ✨ 产品特色

### 🎯 核心理念
- **降低行动门槛**：将大目标拆解为微小行动，消除心理负担
- **专注启动**：通过倒计时专注模式，帮助用户克服开始的阻力
- **持续激励**：通过视觉化进度展示，强化正向反馈

### 🚀 主要功能

#### 📱 首页 - 今日习惯
- **周视图导航**：横向滚动查看本周习惯完成情况
- **习惯卡片**：2列网格布局，最多展示4个习惯（遵循微习惯理论）
- **状态可视化**：清晰的完成状态指示器
- **快速操作**：点击进入专注模式，长按查看操作菜单

#### ⏰ 专注计时器
- **沉浸式体验**：全屏专注界面，深色主题设计
- **圆形进度**：精美的倒计时进度环，实时显示剩余时间
- **呼吸背景**：动态渐变背景，星空装饰细节
- **完成庆祝**：震撼的完成动画和成就感体验

#### 📊 数据统计
- **周统计图表**：条形图展示本周完成情况
- **习惯详情**：GitHub贡献图样式的42天打卡记录
- **多维度统计**：连续天数、月度完成率、历史记录等

#### ⚙️ 个人设置
- **个性化空间**：温暖的渐变背景和个性化问候
- **智能通知**：自定义提醒设置
- **关于应用**：理念阐述、版本信息、反馈渠道

## 🏗️ 技术架构

### 技术栈
- **语言**：Swift 5.9
- **框架**：SwiftUI + SwiftData
- **架构**：MVVM (Model-View-ViewModel)
- **设计原则**：SOLID原则
- **平台**：iOS 17.0+

### 项目结构
```
MiniHabits/
├── Models/              # 数据模型层
│   ├── Habit.swift            # 习惯数据模型
│   ├── HabitRecord.swift      # 习惯记录模型
│   ├── HabitTemplate.swift    # 预设模板模型
│   └── UserSettings.swift     # 用户设置模型
├── ViewModels/          # 视图模型层
│   └── HabitStore.swift       # 习惯数据管理
├── Views/               # 视图层
│   ├── Home/                  # 首页相关视图
│   ├── Focus/                 # 专注计时相关视图
│   ├── Statistics/            # 统计页面相关视图
│   ├── Settings/              # 设置页面相关视图
│   ├── Common/                # 通用视图
│   └── Components/            # 可复用组件
├── Services/            # 业务服务层
├── Utilities/           # 工具类
├── Extensions/          # 扩展
└── Resources/           # 资源文件
```

### 设计原则

#### SOLID原则实践
- **单一职责原则 (SRP)**：每个类和模块都有明确的单一职责
- **开闭原则 (OCP)**：通过扩展增加新功能，不修改现有代码
- **里氏替换原则 (LSP)**：子类可以替换父类而不影响程序正确性
- **接口隔离原则 (ISP)**：使用协议定义精确的接口
- **依赖倒置原则 (DIP)**：依赖抽象而非具体实现

## 🎨 设计系统

### 视觉设计
- **色彩**：温暖的渐变配色，支持自定义主题色
- **字体**：系统字体，层次分明的字体大小
- **圆角**：统一的圆角设计语言
- **阴影**：精致的投影效果
- **动画**：流畅的转场和交互动画

### 用户体验
- **触觉反馈**：丰富的haptic feedback增强交互体验
- **无障碍**：完整的VoiceOver支持
- **性能优化**：流畅的60fps动画表现
- **直观操作**：符合iOS设计规范的交互模式

## 🚀 快速开始

### 环境要求
- Xcode 15.0+
- iOS 17.0+
- macOS 14.0+

### 安装步骤

1. **克隆项目**
```bash
git clone https://github.com/yourusername/MiniHabits.git
cd MiniHabits
```

2. **打开项目**
```bash
open MiniHabits.xcodeproj
```

3. **运行应用**
- 选择目标设备或模拟器
- 按 `Cmd + R` 运行项目

### 项目配置

#### 必要配置
1. **Bundle Identifier**：在项目设置中配置你的Bundle ID
2. **Team**：选择你的Apple Developer Team
3. **Signing**：配置代码签名

#### 可选配置
1. **通知权限**：应用会请求通知权限用于习惯提醒
2. **数据存储**：使用SwiftData本地存储，无需额外配置

## 📖 开发文档

### 核心组件

#### 数据模型
```swift
// 习惯模型
@Model
class Habit {
    var title: String           // 习惯标题
    var emoji: String          // 表情图标
    var miniHabit: String      // 微习惯描述
    var duration: Int          // 专注时长（分钟）
    var themeColor: String     // 主题色
    var createdAt: Date        // 创建时间
}
```

#### 视图模型
```swift
// 习惯数据管理
@Observable
class HabitStore {
    func createHabit(_ habit: Habit)     // 创建习惯
    func updateHabit(_ habit: Habit)     // 更新习惯
    func deleteHabit(_ habit: Habit)     // 删除习惯
    func completeHabit(_ habit: Habit)   // 完成习惯
}
```

### 开发指南

#### 添加新功能
1. 遵循MVVM架构模式
2. 在对应的文件夹中创建新文件
3. 使用协议定义接口
4. 编写单元测试
5. 更新文档

#### 代码规范
- 遵循Swift API设计指南
- 使用有意义的命名
- 添加适当的注释
- 保持代码简洁易读

## 🧪 测试

### 运行测试
```bash
# 运行所有测试
xcodebuild test -scheme MiniHabits -destination 'platform=iOS Simulator,name=iPhone 15'

# 运行单元测试
xcodebuild test -scheme MiniHabits -testPlan UnitTestPlan
```

### 测试覆盖率
- 模型层：>95% 覆盖率
- 视图模型层：>90% 覆盖率
- 服务层：>85% 覆盖率

## 📱 功能演示

### 主要功能流程

1. **创建习惯**
   - 选择预设模板或自定义创建
   - 设置微习惯目标和专注时长
   - 选择喜欢的Emoji图标

2. **专注模式**
   - 点击习惯卡片进入专注模式
   - 沉浸式倒计时体验
   - 完成后获得成就感反馈

3. **进度追踪**
   - 查看每日完成情况
   - 分析周统计和月度趋势
   - GitHub样式的打卡记录

## 📈 开发进度

### ✅ 已完成功能
- [x] 数据层基础架构
- [x] 基础UI框架和设计系统
- [x] 首页习惯列表和导航
- [x] 新建/编辑习惯功能
- [x] 专注倒计时核心功能
- [x] 统计功能和数据可视化
- [x] 设置功能和个人空间

### 🚧 开发中
- [ ] UI优化和体验完善
- [ ] 性能优化
- [ ] 无障碍功能增强

### 📋 未来规划
- [ ] 小组件支持
- [ ] Apple Watch配套应用
- [ ] 数据导入导出
- [ ] 云同步功能

## 🤝 贡献指南

### 如何贡献
1. Fork 这个项目
2. 创建你的功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交你的更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开一个 Pull Request

### 贡献规范
- 遵循现有的代码风格
- 编写清晰的提交信息
- 添加必要的测试
- 更新相关文档

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 📞 联系我们

- **邮箱**：support@minihabits.app
- **GitHub Issues**：[提交问题](https://github.com/yourusername/MiniHabits/issues)
- **App Store**：[应用评分](https://apps.apple.com/app/minihabits)

## 🙏 致谢

感谢所有为这个项目做出贡献的开发者和设计师。

特别感谢《微习惯》一书的作者斯蒂芬·盖斯，为我们提供了理论基础。

---

<div align="center">
  <p>⭐ 如果这个项目对你有帮助，请给它一个星标！</p>
  <p>Made with ❤️ for habit builders everywhere</p>
</div>
