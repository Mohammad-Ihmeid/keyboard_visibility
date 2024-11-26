import 'package:flutter/material.dart';

class TextForm extends StatefulWidget {
  const TextForm({super.key});

  @override
  State<TextForm> createState() => _TextFormState();
}

class _TextFormState extends State<TextForm> with WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isKeyboardVisible = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _checkKeyboardVisibility();
    // });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _focusNode.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    Future.delayed(
      const Duration(milliseconds: 500),
      () => _checkKeyboardVisibility(),
    );
  }

  void _checkKeyboardVisibility() {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    setState(() {
      isKeyboardVisible = bottomInset > 0;
      if (isKeyboardVisible) {
        _scrollToFocusedWidget();
        // _scrollController.animateTo(
        //   bottomInset,
        //   duration: const Duration(milliseconds: 300),
        //   curve: Curves.linear,
        // );
      }
    });
  }

  void _scrollToFocusedWidget() {
    // Find the RenderBox of the focused widget
    final renderObject = _focusNode.context!.findRenderObject() as RenderBox?;
    if (renderObject != null) {
      final offset = renderObject.localToGlobal(Offset.zero).dy;

      // Calculate the scroll offset to bring the widget into view
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      final screenHeight = MediaQuery.of(context).size.height;
      final widgetHeight = renderObject.size.height;

      final targetScrollOffset = _scrollController.offset +
          offset -
          screenHeight +
          widgetHeight +
          keyboardHeight +
          100;

      setState(() {
        _scrollController.animateTo(
          targetScrollOffset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 200),
              TextFormField(
                controller: _controller,
                focusNode: _focusNode,
                onTapOutside: (event) {
                  _focusNode.unfocus();
                },
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: TextFormField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onTapOutside: (event) {
                    _focusNode.unfocus();
                  },
                  decoration: const InputDecoration(
                    hintText: 'EmailNode',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _scrollController.animateTo(
                        MediaQuery.of(context).size.height,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    });
                  },
                  child: const Text('Test')),
            ],
          ),
        ),
      ),
    );
  }
}
