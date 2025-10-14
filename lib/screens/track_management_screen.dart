import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../services/track_service.dart';

class TrackManagementScreen extends StatefulWidget {
  const TrackManagementScreen({super.key});

  @override
  State<TrackManagementScreen> createState() => _TrackManagementScreenState();
}

class _TrackManagementScreenState extends State<TrackManagementScreen> {
  final TrackService _trackService = TrackService();
  List<Map<String, dynamic>> _tracks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTracks();
  }

  Future<void> _loadTracks() async {
    try {
      final tracks = await _trackService.getAllTracks();
      if (!mounted) return;
      setState(() {
        _tracks = tracks;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

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
              const Text(
                'Track Management',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: _createTrack,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Create Track'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildStatsCards(),
          const SizedBox(height: 24),
          _buildTracksGrid(),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final totalStudents = _tracks.fold<int>(
      0,
      (sum, track) => sum + (track['students'] as int),
    );
    final activeTracks = _tracks
        .where((track) => track['status'] == 'Active')
        .length;
    final totalModules = _tracks.fold<int>(
      0,
      (sum, track) => sum + (track['modules'] as int),
    );

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              _buildStatCard(
                '${_tracks.length}',
                'Total Tracks',
                AppColors.primary,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                '$activeTracks',
                'Active Tracks',
                AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard(
                '$totalStudents',
                'Total Students',
                AppColors.secondary,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                '$totalModules',
                'Total Modules',
                AppColors.warning,
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        _buildStatCard('${_tracks.length}', 'Total Tracks', AppColors.primary),
        const SizedBox(width: 16),
        _buildStatCard('$activeTracks', 'Active Tracks', AppColors.success),
        const SizedBox(width: 16),
        _buildStatCard('$totalStudents', 'Total Students', AppColors.secondary),
        const SizedBox(width: 16),
        _buildStatCard('$totalModules', 'Total Modules', AppColors.warning),
      ],
    );
  }

  Widget _buildStatCard(String count, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTracksGrid() {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 768
        ? 1
        : screenWidth < 1200
        ? 2
        : 3;

    return Expanded(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tracks.isEmpty
          ? const Center(child: Text('No tracks found'))
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: screenWidth < 768 ? 1.5 : 1.2,
              ),
              itemCount: _tracks.length,
              itemBuilder: (context, index) => _buildTrackCard(_tracks[index]),
            ),
    );
  }

  Widget _buildTrackCard(Map<String, dynamic> track) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    track['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusChip(track['status']),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              track['description'],
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.people, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('${track['students']} students'),
                const SizedBox(width: 16),
                Icon(Icons.book, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('${track['modules']} modules'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(track['duration']),
                const SizedBox(width: 16),
                Icon(Icons.person, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(child: Text(track['instructor'])),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _viewTrackDetails(track),
                    child: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _editTrack(track),
                  icon: const Icon(Icons.edit, size: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status == 'Active' ? AppColors.success : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _createTrack() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final instructorController = TextEditingController();
    final durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Track'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Track Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: instructorController,
              decoration: const InputDecoration(
                labelText: 'Instructor',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: durationController,
              decoration: const InputDecoration(
                labelText: 'Duration (e.g., 6 months)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                final success = await _trackService.createTrack({
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'instructor': instructorController.text,
                  'duration': durationController.text,
                  'status': 'Active',
                  'modules': 0,
                });
                Navigator.pop(context);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Track created successfully')),
                  );
                  _loadTracks();
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _viewTrackDetails(Map<String, dynamic> track) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Viewing ${track['name']} details')));
  }

  void _editTrack(Map<String, dynamic> track) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Editing ${track['name']} track')));
  }
}
