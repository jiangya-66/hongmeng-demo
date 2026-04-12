# hongmeng-demo - HarmonyOS应用

## 📱 工程概述

**hongmeng-demo** 是一个基于HarmonyOS 6.0.2(22)开发的移动应用，采用Stage模型架构，使用ArkTS作为主要开发语言。应用包含启动页、登录页、注册页和主页四个主要页面，实现了完整的用户认证流程。

### 🚀 主要特性
- **现代化架构**：采用HarmonyOS Stage模型，支持模块化开发
- **响应式UI**：基于ArkUI框架，适配不同设备尺寸
- **完整生命周期**：包含UIAbility和BackupExtensionAbility
- **数据备份**：支持应用数据备份和恢复功能
- **表单验证**：登录页面包含用户名密码验证逻辑

## 📋 技术栈

| 技术 | 版本 | 说明 |
|------|------|------|
| HarmonyOS SDK | 6.0.2(22) | 目标SDK版本 |
| ArkTS | 最新版 | 开发语言 |
| ArkUI | 3.0 | UI框架 |
| Stage模型 | 是 | 应用架构 |
| 构建工具 | Hvigor | 构建系统 |

## 📁 工程结构

```
hongmeng-demo/
├── AppScope/                    # 应用级配置
│   ├── app.json5               # 应用配置文件
│   └── resources/              # 应用级资源
│       ├── base/
│       │   ├── element/        # 字符串资源
│       │   ├── media/          # 媒体资源
│       │   └── profile/        # 配置文件
│       └── zh_CN/              # 中文资源
├── entry/                       # 主模块
│   ├── src/main/
│   │   ├── ets/
│   │   │   ├── entryability/   # 入口能力
│   │   │   │   └── EntryAbility.ets
│   │   │   ├── entrybackupability/ # 备份能力
│   │   │   │   └── EntryBackupAbility.ets
│   │   │   ├── components/     # 公共组件
│   │   │   │   ├── HomeContent.ets
│   │   │   │   └── Profile.ets
│   │   │   └── pages/          # 页面组件
│   │   │       ├── Splash.ets  # 启动页
│   │   │       ├── Login.ets   # 登录页
│   │   │       ├── Register.ets # 注册页
│   │   │       └── Home.ets    # 主页
│   │   ├── resources/          # 模块资源
│   │   └── module.json5        # 模块配置
│   └── entry_test/             # 测试模块
├── oh-package.json5            # 依赖管理
├── build-profile.json5         # 构建配置
├── hvigorfile.ts               # 构建脚本
└── README.md                   # 本文件
```

## ⚙️ 配置说明

### 应用配置 (AppScope/app.json5)
```json5
{
  "app": {
    "bundleName": "com.example.myapplication",
    "vendor": "example",
    "versionCode": 1000000,
    "versionName": "1.0.0",
    "icon": "$media:app_icon",
    "label": "$string:app_name"
  }
}
```

### 模块配置 (entry/src/main/module.json5)
```json5
{
  "module": {
    "name": "entry",
    "type": "entry",
    "description": "$string:module_desc",
    "mainElement": "EntryAbility",
    "deviceTypes": ["phone"],
    "deliveryWithInstall": true,
    "installationFree": false,
    "pages": "$profile:main_pages",
    "abilities": [
      {
        "name": "EntryAbility",
        "srcEntry": "./ets/entryability/EntryAbility.ets",
        "description": "$string:EntryAbility_desc",
        "icon": "$media:icon",
        "label": "$string:EntryAbility_label",
        "startWindowIcon": "$media:icon",
        "startWindowBackground": "$color:start_window_background",
        "exported": true,
        "skills": [
          {
            "entities": ["entity.system.home"],
            "actions": ["action.system.home"]
          }
        ]
      },
      {
        "name": "EntryBackupAbility",
        "srcEntry": "./ets/entrybackupability/EntryBackupAbility.ets",
        "type": "backup",
        "description": "$string:EntryBackupAbility_desc",
        "exported": true,
        "skills": [
          {
            "entities": ["entity.system.backup"],
            "actions": ["action.system.backup"]
          }
        ]
      }
    ]
  }
}
```

### 页面路由配置 (main_pages.json)
```json5
{
  "src": [
    "pages/Splash",
    "pages/Login",
    "pages/Register",
    "pages/Home"
  ]
}
```

## 📦 依赖管理

### 开发依赖 (oh-package.json5)
```json5
{
  "dependencies": {},
  "devDependencies": {
    "@ohos/hypium": "1.0.25",
    "@ohos/hamock": "1.0.0"
  }
}
```

当前依赖：
- **@ohos/hypium**: 单元测试框架
- **@ohos/hamock**: 测试辅助工具

## 🚀 快速开始

### 环境要求

#### Windows开发环境
- **操作系统**: Windows 10 64位或更高版本
- **内存**: 8GB RAM（推荐16GB）
- **存储空间**: 至少10GB可用空间
- **开发工具**: DevEco Studio 4.0 或更高版本
- **SDK**: HarmonyOS SDK 6.0.2(22) 或更高版本
- **Node.js**: 18+ LTS版本（用于包管理）
- **Java**: JDK 17或更高版本

