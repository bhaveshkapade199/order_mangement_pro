import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/constants/app_colors.dart';
import '../../core/network/api_client.dart';
import '../../core/storage/token_storage.dart';

class ServerConfigDialog extends StatefulWidget {
  const ServerConfigDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const ServerConfigDialog(),
    );
  }

  @override
  State<ServerConfigDialog> createState() => _ServerConfigDialogState();
}

class _ServerConfigDialogState extends State<ServerConfigDialog> {
  late final TextEditingController _urlController;
  bool _isTesting = false;
  String? _testResult;
  bool _testSuccess = false;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: ApiEndpoints.baseUrl);
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _testConnection() async {
    final candidateUrl = _urlController.text.trim();
    if (candidateUrl.isEmpty) return;

    setState(() {
      _isTesting = true;
      _testResult = null;
    });

    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 4),
        receiveTimeout: const Duration(seconds: 4),
      ));
      final cleanUrl = candidateUrl.endsWith('/')
          ? candidateUrl.substring(0, candidateUrl.length - 1)
          : candidateUrl;
      final res = await dio.get('$cleanUrl/products');
      if (res.statusCode == 200) {
        setState(() {
          _isTesting = false;
          _testSuccess = true;
          _testResult = 'Success! Connected to FlowPro backend.';
        });
      } else {
        setState(() {
          _isTesting = false;
          _testSuccess = false;
          _testResult = 'Server responded with status code: ${res.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isTesting = false;
        _testSuccess = false;
        _testResult = 'Connection failed: ${e.toString().split('\n').first}';
      });
    }
  }

  void _applyUrl(String url) {
    setState(() {
      _urlController.text = url;
      _testResult = null;
    });
  }

  Future<void> _saveAndClose() async {
    final newUrl = _urlController.text.trim();
    if (newUrl.isNotEmpty) {
      ApiEndpoints.setBaseUrl(newUrl);
      ApiClient().updateBaseUrl(ApiEndpoints.baseUrl);
      await TokenStorage.saveServerUrl(ApiEndpoints.baseUrl);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Server URL set to: ${ApiEndpoints.baseUrl}'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: const [
          Icon(Icons.dns_outlined, color: AppColors.primary),
          SizedBox(width: 8),
          Text('Server Connection', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select or enter the IP address of the machine running the backend server:',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Backend Base URL',
                border: OutlineInputBorder(),
                hintText: 'http://10.105.194.97:5000/api',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Quick Presets:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.wifi, size: 14),
                  label: const Text('Wi-Fi LAN (Mobile)', style: TextStyle(fontSize: 11)),
                  onPressed: () => _applyUrl(ApiEndpoints.defaultWifiUrl),
                ),
                ActionChip(
                  avatar: const Icon(Icons.usb, size: 14),
                  label: const Text('USB / Localhost', style: TextStyle(fontSize: 11)),
                  onPressed: () => _applyUrl(ApiEndpoints.defaultLocalhostUrl),
                ),
                ActionChip(
                  avatar: const Icon(Icons.android, size: 14),
                  label: const Text('Android Emulator', style: TextStyle(fontSize: 11)),
                  onPressed: () => _applyUrl(ApiEndpoints.defaultEmulatorUrl),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  icon: _isTesting
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.network_check, size: 16),
                  label: const Text('Test Connection', style: TextStyle(fontSize: 12)),
                  onPressed: _isTesting ? null : _testConnection,
                ),
              ],
            ),
            if (_testResult != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _testSuccess
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(
                      _testSuccess ? Icons.check_circle : Icons.error_outline,
                      size: 16,
                      color: _testSuccess ? AppColors.success : AppColors.error,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _testResult!,
                        style: TextStyle(
                          fontSize: 11,
                          color: _testSuccess ? AppColors.success : AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: _saveAndClose,
          child: const Text('Save & Apply', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
