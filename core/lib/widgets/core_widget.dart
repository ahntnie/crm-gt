part of '../core.dart';

abstract class CoreWidget<T extends Cubit<CoreState>> extends StatefulWidget {
  final AppTheme? theme;

  const CoreWidget({
    Key? key,
    this.theme,
  }) : super(key: key);

  @protected
  Widget build(BuildContext context);
  // Widget build(BuildContext context, AppTheme theme, AppLocalizations tr);

  @protected
  @mustCallSuper
  void onInit(BuildContext context) {}

  @protected
  @mustCallSuper
  void onDispose(BuildContext context) {}

  @override
  State<CoreWidget<T>> createState() => _CoreWidgetState<T>();
}

class _CoreWidgetState<T extends Cubit<CoreState>> extends State<CoreWidget<T>> {
  @override
  void initState() {
    widget.onInit(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final theme = widget.theme ?? context.watch<T>().state.theme;
    // final t = Utils.languageOf(context);
    // return widget.build(context, theme, t);
    return widget.build(context);
  }

  @override
  void dispose() {
    widget.onDispose(context);
    super.dispose();
  }
}
