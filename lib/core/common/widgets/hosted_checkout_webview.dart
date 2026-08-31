import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/constants/colors.dart';

enum HostedCheckoutResult { completed, cancelled, closed }

class HostedCheckoutWebView extends StatefulWidget {
  const HostedCheckoutWebView({
    super.key,
    required this.checkoutUrl,
    this.title = 'Secure checkout',
  });

  final String checkoutUrl;
  final String title;

  @override
  State<HostedCheckoutWebView> createState() => _HostedCheckoutWebViewState();
}

class _HostedCheckoutWebViewState extends State<HostedCheckoutWebView> {
  late final WebViewController _controller;
  int _progress = 0;
  String? _mainFrameError;
  bool _hasReturnedResult = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (mounted) setState(() => _progress = progress);
          },
          onPageStarted: (_) {
            if (mounted) setState(() => _mainFrameError = null);
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame != true || !mounted) return;
            setState(() => _mainFrameError = error.description);
          },
          onNavigationRequest: _handleNavigation,
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  NavigationDecision _handleNavigation(NavigationRequest request) {
    final uri = Uri.tryParse(request.url);
    if (uri == null) return NavigationDecision.prevent;

    final result = _checkoutResult(uri);
    if (result != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _finish(result));
      return NavigationDecision.prevent;
    }

    if (uri.scheme == 'http' || uri.scheme == 'https') {
      return NavigationDecision.navigate;
    }

    launchUrl(uri, mode: LaunchMode.externalApplication);
    return NavigationDecision.prevent;
  }

  HostedCheckoutResult? _checkoutResult(Uri uri) {
    if (uri.host.endsWith('stripe.com')) return null;
    final path = uri.path.toLowerCase();
    final status =
        (uri.queryParameters['status'] ??
                uri.queryParameters['payment_status'] ??
                '')
            .toLowerCase();

    if (status == 'success' ||
        status == 'succeeded' ||
        status == 'paid' ||
        path.contains('/payment/success') ||
        path.contains('/checkout/success')) {
      return HostedCheckoutResult.completed;
    }
    if (status == 'cancel' ||
        status == 'cancelled' ||
        status == 'canceled' ||
        path.contains('/payment/cancel') ||
        path.contains('/checkout/cancel')) {
      return HostedCheckoutResult.cancelled;
    }
    return null;
  }

  void _finish(HostedCheckoutResult result) {
    if (_hasReturnedResult || !mounted) return;
    setState(() => _hasReturnedResult = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.pop(context, result);
    });
  }

  Future<void> _goBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return;
    }
    _finish(HostedCheckoutResult.closed);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _hasReturnedResult,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goBack();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF101727),
          elevation: 0,
          leading: IconButton(
            tooltip: 'Back',
            onPressed: _goBack,
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          title: Text(widget.title),
          actions: [
            IconButton(
              tooltip: 'Close checkout',
              onPressed: () => _finish(HostedCheckoutResult.closed),
              icon: const Icon(Icons.close),
            ),
          ],
          bottom: _progress < 100
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(3),
                  child: LinearProgressIndicator(
                    value: _progress == 0 ? null : _progress / 100,
                    minHeight: 3,
                    color: AppColors.primary,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                  ),
                )
              : null,
        ),
        body: _mainFrameError == null
            ? WebViewWidget(controller: _controller)
            : _CheckoutLoadError(
                message: _mainFrameError!,
                onRetry: () {
                  setState(() => _mainFrameError = null);
                  _controller.reload();
                },
              ),
      ),
    );
  }
}

class _CheckoutLoadError extends StatelessWidget {
  const _CheckoutLoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_outlined,
              size: 48,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load secure checkout',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF667C9B), height: 1.4),
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
