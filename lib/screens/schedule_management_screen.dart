import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ScheduleManagementScreen extends StatefulWidget {
  const ScheduleManagementScreen({super.key});

  @override
  State<ScheduleManagementScreen> createState() => _ScheduleManagementScreenState();
}

class _ScheduleManagementScreenState extends State<ScheduleManagementScreen> {
  String selectedView = 'Week';
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildViewToggle(),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Schedule'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildCalendarHeader(),
          const SizedBox(height: 24),
          _buildScheduleGrid(),
        ],
      ),
    );
  }

  Widget _buildViewToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton('Day'),
          _buildToggleButton('Week'),
          _buildToggleButton('Month'),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String view) {
    bool isSelected = selectedView == view;
    return GestureDetector(
      onTap: () => setState(() => selectedView = view),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          view,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.chevron_left),
            ),
            Text(
              'March 2024',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Today'),
        ),
      ],
    );
  }

  Widget _buildScheduleGrid() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            _buildTimeHeader(),
            Expanded(child: _buildTimeSlots()),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeHeader() {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const SizedBox(width: 80, child: Text('Time', style: TextStyle(fontWeight: FontWeight.w600))),
          const Expanded(child: Text('Monday', style: TextStyle(fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
          const Expanded(child: Text('Tuesday', style: TextStyle(fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
          const Expanded(child: Text('Wednesday', style: TextStyle(fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
          const Expanded(child: Text('Thursday', style: TextStyle(fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
          const Expanded(child: Text('Friday', style: TextStyle(fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _buildTimeSlots() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        String time = '${8 + index}:00';
        return Container(
          height: 80,
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
          child: Row(
            children: [
              Container(
                width: 80,
                padding: const EdgeInsets.all(16),
                child: Text(time, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              ),
              Expanded(child: _buildScheduleCell(index == 2 ? 'MATH101\nDr. Smith\nRoom 201' : '')),
              Expanded(child: _buildScheduleCell(index == 3 ? 'ENG102\nProf. Johnson\nRoom 105' : '')),
              Expanded(child: _buildScheduleCell('')),
              Expanded(child: _buildScheduleCell(index == 1 ? 'PHYS201\nDr. Brown\nLab 3' : '')),
              Expanded(child: _buildScheduleCell('')),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScheduleCell(String content) {
    return Container(
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: content.isNotEmpty ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: content.isNotEmpty ? Border.all(color: AppColors.primary.withOpacity(0.3)) : null,
      ),
      child: Text(
        content,
        style: TextStyle(
          fontSize: 10,
          color: content.isNotEmpty ? AppColors.primary : Colors.transparent,
        ),
      ),
    );
  }
}