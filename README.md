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

## 功能特性

- 🏗️ Clean Architecture 架构
- 🎨 主题定制
- 🌐 国际化支持
- 🔄 状态管理 (Riverpod)
- 🛣️ 路由管理 (AutoRoute)
- 💾 本地存储 (Hive)
- 🌍 网络请求 (Dio)
- 🔒 安全存储 (Flutter Secure Storage)
- 📱 响应式设计 (ScreenUtil)
- 🎯 依赖注入 (GetIt)
- 📝 日志系统
- 🧪 单元测试
- 🔍 代码生成

## 项目结构

```
lib/
├── core/                 # 核心功能
│   ├── config/          # 配置
│   ├── di/              # 依赖注入
│   ├── error/           # 错误处理
│   ├── network/         # 网络
│   ├── router/          # 路由
│   ├── theme/           # 主题
│   └── utils/           # 工具类
├── features/            # 功能模块
│   ├── auth/           # 认证模块
│   ├── home/           # 首页模块
│   ├── main/           # 主界面模块
│   ├── settings/       # 设置模块
│   └── splash/         # 启动页模块
└── shared/             # 共享资源
    ├── constants/      # 常量
    ├── models/         # 模型
    ├── services/       # 服务
    └── widgets/        # 组件
```

## 开发指南

### 1. 新增功能模块

#### 1.1 创建功能模块结构
```bash
lib/features/your_feature/
├── data/
│   ├── datasources/     # 数据源
│   ├── models/          # 数据模型
│   └── repositories/    # 仓库实现
├── domain/
│   ├── entities/        # 实体
│   ├── repositories/    # 仓库接口
│   └── usecases/       # 用例
└── presentation/
    ├── controllers/     # 控制器
    ├── screens/         # 页面
    └── widgets/         # 组件
```

#### 1.2 创建页面
1. 在 `presentation/screens` 下创建页面文件
2. 使用 `@RoutePage()` 注解标记页面
3. 在 `app_router.dart` 中添加路由配置
4. 运行代码生成器生成路由代码

示例：
```dart
@RoutePage()
class YourScreen extends ConsumerWidget {
  const YourScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // 页面内容
    );
  }
}
```

#### 1.3 创建控制器
1. 在 `presentation/controllers` 下创建控制器文件
2. 使用 Riverpod 创建状态管理
3. 实现业务逻辑

示例：
```dart
final yourControllerProvider = StateNotifierProvider<YourController, YourState>((ref) {
  return YourController(ref);
});

class YourController extends StateNotifier<YourState> {
  YourController(this.ref) : super(const YourState());

  // 实现业务逻辑
}
```

#### 1.4 创建数据模型
1. 在 `data/models` 下创建模型文件
2. 使用 Freezed 生成不可变数据类

示例：
```dart
@freezed
class YourModel with _$YourModel {
  const factory YourModel({
    required String id,
    required String name,
  }) = _YourModel;

  factory YourModel.fromJson(Map<String, dynamic> json) => 
      _$YourModelFromJson(json);
}
```

#### 1.5 创建仓库
1. 在 `domain/repositories` 下创建仓库接口
2. 在 `data/repositories` 下实现仓库

示例：
```dart
// 接口
abstract class YourRepository {
  Future<List<YourModel>> getItems();
}

// 实现
class YourRepositoryImpl implements YourRepository {
  @override
  Future<List<YourModel>> getItems() async {
    // 实现数据获取逻辑
  }
}
```

### 2. 添加新功能步骤

1. **规划功能**
   - 确定功能需求
   - 设计数据模型
   - 规划UI界面

2. **创建基础结构**
   ```bash
   mkdir -p lib/features/your_feature/{data,domain,presentation}
   ```

3. **实现数据层**
   - 创建数据模型
   - 实现数据源
   - 实现仓库

4. **实现业务层**
   - 创建用例
   - 实现业务逻辑

5. **实现表现层**
   - 创建页面
   - 实现控制器
   - 创建UI组件

6. **配置路由**
   - 在 `app_router.dart` 添加路由
   - 运行代码生成器

7. **注册依赖**
   - 在 `injection.dart` 注册服务
   - 配置依赖注入

8. **测试**
   - 编写单元测试
   - 编写集成测试
   - 进行UI测试

### 3. 开发规范

1. **命名规范**
   - 类名：PascalCase
   - 变量名：camelCase
   - 文件名：snake_case
   - 常量：UPPER_SNAKE_CASE

2. **代码组织**
   - 每个文件只做一件事
   - 保持文件简洁（<200行）
   - 使用适当的注释

3. **状态管理**
   - 使用 Riverpod 管理状态
   - 保持状态不可变
   - 使用 StateNotifier 处理复杂状态

4. **路由管理**
   - 使用 AutoRoute 管理路由
   - 保持路由配置清晰
   - 使用命名路由

5. **错误处理**
   - 使用统一的错误处理机制
   - 提供有意义的错误信息
   - 实现错误恢复机制

### 4. 常用命令

```bash
# 生成路由代码
flutter pub run build_runner build --delete-conflicting-outputs

# 生成 Freezed 模型
flutter pub run build_runner build

# 运行测试
flutter test

# 检查代码格式
flutter format .

# 分析代码
flutter analyze
```

### 5. 调试技巧

1. **使用 DevTools**
   - 查看组件树
   - 检查性能
   - 分析内存

2. **日志记录**
   - 使用 LogService 记录关键信息
   - 区分不同级别的日志
   - 在发布版本中禁用调试日志

3. **状态调试**
   - 使用 Riverpod DevTools
   - 监控状态变化
   - 调试依赖关系

## 开始使用

1. 克隆项目
```bash
git clone https://github.com/yourusername/app_template_flutter.git
```

2. 安装依赖
```bash
flutter pub get
```

3. 运行项目
```bash
flutter run
```

## 贡献指南

1. Fork 项目
2. 创建特性分支
3. 提交更改
4. 推送到分支
5. 创建 Pull Request

## 许可证

MIT License
