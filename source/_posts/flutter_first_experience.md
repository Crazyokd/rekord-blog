---
layout: post
title: flutter 初体验
date: 2022/05/25
updated: 2022/05/25
cover: /assets/flutter-lockup-bg.webp
coverWidth: 1100
coverHeight: 342
comments: true
categories: 
- 技术
tags:
- flutter
---

## 安装 Flutter SDK
```bash

flutter doctor -v
# 关闭谷歌分析
flutter config --no-analytics
dart --disable-analytics

flutter doctor --android-licenses
```


## 加速 gradle 依赖拉取
```plain

// google()
// mavenCentral()
maven { 
    url 'http://maven.aliyun.com/nexus/content/repositories/google' 
    allowInsecureProtocol = true
}
maven { 
    url 'http://maven.aliyun.com/nexus/content/groups/public/' 
    allowInsecureProtocol = true    
}
```

## Solve Flutter Build Error
```bash

flutter pub upgrade --major-versions
flutter clean
cd android/
.\gradlew clean
.\gradlew build
```

## 参考
[https://docs.flutter.dev/](https://docs.flutter.dev/)
[https://stackoverflow.com/questions/59516408/flutter-app-stuck-at-running-gradle-task-assembledebug](https://stackoverflow.com/questions/59516408/flutter-app-stuck-at-running-gradle-task-assembledebug)
[https://stackoverflow.com/questions/54552962/flutter-build-error-process-command-e-flutter-apps-flutter-bin-flutter-bat](https://stackoverflow.com/questions/54552962/flutter-build-error-process-command-e-flutter-apps-flutter-bin-flutter-bat)