# KRTC iOS Demo

本示例程序演示了如何使用 KRTC SDK 实现实时音视频通话。

## 前提条件
- 开发环境
    - Xcode 11.0 及以上
    - iOS 10.0 及以上
    - Cocoapods
- iOS 真机

## 运行示例项目

Demo 里采用了 Cocoapods 的方式集成 SDK，您只需要在 Demo 的 Podfile 所在目录中运行
```
pod install
```
然后打开对应的 xcworkspace 文件，即可运行我们的 Demo。

## 配置 AppId

体验 Demo 的功能需要将您在 KRTC 控制台生成的 appId / appName / appSign 自行替换到 Demo中。
您可以在代码中找到对应的宏，替换即可。
```
#define KRTC_APP_ID @""     // 替换为您的 appId
#define KRTC_APP_NAME @"    // 替换为您的 appName
#define KRTC_APP_SIGN @""   // 替换为您的 appSign
```

## 联系我们

- 如果您在集成过程中遇到任何问题，可以随时与我们取得联系，mail: KwaiRTC@kuaishou.com
- 如果您发现了示例代码的 bug，欢迎提交issue