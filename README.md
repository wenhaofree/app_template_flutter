# Flutter应用脚手架

基于干净架构设计的Flutter应用程序脚手架，集成了常用依赖和最佳实践。

## 特性

- 基于**干净架构**设计，代码组织清晰
- 使用**Riverpod**进行状态管理
- 使用**Freezed**处理不可变状态
- 使用**Auto Route**进行路由管理
- 使用**GetIt**进行依赖注入
- 使用**Dio**进行网络请求
- 使用**Hive**和**SharedPreferences**进行本地存储
- 内置主题支持（亮色/暗色）
- 国际化支持
- 预设常用UI组件
- 全局错误处理
- 网络状态监测
- 遵循最佳编码实践

## 架构

项目采用干净架构设计模式，分为以下几个层次：

1. **表现层**（Presentation）：包含UI界面和视图模型
2. **领域层**（Domain）：包含业务实体和用例
3. **数据层**（Data）：包含数据源和仓库实现

## 目录结构

```
lib/
├── app.dart                  # 应用程序入口
├── main.dart                 # 主函数
├── core/                     # 核心功能
│   ├── config/               # 应用配置
│   ├── di/                   # 依赖注入
│   ├── error/                # 错误处理
│   ├── network/              # 网络相关
│   ├── router/               # 路由
│   ├── storage/              # 存储
│   ├── theme/                # 主题
│   └── utils/                # 工具类
├── features/                 # 功能模块
│   ├── auth/                 # 认证模块
│   │   ├── data/             # 数据层
│   │   ├── domain/           # 领域层
│   │   └── presentation/     # 表现层
│   └── home/                 # 首页模块
│       ├── data/             # 数据层
│       ├── domain/           # 领域层
│       └── presentation/     # 表现层
└── shared/                   # 共享资源
    ├── constants/            # 常量
    ├── models/               # 共享模型
    └── widgets/              # 共享组件
```

## 开始使用

1. 克隆项目

```bash
git clone https://github.com/wenhaofree/app_template_flutter.git
```

2. 安装依赖

```bash
flutter pub get
```

3. 生成必要的代码文件

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. 运行项目

```bash
flutter run
```

## 依赖

主要依赖包括：

- **状态管理**: flutter_riverpod, freezed
- **路由**: auto_route
- **网络**: dio, connectivity_plus
- **存储**: shared_preferences, hive
- **依赖注入**: get_it
- **UI**: flutter_screenutil, flutter_svg
- **工具**: intl, logger

## 贡献

欢迎贡献代码、提出问题或建议！

## 许可

本项目采用 MIT 许可证。
