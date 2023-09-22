import 'package:lansonndehplumbing/core/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ViewWebPages extends StatefulWidget {
  final String initialUrl;
  final String? userAgent;
  final Future<NavigationDecision> Function(NavigationRequest)?
      navigationDelegage;
  const ViewWebPages(
      {Key? key,
      required this.initialUrl,
      this.navigationDelegage,
      this.userAgent})
      : super(key: key);

  @override
  State<ViewWebPages> createState() => _ViewWebPagesState();
}

class _ViewWebPagesState extends State<ViewWebPages> {
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WebView(
                initialUrl: widget.initialUrl, //authorizationUrl,
                javascriptMode: JavascriptMode.unrestricted,
                userAgent: widget.userAgent,
                navigationDelegate: widget.navigationDelegage,
                onPageFinished: (controller) {
                  setState(() {
                    isLoading = false;
                  });
                }),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: CustomIconButton(
        color: Colors.blue,
        borderColor: Colors.blue,
        icon: const Icon(
          Icons.arrow_back,
          size: 30,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
