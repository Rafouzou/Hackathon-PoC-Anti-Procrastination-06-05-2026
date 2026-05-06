import 'package:flutter/material.dart';
import '../../models/task_model.dart';
import '../../services/auth_service.dart';
import '../../services/task_service.dart';
import '../../theme/verifi_theme.dart';
import '../../widgets/verifi_button.dart';

class CreateTaskScreen extends StatefulWidget {
  final Task? task;

  const CreateTaskScreen({super.key, this.task});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDeadline;
  late bool _isVerifiable;
  final _taskService = TaskService();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    _selectedDeadline =
        widget.task?.deadline ?? DateTime.now().add(const Duration(days: 1));
    _isVerifiable = widget.task?.isVerifiable ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDeadline(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: VerifiColors.yellow,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDeadline) {
      setState(() {
        _selectedDeadline = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a task title'),
          backgroundColor: VerifiColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = _authService.currentUser;
      if (user == null) return;

      if (widget.task == null) {
        // Create new task
        await _taskService.createTask(
          uid: user.uid,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          deadline: _selectedDeadline,
          isVerifiable: _isVerifiable,
        );
      } else {
        // Update existing task
        final updatedTask = widget.task!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          deadline: _selectedDeadline,
          isVerifiable: _isVerifiable,
        );
        await _taskService.updateTask(user.uid, updatedTask);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: VerifiColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Create Task'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(VerifiSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title field
              Text(
                'Task Title',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: VerifiSpacing.sm),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'What do you need to do?',
                  labelText: 'Title',
                ),
                maxLength: 100,
              ),
              const SizedBox(height: VerifiSpacing.lg),

              // Description field
              Text(
                'Description (optional)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: VerifiSpacing.sm),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Add more details...',
                  labelText: 'Description',
                ),
                maxLines: 3,
                maxLength: 500,
              ),
              const SizedBox(height: VerifiSpacing.lg),

              // Deadline picker
              Text(
                'Deadline',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: VerifiSpacing.sm),
              GestureDetector(
                onTap: () => _selectDeadline(context),
                child: Container(
                  padding: const EdgeInsets.all(VerifiSpacing.md),
                  decoration: BoxDecoration(
                    color: VerifiColors.lightGrey,
                    borderRadius: BorderRadius.circular(VerifiRadius.medium),
                    border: Border.all(
                      color: VerifiColors.border,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected date',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: VerifiColors.darkGrey,
                            ),
                          ),
                          const SizedBox(height: VerifiSpacing.xs),
                          Text(
                            _formatDate(_selectedDeadline),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.calendar_today,
                        color: VerifiColors.yellow,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: VerifiSpacing.lg),

              // Verifiable toggle
              Container(
                padding: const EdgeInsets.all(VerifiSpacing.md),
                decoration: BoxDecoration(
                  color: VerifiColors.yellow.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(VerifiRadius.medium),
                  border: Border.all(
                    color: VerifiColors.yellow,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Allow peer verification',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: VerifiSpacing.xs),
                        Text(
                          'Others can verify this task was completed',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: VerifiColors.darkGrey,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: _isVerifiable,
                      onChanged: (value) {
                        setState(() => _isVerifiable = value);
                      },
                      activeThumbColor: VerifiColors.yellow,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: VerifiSpacing.xl),

              // Save button
              VerifiButton(
                label: isEditing ? 'Update Task' : 'Create Task',
                onPressed: _saveTask,
                isLoading: _isLoading,
              ),
              const SizedBox(height: VerifiSpacing.md),

              // Cancel button
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  side: const BorderSide(
                    color: VerifiColors.black,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(VerifiRadius.medium),
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Tomorrow';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