#### 环境配置步骤
1. **安装DevEco Studio**
   - 从[HarmonyOS开发者官网](https://developer.harmonyos.com/cn/develop/deveco-studio)下载
   - 运行安装程序并按照向导完成安装

2. **配置HarmonyOS SDK**
   - 打开DevEco Studio
   - 进入设置（File > Settings）
   - 选择"SDK Manager"
   - 安装HarmonyOS SDK 6.0.2(22)

3. **配置Node.js和ohpm**
   ```powershell
   # 验证Node.js安装
   node --version
   
   # 验证npm安装
   npm --version
   
   # 安装ohpm（如果未安装）
   npm install -g @ohos/ohpm
   
   # 验证ohpm安装
   ohpm --version
   ```

4. **配置Java环境**
   ```powershell
   # 验证Java安装
   java --version
   
   # 设置JAVA_HOME环境变量（如果需要）
   # 在PowerShell中设置临时环境变量
   $env:JAVA_HOME = "C:\Program Files\Java\jdk-17"
   ```

### 克隆工程
```powershell
# 使用Git Bash或Windows Terminal
git clone <repository-url>
cd hongmeng-demo

# 或者使用PowerShell
git clone <repository-url>
Set-Location hongmeng-demo
```

### 安装依赖
```powershell
# 使用ohpm安装依赖
ohpm install

# 或者使用npm（如果配置了ohpm的npm别名）
npm install
```

### 构建应用
```powershell
# 调试版本
npm run build:debug

# 发布版本
npm run build:release

# 清理构建缓存
npm run clean

# 重新构建
npm run rebuild
```

### 运行应用

#### Windows环境下的运行方式
1. **使用DevEco Studio**
   - 打开DevEco Studio
   - 选择"Open"或"Import"导入工程
   - 连接设备或启动模拟器
   - 点击运行按钮 ▶️

2. **命令行运行（PowerShell）**
   ```powershell
   # 启动DevEco Studio
   Start-Process "C:\Program Files\Huawei\DevEco Studio\bin\devecostudio.exe"
   
   # 清理并重新构建
   npm run clean
   npm run build:debug
   
   # 运行测试
   npm run test
   ```

3. **使用模拟器**
   - 确保已安装HarmonyOS模拟器
   - 在DevEco Studio中启动模拟器
   - 选择模拟器作为运行目标

#### Windows调试技巧
1. **日志查看**
   ```powershell
   # 查看构建日志
   Get-Content "build.log" -Wait
   
   # 查看应用日志（在模拟器或真机调试时）
   # 使用DevEco Studio的Logcat面板
   ```

2. **性能监控**
   - 使用Windows任务管理器监控内存和CPU使用
   - 使用DevEco Studio的性能分析工具

3. **网络调试**
   ```powershell
   # 检查网络连接
   Test-NetConnection -ComputerName "example.com" -Port 443
   
   # 查看代理设置
   netsh winhttp show proxy
   ```

## 🧪 测试

### 运行单元测试
```powershell
# 运行所有测试
npm run test

# 运行特定测试文件
npm run test -- --test-file List.test.ets

# 查看测试覆盖率
npm run test -- --coverage
```

### 测试模块结构
```
entry_test/
├── src/ohosTest/
│   └── ets/
│       ├── test/
│       │   └── Ability.test.ets
│       └── TestAbility.ets
```

## 📱 页面说明

### 1. 启动页 (Splash)
- 显示应用Logo
- 3秒后自动跳转到登录页
- 使用`router.pushUrl`进行页面导航

### 2. 登录页 (Login)
- 用户名和密码输入框
- 表单验证（非空检查）
- 登录按钮和跳转逻辑
- 使用`router.replaceUrl`替换当前页面

### 3. 注册页 (Register)
- 用户名、邮箱和密码输入框
- 表单验证（邮箱格式、密码强度）
- 注册按钮和跳转逻辑
- 使用`@State`管理表单状态

### 4. 主页 (Home)
- 显示欢迎信息和用户信息
- 功能卡片展示
- 退出登录按钮
- 使用`@State`和`@Link`管理页面状态
- 包含公共组件（HomeContent, Profile）

## 🔧 开发指南

### Windows开发环境配置

#### PowerShell常用命令
```powershell
# 查看当前目录
Get-Location

# 列出文件和目录
Get-ChildItem
# 或使用别名
ls
dir

# 创建新目录
New-Item -ItemType Directory -Name "new-directory"

# 创建新文件
New-Item -ItemType File -Name "new-file.ets"

# 复制文件
Copy-Item "source.ets" "destination.ets"

# 移动文件
Move-Item "old-name.ets" "new-name.ets"

# 删除文件
Remove-Item "file-to-delete.ets"

# 查看文件内容
Get-Content "README.md"
```

#### 环境变量设置
```powershell
# 设置临时环境变量
$env:OHPM_HOME = "C:\Users\YourName\AppData\Roaming\ohpm"

# 永久设置环境变量（需要管理员权限）
[System.Environment]::SetEnvironmentVariable("OHPM_HOME", "C:\Users\YourName\AppData\Roaming\ohpm", "User")

# 查看环境变量
Get-ChildItem Env:
```

#### 解决常见Windows问题
1. **权限问题**
   ```powershell
   # 以管理员身份运行PowerShell
   # 右键点击PowerShell，选择"以管理员身份运行"
   
   # 更改文件权限（如果需要）
   icacls "file.ets" /grant "Users:(R,W)"
   ```

2. **路径问题**
   ```powershell
   # Windows路径使用反斜杠，但在字符串中需要转义
   $path = "D:\\myprojects\\hongmeng-demo"
   
   # 或者使用正斜杠（推荐）
   $path = "D:/myprojects/hongmeng-demo"
   ```

3. **编码问题**
   ```powershell
   # 设置PowerShell输出编码为UTF-8
   [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
   
   # 设置输入编码为UTF-8
   [Console]::InputEncoding = [System.Text.Encoding]::UTF8
   ```

### 添加新页面
1. 在`entry/src/main/ets/pages/`目录下创建新的.ets文件
2. 在`main_pages.json`中添加页面路径
3. 在`module.json5`中配置页面路由（如需要）

### 状态管理
- 使用`@State`装饰器管理组件内部状态
- 使用`@Prop`装饰器传递父组件到子组件的状态
- 使用`@Link`装饰器实现父子组件双向绑定
- 使用`@Provide`和`@Consume`装饰器实现跨组件状态共享

### 页面导航
```typescript
// 跳转到新页面
router.pushUrl({
  url: 'pages/Login'
});

// 替换当前页面
router.replaceUrl({
  url: 'pages/Index'
});

// 返回上一页
router.back();
```

### 资源管理
- 字符串资源：`resources/base/element/string.json`
- 颜色资源：`resources/base/element/color.json`
- 媒体资源：`resources/base/media/`
- 多语言：`resources/zh_CN/`（中文）

## 🛠️ 构建配置

### 构建模式
- **Debug模式**: 包含调试信息，不进行代码混淆
- **Release模式**: 进行代码压缩和混淆，优化性能

### 签名配置
在`build-profile.json5`中配置签名信息：
```json5
"signingConfigs": [
  {
    "name": "default",
    "material": {
      "certpath": "sign/MyApplication.p12",
      "storePassword": "******",
      "keyAlias": "MyApplication",
      "keyPassword": "******",
      "signAlg": "SHA256withECDSA",
      "profile": "sign/MyApplication.p7b",
      "certpathDebug": "sign/MyApplication_debug.p12",
      "storePasswordDebug": "******"
    }
  }
]
```

## 📊 性能优化建议

### 1. 图片优化
- 使用WebP格式图片
- 实现图片懒加载
- 使用适当的图片尺寸

### 2. 内存管理
- 及时释放不需要的资源
- 使用弱引用避免内存泄漏
- 监控内存使用情况

### 3. 渲染优化
- 使用`@Reusable`装饰器复用组件
- 避免不必要的重新渲染
- 使用`LazyForEach`处理长列表

## 🔒 安全注意事项

### 1. 数据安全
- 敏感数据使用加密存储
- 避免在日志中输出敏感信息
- 使用安全的网络通信（HTTPS）

### 2. 权限管理
- 按需申请权限
- 向用户解释权限使用目的
- 及时释放不再需要的权限

### 3. 代码安全
- 启用代码混淆（Release模式）
- 定期更新依赖包
- 进行安全代码审查

## 🤝 贡献指南

### 代码规范
- 遵循ArkTS官方编码规范
- 使用有意义的变量和函数名
- 添加必要的注释和文档

### 提交规范
- 使用英文提交信息
- 遵循Conventional Commits规范
- 关联Issue编号（如适用）

### 提交流程
1. Fork本仓库
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 创建Pull Request

## 📄 许可证

本项目采用MIT许可证。详见[LICENSE](LICENSE)文件。

## 📞 支持与反馈

### 问题报告
- 使用GitHub Issues报告问题
- 提供详细的重现步骤
- 包含相关日志和截图

### 功能建议
- 在Issues中提出功能建议
- 描述使用场景和预期效果
- 讨论实现方案

### 联系方式
- 邮箱：harmonyos-dev@example.com
- GitHub Issues：[项目Issues页面](https://github.com/your-username/hongmeng-demo/issues)
- 文档：本项目README.md
- Windows支持：确保使用PowerShell 7.0+以获得最佳体验

## 📈 版本历史

### v1.0.0 (2024-01-01)
- 初始版本发布
- 实现基础登录功能
- 包含启动页、登录页、主页
- 支持数据备份功能

### v1.1.0 (2026-04-12)
- 新增用户注册页面
- 优化页面结构（Index改为Home）
- 添加Windows PowerShell兼容命令
- 完善Windows开发环境指南
- 更新项目文档

---

**最后更新**: 2026年4月12日

**维护者**: HarmonyOS开发团队

**状态**: 活跃开发中

**操作系统支持**: Windows 10/11, macOS, Linux

**开发工具**: DevEco Studio 4.0+, PowerShell 7.0+