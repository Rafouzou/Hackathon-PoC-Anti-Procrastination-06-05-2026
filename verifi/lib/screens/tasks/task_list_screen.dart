import 'package:flutter/material.dart';
import '../../models/task_model.dart';
import '../../services/auth_service.dart';
import '../../services/task_service.dart';
import '../../theme/verifi_theme.dart';
import 'create_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _taskService = TaskService();
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Not authenticated')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        elevation: 0,
      ),
      body: StreamBuilder<List<Task>>(
        stream: _taskService.getUserTasks(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final tasks = snapshot.data ?? [];

          if (tasks.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(VerifiSpacing.md),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No tasks yet',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: VerifiSpacing.md),
                    Text(
                      'Create your first task to get started',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: VerifiColors.darkGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(VerifiSpacing.md),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return _TaskCard(
                task: task,
                userId: user.uid,
                onEdit: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CreateTaskScreen(task: task),
                    ),
                  );
                },
                onDelete: () async {
                  await _taskService.deleteTask(user.uid, task.id);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateTaskScreen(),
            ),
          );
        },
        backgroundColor: VerifiColors.yellow,
        child: const Icon(Icons.add, color: VerifiColors.black),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final Task task;
  final String userId;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TaskCard({
    required this.task,
    required this.userId,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final daysUntil = task.deadline.difference(DateTime.now()).inDays;
    final statusColor = _getStatusColor();
    final statusLabel = _getStatusLabel();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: VerifiSpacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VerifiRadius.medium),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: VerifiColors.white,
          borderRadius: BorderRadius.circular(VerifiRadius.medium),
          border: Border.all(
            color: VerifiColors.lightGrey,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(VerifiSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and status row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: VerifiSpacing.sm,
                      vertical: VerifiSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(VerifiRadius.small),
                      border: Border.all(
                        color: statusColor,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: VerifiSpacing.sm),

              // Description if exists
              if (task.description != null && task.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: VerifiSpacing.sm),
                  child: Text(
                    task.description!,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              // Deadline and verifiable info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Deadline',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: VerifiColors.darkGrey,
                        ),
                      ),
                      Text(
                        _formatDeadline(task.deadline, daysUntil),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  if (task.isVerifiable)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: VerifiSpacing.sm,
                        vertical: VerifiSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: VerifiColors.yellow.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(VerifiRadius.small),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 14,
                            color: VerifiColors.yellow,
                          ),
                          const SizedBox(width: VerifiSpacing.xs),
                          Text(
                            'Verifiable',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: VerifiColors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: VerifiSpacing.md),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onEdit,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: VerifiColors.black,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(VerifiRadius.small),
                        ),
                      ),
                      child: const Text('Edit'),
                    ),
                  ),
                  const SizedBox(width: VerifiSpacing.sm),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onDelete,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: VerifiColors.error,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(VerifiRadius.small),
                        ),
                      ),
                      child: Text(
                        'Delete',
                        style: TextStyle(color: VerifiColors.error),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (task.status) {
      case TaskStatus.verified:
        return VerifiColors.success;
      case TaskStatus.rejected:
        return VerifiColors.error;
      case TaskStatus.pending:
        return VerifiColors.info;
    }
  }

  String _getStatusLabel() {
    switch (task.status) {
      case TaskStatus.verified:
        return 'Verified';
      case TaskStatus.rejected:
        return 'Rejected';
      case TaskStatus.pending:
        return 'Pending';
    }
  }

  String _formatDeadline(DateTime deadline, int daysUntil) {
    if (daysUntil < 0) {
      return 'Overdue';
    } else if (daysUntil == 0) {
      return 'Today';
    } else if (daysUntil == 1) {
      return 'Tomorrow';
    } else {
      return 'In $daysUntil days';
    }
  }
}
