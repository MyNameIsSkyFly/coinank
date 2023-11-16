
JetBrain的IDE需要使用FlutterAssetGenerator来生成资源文件引用 ，VS Code对应的插件需要找一下

需要跑一下命令行生成代码以确保项目正常跑起来：
1.  dart run build_runner build --delete-conflicting-outputs 
    或者
    dart run build_runner watch
2.  sh pigeons/run_pigeon.s

