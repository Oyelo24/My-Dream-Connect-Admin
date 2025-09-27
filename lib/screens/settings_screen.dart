import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool emailNotifications = false;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                _buildSettingsSection('General', [
                  _buildSettingsTile('Institution Name', 'MDC Learning Platform', Icons.school),
                  _buildSettingsTile('Academic Year', '2023-2024', Icons.calendar_today),
                  _buildSettingsTile('Time Zone', 'UTC-5 (EST)', Icons.access_time),
                ]),
                const SizedBox(height: 24),
                _buildSettingsSection('Notifications', [
                  _buildSwitchTile('Push Notifications', notificationsEnabled, (value) {
                    setState(() => notificationsEnabled = value);
                  }),
                  _buildSwitchTile('Email Notifications', emailNotifications, (value) {
                    setState(() => emailNotifications = value);
                  }),
                ]),
                const SizedBox(height: 24),
                _buildSettingsSection('Appearance', [
                  _buildSwitchTile('Dark Mode', darkMode, (value) {
                    setState(() => darkMode = value);
                  }),
                  _buildSettingsTile('Language', 'English', Icons.language),
                ]),
                const SizedBox(height: 24),
                _buildSettingsSection('Security', [
                  _buildSettingsTile('Change Password', '', Icons.lock),
                  _buildSettingsTile('Two-Factor Authentication', 'Enabled', Icons.security),
                  _buildSettingsTile('Session Timeout', '30 minutes', Icons.timer),
                ]),
                const SizedBox(height: 24),
                _buildSettingsSection('Data & Privacy', [
                  _buildSettingsTile('Data Export', '', Icons.download),
                  _buildSettingsTile('Privacy Policy', '', Icons.privacy_tip),
                  _buildSettingsTile('Terms of Service', '', Icons.description),
                ]),
                const SizedBox(height: 24),
                _buildSettingsSection('System', [
                  _buildSettingsTile('Version', '1.0.0', Icons.info),
                  _buildSettingsTile('Last Updated', 'March 15, 2024', Icons.update),
                  _buildSettingsTile('Support', 'Contact Support', Icons.help),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingsTile(String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return ListTile(
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }
}