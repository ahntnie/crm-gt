part of '../main_tab.dart';

class MainTabView extends StatefulWidget {
  final StatefulNavigationShell child;
  const MainTabView(this.child, {super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> with TickerProviderStateMixin {
  final _name = ['Trang chủ', 'Thông báo', 'Danh bạ', 'Tài khoản'];
  final _iconList = <IconData>[
    Icons.home,
    Icons.notifications,
    Icons.perm_contact_cal,
    Icons.account_circle,
  ];
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> _borderRadiusAnimation;
  late CurvedAnimation borderRadiusCurve;

  @override
  void initState() {
    super.initState();
    _borderRadiusAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    borderRadiusCurve = CurvedAnimation(
      parent: _borderRadiusAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );

    _borderRadiusAnimation = Tween<double>(begin: 0, end: 1).animate(
      borderRadiusCurve,
    );

    Future.delayed(
      const Duration(seconds: 1),
      () => _borderRadiusAnimationController.forward(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MainTabCubit>().getInit(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabCubit = context.watch<MainTabCubit>();
    final stateApp = context.watch<AppCubit>().state;

    return SwipeBackWrapper(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        //floatingActionButton: _floatingActionButton(theme, tabCubit),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        //bottomNavigationBar: _bottomNavigationBar(theme, tabCubit),
        body: widget.child,
      ),
    );
  }

  _floatingActionButton(AppTheme theme, MainTabCubit tabCubit) {
    return FloatingActionButton(
      shape: const CircleBorder(),
      backgroundColor: tabCubit.state.isActiveFAB == true
          ? theme.colors.primary
          : theme.colors.gray700.withOpacity(0.85),
      onPressed: () {
        _borderRadiusAnimationController.reset();
        _borderRadiusAnimationController.forward();
        tabCubit.switchAdd();
        widget.child.goBranch(4);
      },
      child: const Icon(Icons.add_rounded, color: Colors.white, size: 36),
    );
  }

  _bottomNavigationBar(AppTheme theme, MainTabCubit tabCubit) {
    return AnimatedBottomNavigationBar.builder(
      itemCount: _iconList.length,
      tabBuilder: (int index, bool isActive) {
        if (tabCubit.state.isActiveFAB) {
          isActive = false;
        }
        final color = isActive ? theme.colors.primary : theme.colors.gray700.withOpacity(0.85);
        return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 4,
            ),
            Icon(
              _iconList[index],
              size: 24,
              color: color,
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: AutoSizeText(
                _name[index],
                maxLines: 1,
                style: TextStyle(color: color),
                group: AutoSizeGroup(),
              ),
            )
          ],
        );
      },
      height: 62,
      backgroundColor: Colors.white,
      activeIndex: tabCubit.state.currentIndex,
      splashColor: theme.colors.background,
      notchAndCornersAnimation: _borderRadiusAnimation,
      splashSpeedInMilliseconds: 300,
      notchSmoothness: NotchSmoothness.defaultEdge,
      gapLocation: GapLocation.center,
      leftCornerRadius: 20,
      rightCornerRadius: 20,
      onTap: (value) {
        tabCubit.changeIndex(value);
        widget.child.goBranch(value);
      },
      shadow: BoxShadow(
          offset: const Offset(0, 1),
          blurRadius: 5,
          spreadRadius: 0.5,
          color: theme.colors.gray700),
    );
  }
}
