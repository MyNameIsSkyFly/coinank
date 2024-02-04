import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// 标题栏
class AppTitleBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTitleBar({
    super.key,
    this.backgroundColor, //标题栏底色
    this.title = '', //标题内容
    this.actionTextName = '', //右边（仅限单个文字）按钮名称
    this.actionIconName = '', //右边（仅限单个icon）按钮
    this.backImg, //返回按钮图片
    this.leadingWidth,
    this.onBack, //返回按钮点击事件
    this.onActionPressed, //右边（仅限单个文字）的点击事件
    this.titleColor, //标题颜色
    this.titleFontSize, //标题字号
    this.backColor, //返回按钮颜色
    this.actionWidget, //右边
    this.bottomWidget, //底部
    this.customWidget, //完全自定义appbar
    this.hideBackBtn = false, //隐藏返回键
    this.systemOverlayStyle,
    this.leftWidget,
  });

  final Color? backgroundColor;
  final String title;
  final Widget? backImg;
  final double? leadingWidth;
  final String actionTextName;
  final String actionIconName;
  final VoidCallback? onBack;
  final VoidCallback? onActionPressed;
  final Color? titleColor;
  final double? titleFontSize;
  final Color? backColor;
  final Widget? actionWidget;
  final PreferredSizeWidget? bottomWidget;
  final Widget? customWidget;
  final Widget? leftWidget;
  final bool hideBackBtn;
  final SystemUiOverlayStyle? systemOverlayStyle;

  @override
  Widget build(BuildContext context) {
    return customWidget != null
        ? AnnotatedRegion<SystemUiOverlayStyle>(
            value: Theme.of(context).appBarTheme.systemOverlayStyle!,
            child: SafeArea(child: customWidget!),
          )
        : AppBar(
            elevation: 0,
            bottom: bottomWidget,
            systemOverlayStyle:
                Theme.of(context).appBarTheme.systemOverlayStyle,
            backgroundColor:
                backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
            leadingWidth: leadingWidth ?? 56,
            leading: leftWidget != null
                ? leftWidget!
                : Navigator.canPop(context) && !hideBackBtn
                    ? InkWell(
                        onTap: onBack ?? Get.back,
                        child: Container(
                          height: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: backImg ??
                              Image.asset(
                                Assets.commonIconArrowLeft,
                                width: 20,
                                height: 20,
                                color: Theme.of(context).iconTheme.color,
                              ),
                        ),
                      )
                    : null,
            title: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Styles.tsBody_18m(context),
            ),
            centerTitle: true,
            actions: [
              if (actionWidget != null)
                actionWidget!
              else if (actionTextName.isNotEmpty)
                InkWell(
                  onTap: onActionPressed,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    alignment: Alignment.center,
                    child: Text(
                      actionTextName,
                      key: const Key('actionName'),
                      style: Styles.tsBody_14(context).copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ),
                )
              else if (actionIconName.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: IconButton(
                    onPressed: onActionPressed,
                    icon: Image.asset(
                      actionIconName,
                      width: 20,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints.tight(
                      const Size(20, 20),
                    ),
                  ),
                ),
            ],
          );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
