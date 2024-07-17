import 'package:ank_app/config/application.dart';
import 'package:ank_app/constants/app_const.dart';
import 'package:ank_app/entity/event/fgbg_type.dart';
import 'package:ank_app/generated/assets.dart';
import 'package:ank_app/generated/l10n.dart';
import 'package:ank_app/res/light_colors.dart';
import 'package:ank_app/res/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'main_logic.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with RouteAware, WidgetsBindingObserver {
  final logic = Get.find<MainLogic>();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppConst.routeObserver
        .subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    super.dispose();
    AppConst.routeObserver.unsubscribe(this);
  }

  @override
  void didPopNext() {
    logic.selectTab(logic.selectedIndex.value);
    super.didPopNext();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      AppConst.eventBus.fire(FGBGType.foreground);
    } else if (state == AppLifecycleState.inactive) {
      AppConst.eventBus.fire(FGBGType.background);
    }
  }

  @override
  void didPushNext() {
    Application.setSystemUiMode();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: logic.scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Obx(() {
        return IndexedStack(
            index: logic.selectedIndex.value, children: logic.tabPage);
      }),
      drawerEnableOpenDragGesture: false,
      bottomNavigationBar: Obx(() {
        return Offstage(
          offstage: logic.fullscreen.value,
          child: MyBottomBar(
            items: [
              BottomBarItem(
                Assets.bottomBarHome,
                S.current.s_home,
              ),
              BottomBarItem(
                Assets.bottomBarMarket,
                S.current.s_tickers,
              ),
              BottomBarItem(
                Assets.bottomBarBooks,
                S.current.s_order_flow,
              ),
              BottomBarItem(
                Assets.bottomBarChart,
                S.current.news,
              ),
              BottomBarItem(
                Assets.bottomBarSet,
                S.current.s_setting,
              ),
            ],
            currentIndex: logic.selectedIndex.value,
            onTap: logic.selectTab,
          ),
        );
      }),
    );
  }
}

class MyBottomBar extends StatelessWidget {
  const MyBottomBar({
    super.key,
    required this.items,
    required this.currentIndex,
    this.onTap,
  });

  final List<BottomBarItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: Get.mediaQuery.viewPadding.bottom),
      decoration: BoxDecoration(
          color: Theme.of(context).bottomAppBarTheme.color,
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, -1), blurRadius: 4)
          ]),
      child: Row(
        children: List.generate(
          items.length,
          (index) => _createItem(
            index,
            MediaQuery.of(context).size.width / 5,
            context,
          ),
        ),
      ),
    );
  }

  Widget _createItem(int i, double itemWidth, BuildContext context) {
    final item = items[i];
    final selected = i == currentIndex;
    return InkWell(
      onTap: onTap != null
          ? () {
              if (onTap != null) {
                onTap?.call(i);
              }
            }
          : null,
      child: Container(
        width: itemWidth,
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Offstage(
              offstage: selected,
              child: Image.asset(
                item.icon,
                width: 25,
                height: 25,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Offstage(
              offstage: !selected,
              child: Image.asset(
                item.icon,
                width: 25,
                height: 25,
                color: LightColors.mainBlue,
              ),
            ),
            const Gap(3),
            Text(
              item.title,
              style: Styles.tsBody_11(context)
                  .copyWith(color: selected ? Styles.cMain : null),
            ),
          ],
        ),
      ),
    );
  }
}
