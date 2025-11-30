# Moodist Flutter

一款精美的环境音/白噪音混音应用，帮助你专注工作、放松身心。

## 功能特性

### 核心功能
- **84+ 环境音效** - 涵盖自然、雨声、动物、城市、场所、交通、物品、噪音 8 大分类
- **自由混音** - 多音轨同时播放，独立音量控制
- **预设管理** - 保存和加载你喜爱的音效组合
- **收藏系统** - 双击快速收藏常用音效
- **智能混音** - 一键随机生成舒适的音效组合

### 效率工具
- **番茄钟** - 专注/休息周期计时，可自定义时长
- **倒计时** - 简单计时器
- **待办事项** - 任务追踪
- **记事本** - 快速笔记
- **睡眠定时器** - 定时自动停止播放

### 健康工具
- **呼吸练习** - 引导式呼吸放松
- **双耳节拍** - 立体声脑波引导
- **等时音调** - 节律性音频脉冲

### 体验优化
- **深色/浅色主题** - 跟随系统自动切换
- **后台播放** - 支持锁屏继续播放
- **触觉反馈** - 精细的交互震动反馈
- **流畅动画** - 精心设计的过渡效果

## 技术栈

| 类别 | 技术 |
|------|------|
| 框架 | Flutter 3.10+ / Dart |
| 状态管理 | Riverpod + riverpod_annotation |
| 本地数据库 | Drift ORM + SQLite |
| 音频播放 | just_audio + audio_session |
| 路由 | go_router |
| 动画 | flutter_animate |
| 图标 | lucide_icons |
| 代码生成 | build_runner, freezed |

## 项目架构

```
lib/
├── main.dart                 # 应用入口
├── app.dart                  # MaterialApp 配置
├── core/                     # 核心模块
│   ├── constants/            # 常量定义
│   │   ├── app_colors.dart   # 颜色系统
│   │   └── app_durations.dart
│   └── themes/
│       └── app_theme.dart    # 主题配置
├── data/                     # 数据层
│   ├── database/             # Drift 数据库
│   │   ├── app_database.dart
│   │   └── daos/             # 数据访问对象
│   ├── datasources/
│   │   └── assets/           # 静态资源定义
│   └── models/               # 数据模型
├── presentation/             # 表现层
│   ├── providers/            # Riverpod Providers
│   │   ├── audio/            # 音频相关状态
│   │   ├── timer/            # 计时器状态
│   │   ├── tools/            # 工具状态
│   │   └── preset/           # 预设状态
│   ├── screens/              # 页面
│   │   ├── home/             # 主页（底部导航）
│   │   ├── sounds/           # 音效列表
│   │   ├── favorites/        # 收藏
│   │   ├── tools/            # 工具集
│   │   ├── presets/          # 预设管理
│   │   └── settings/         # 设置
│   ├── widgets/              # 可复用组件
│   │   ├── playback/         # 播放控制
│   │   ├── sound/            # 音效卡片
│   │   ├── timer/            # 计时器
│   │   └── preset/           # 预设
│   └── router/
│       └── app_router.dart   # 路由配置
├── services/                 # 服务层
│   ├── audio_service.dart    # 音频播放服务
│   ├── notification_service.dart
│   └── tone_generator_service.dart
└── assets/
    └── sounds/               # 音频文件 (mp3/wav)
        ├── nature/
        ├── rain/
        ├── animals/
        └── ...
```

## 快速开始

### 环境要求
- Flutter SDK >= 3.10.1
- Dart SDK >= 3.10.1
- Xcode (iOS/macOS)
- Android Studio (Android)

### 安装依赖

```bash
# 克隆项目
git clone <repository-url>
cd moodist_flutter

# 获取依赖
flutter pub get

# 生成代码（如有修改 provider/database/model）
flutter pub run build_runner build --delete-conflicting-outputs
```

### 运行项目

```bash
# 查看可用设备
flutter devices

# 运行（自动选择设备）
flutter run

# 指定平台运行
flutter run -d macos      # macOS
flutter run -d chrome     # Web
flutter run -d ios        # iOS 模拟器
flutter run -d <device-id>  # 指定设备
```

### 热重载开发

```bash
# 启动后在终端按:
# r - 热重载 (Hot Reload)
# R - 热重启 (Hot Restart)
# q - 退出
```

## 打包发布

### iOS

```bash
# 构建 iOS Release
flutter build ios --release

# 或打开 Xcode 归档
open ios/Runner.xcworkspace
# Xcode: Product → Archive → Distribute App
```

### Android

```bash
# 构建 APK
flutter build apk --release

# 构建 App Bundle (推荐上架 Google Play)
flutter build appbundle --release

# 输出位置: build/app/outputs/
```

### macOS

```bash
# 构建 macOS 应用
flutter build macos --release

# 输出位置: build/macos/Build/Products/Release/
```

### Web

```bash
# 构建 Web
flutter build web --release

# 输出位置: build/web/
# 可部署到任何静态托管服务
```

## 开发维护

### 代码生成

项目使用 `build_runner` 生成以下代码：
- Riverpod providers (`.g.dart`)
- Drift 数据库 (`.g.dart`)
- Freezed 模型 (`.freezed.dart`, `.g.dart`)

```bash
# 一次性生成
flutter pub run build_runner build --delete-conflicting-outputs

# 监听模式（开发时推荐）
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 添加新音效

1. 将音频文件放入 `assets/sounds/<category>/`
2. 在 `lib/data/datasources/assets/sound_assets.dart` 添加定义：
```dart
SoundDefinition(
  id: 'new-sound',
  label: 'New Sound',
  icon: 'icon-name',
  path: '$_basePath/category/new-sound.mp3',
),
```
3. 确保 `pubspec.yaml` 中已包含该目录

### 添加新工具页面

1. 在 `lib/presentation/screens/tools/` 创建新页面
2. 在 `lib/presentation/providers/tools/` 创建对应 provider
3. 在 `tools_screen.dart` 添加入口卡片

### 代码规范

```bash
# 代码格式化
dart format lib/

# 静态分析
flutter analyze

# 运行测试
flutter test
```

### 依赖更新

```bash
# 查看可更新依赖
flutter pub outdated

# 更新依赖
flutter pub upgrade

# 更新到最新大版本（谨慎）
flutter pub upgrade --major-versions
```

## 设计规范

### 颜色系统
- **主色**: `#667EEA` → `#764BA2` (紫色渐变)
- **强调色**: 各分类有独立颜色标识
- **深色背景**: `#0F0F1A`
- **浅色背景**: `#F8F9FE`

### 圆角规范
- 卡片: 16-20px
- 按钮: 14-16px
- 底部弹窗: 24px
- 底部导航: 28px

### 动画时长
- 快速反馈: 150-200ms
- 状态切换: 200-300ms
- 页面过渡: 300-400ms

## 许可证

MIT License

## 致谢

- 音效资源来自 [Moodist](https://moodist.app)
- 图标来自 [Lucide Icons](https://lucide.dev)
