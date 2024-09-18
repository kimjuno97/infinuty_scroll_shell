import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class InfinityScrollShell extends StatefulWidget {
  /// The widget below this widget in the tree.
  ///
  /// This widget can be any widget that you want to be scrollable, typically a
  /// [Column] or a [ListView].
  ///
  /// For example:
  /// ```dart
  /// InfinityScrollShell(
  ///   child: Column(
  ///     children: [
  ///       SomeWidget(),
  ///       ListView.builder(
  ///         shrinkWrap: true,
  ///         physics: NeverScrollableScrollPhysics(),
  ///         itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
  ///         itemCount: 100,
  ///       ),
  ///     ],
  ///   ),
  /// )
  /// ```
  ///
  /// The [child] is wrapped in a [SingleChildScrollView] internally,
  /// so you don't need to use [SingleChildScrollView] directly as the child of this widget.
  final Widget child;

  /// Used to fetch more data for infinite scrolling
  /// This callback function is called based on the `[NOTE] conditions for fetching more data`
  /// so it's essential to implement loading handling within this function.
  final void Function()? maxScrollExtentObserverFn;

  /// Custom ScrollController for the scrollable content.
  ///
  /// If not provided, a default ScrollController will be created internally.
  ///
  /// Providing a custom controller allows for more advanced scroll behavior control.
  ///
  /// IMPORTANT: If you provide a custom ScrollController, you are responsible for
  /// calling dispose() on it when it's no longer needed to avoid memory leaks.
  ///
  /// This widget will not dispose of externally provided controllers.
  final ScrollController? scrollController;

  /// If true, FAB will not be displayed
  /// When this is true, [fabIcon] should be null.
  final bool disableFab;

  /// Custom icon for the Floating Action Button (FAB).
  /// If not provided, a default upward arrow icon will be used.
  /// This should be null if [disableFab] is true.
  final Widget? fabIcon;
  const InfinityScrollShell({
    super.key,
    required this.child,
    this.maxScrollExtentObserverFn,
    this.scrollController,
    this.disableFab = false,
    this.fabIcon,
  }) : assert(
          (disableFab == true && fabIcon == null) || (disableFab == false),
          'disableFab이 true일 때는 fabIcon이 null이어야 합니다. '
          'disableFab이 false일 때는 fabIcon이 null이거나 아닐 수 있습니다.',
        );

  @override
  State<InfinityScrollShell> createState() => _InfinityScrollShellState();
}

class _InfinityScrollShellState extends State<InfinityScrollShell> {
  late final ScrollController _scrollController =
      (widget.scrollController ?? ScrollController())
        ..addListener(
          () {
            _handleScroll();

            /// 최하단까지의 길이
            final maxScrollExtent = _scrollController.position.maxScrollExtent;

            /// 스크롤된 위치
            final scrollOffset = _scrollController.offset;

            /// [NOTE] Conditions for fetching more data:
            /// - When there's only 100 pixels left to scroll
            /// - When scrolled more than 70% of the screen height
            if (maxScrollExtent - scrollOffset <= 100 &&
                scrollOffset > MediaQuery.of(context).size.height / 0.7 &&
                widget.maxScrollExtentObserverFn != null) {
              widget.maxScrollExtentObserverFn!();
            }
          },
        );

  bool _showFab = false;

  void _handleScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (!_showFab) {
        setState(() {
          _showFab = true;
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (_showFab) {
        setState(() {
          _showFab = false;
        });
      }
    }
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _floatingActionButton(),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: widget.child,
      ),
    );
  }

  Widget? _floatingActionButton() {
    if (!_showFab || widget.disableFab == true) return null;

    return FloatingActionButton(
      shape: const CircleBorder(),
      elevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      onPressed: () {
        _scrollController
            .animateTo(
          0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
        )
            .then(
          (value) {
            _showFab = false;
            setState(() {});
          },
        );
      },
      child: widget.fabIcon ?? const Icon(Icons.arrow_upward),
    );
  }
}
