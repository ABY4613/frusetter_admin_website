import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../controller/admin_log_controller.dart';
import 'widgets/log_header.dart';
import 'widgets/log_filters.dart';
import 'widgets/log_table.dart';

class AdminLogsScreen extends StatefulWidget {
  const AdminLogsScreen({super.key});

  @override
  State<AdminLogsScreen> createState() => _AdminLogsScreenState();
}

class _AdminLogsScreenState extends State<AdminLogsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch logs when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminLogController>().fetchLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Matching dashboard background
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LogHeader(),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LogFilters(),
                    LogTable(),
                  ],
                ),
              ),
              const SizedBox(height: 40), // Extra space at bottom
            ],
          ),
        ),
      ),
    );
  }
}
