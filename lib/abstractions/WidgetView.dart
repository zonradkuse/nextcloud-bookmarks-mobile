import 'package:flutter/cupertino.dart';

abstract class WidgetView<TWidget, TState> extends StatelessWidget {
  final TState state;

  TWidget get widget => (state as State).widget as TWidget;

  const WidgetView(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context);
}