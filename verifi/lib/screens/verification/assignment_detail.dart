import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/assignment_model.dart';
import '../../models/message_model.dart';
import '../../services/assignment_service.dart';
import '../../services/auth_service.dart';
import '../../theme/verifi_theme.dart';
import '../../services/task_service.dart';
import '../../models/task_model.dart';

class AssignmentDetail extends StatefulWidget {
  final DailyAssignment assignment;
  final bool isVerifier;

  const AssignmentDetail({super.key, required this.assignment, required this.isVerifier});

  @override
  State<AssignmentDetail> createState() => _AssignmentDetailState();
}

class _AssignmentDetailState extends State<AssignmentDetail> {
  final _assignmentService = AssignmentService();
  final _taskService = TaskService();
  final _authService = AuthService();
  final _textController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ownerId = widget.assignment.uid;
    final docId = '${widget.assignment.date}_${widget.assignment.uid}';

    return Scaffold(
      appBar: AppBar(title: Text(widget.isVerifier ? 'Verify tasks' : 'Assignment')),
      body: StreamBuilder<List<Task>>(
        stream: _taskService.getUserTasks(ownerId),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final tasks = snap.data?.where((t) => widget.assignment.taskIds.contains(t.id)).toList() ?? [];

          return Column(
            children: [
              // Tasks section
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(VerifiSpacing.md),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, i) {
                            final t = tasks[i];
                            return ListTile(
                              title: Text(t.title),
                              subtitle: Text(t.description ?? ''),
                              trailing: Text(t.status.name),
                            );
                          },
                        ),
                      ),
                      if (widget.isVerifier) ...[
                        const SizedBox(height: VerifiSpacing.md),
                        if (_loading) const CircularProgressIndicator() else Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: VerifiColors.success),
                                onPressed: _onVerify,
                                child: const Text('Verify'),
                              ),
                            ),
                            const SizedBox(width: VerifiSpacing.sm),
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(side: const BorderSide(color: VerifiColors.error)),
                                onPressed: _onReject,
                                child: const Text('Reject'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              // Chat section
              Expanded(
                flex: 1,
                child: _ChatWidget(
                  assignmentDocId: docId,
                  assignmentService: _assignmentService,
                  authService: _authService,
                  textController: _textController,
                  onSendingChanged: (value) {},
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _onVerify() async {
    setState(() => _loading = true);
    try {
      final verifier = _authService.currentUser;
      if (verifier == null) {
        setState(() => _loading = false);
        return;
      }
      final docId = '${widget.assignment.date}_${widget.assignment.uid}';
      await _assignmentService.verifyAssignment(
        assignmentDocId: docId,
        ownerId: widget.assignment.uid,
        taskIds: widget.assignment.taskIds,
        verifierId: verifier.uid,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      final msg = 'Error: $e';
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _onReject() async {
    setState(() => _loading = true);
    try {
      final verifier = _authService.currentUser;
      if (verifier == null) {
        setState(() => _loading = false);
        return;
      }
      final docId = '${widget.assignment.date}_${widget.assignment.uid}';
      await _assignmentService.rejectAssignment(assignmentDocId: docId, verifierId: verifier.uid);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      final msg = 'Error: $e';
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

// Chat widget for messages
class _ChatWidget extends StatefulWidget {
  final String assignmentDocId;
  final AssignmentService assignmentService;
  final AuthService authService;
  final TextEditingController textController;
  final Function(bool) onSendingChanged;

  const _ChatWidget({
    required this.assignmentDocId,
    required this.assignmentService,
    required this.authService,
    required this.textController,
    required this.onSendingChanged,
  });

  @override
  State<_ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<_ChatWidget> {
  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Messages list
        Expanded(
          child: StreamBuilder<List<VerifiMessage>>(
            stream: widget.assignmentService.watchMessages(widget.assignmentDocId),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final messages = snap.data ?? [];
              final currentUser = widget.authService.currentUser;

              if (messages.isEmpty) {
                return Center(
                  child: Text(
                    'No messages yet',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }

              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(VerifiSpacing.sm),
                itemCount: messages.length,
                itemBuilder: (context, i) {
                  final msg = messages[messages.length - 1 - i];
                  final isCurrentUser = msg.senderUid == currentUser?.uid;

                  return Align(
                    alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: VerifiSpacing.xs),
                      padding: const EdgeInsets.all(VerifiSpacing.sm),
                      decoration: BoxDecoration(
                        color: isCurrentUser ? VerifiColors.primary : VerifiColors.surface,
                        borderRadius: BorderRadius.circular(VerifiRadius.md),
                        border: !isCurrentUser ? Border.all(color: VerifiColors.border) : null,
                      ),
                      child: Column(
                        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          if (msg.imageUrl != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(VerifiRadius.sm),
                              child: Image.network(
                                msg.imageUrl!,
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 150,
                                    width: 150,
                                    color: VerifiColors.border,
                                    child: const Icon(Icons.broken_image),
                                  );
                                },
                              ),
                            ),
                          if (msg.imageUrl != null) const SizedBox(height: VerifiSpacing.xs),
                          Text(
                            msg.text,
                            style: TextStyle(
                              color: isCurrentUser ? VerifiColors.white : VerifiColors.text,
                            ),
                          ),
                          const SizedBox(height: VerifiSpacing.xs),
                          Text(
                            msg.senderName,
                            style: TextStyle(
                              fontSize: 11,
                              color: isCurrentUser ? VerifiColors.white.withValues(alpha: 0.7) : VerifiColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        // Input area
        Padding(
          padding: const EdgeInsets.all(VerifiSpacing.sm),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: _sending ? null : _pickAndSendImage,
              ),
              Expanded(
                child: TextField(
                  controller: widget.textController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(VerifiRadius.md)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: VerifiSpacing.sm, vertical: VerifiSpacing.xs),
                  ),
                  enabled: !_sending,
                ),
              ),
              IconButton(
                icon: _sending ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send),
                onPressed: _sending ? null : _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _sendMessage() async {
    if (widget.textController.text.isEmpty) return;

    setState(() => _sending = true);
    widget.onSendingChanged(true);

    try {
      final user = widget.authService.currentUser;
      if (user == null) throw Exception('Not authenticated');

      await widget.assignmentService.sendMessage(
        assignmentDocId: widget.assignmentDocId,
        senderUid: user.uid,
        senderName: user.name,
        text: widget.textController.text,
      );

      widget.textController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending message: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _sending = false);
        widget.onSendingChanged(false);
      }
    }
  }

  Future<void> _pickAndSendImage() async {
    setState(() => _sending = true);
    widget.onSendingChanged(true);

    try {
      final user = widget.authService.currentUser;
      if (user == null) throw Exception('Not authenticated');

      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        setState(() => _sending = false);
        widget.onSendingChanged(false);
        return;
      }

      await widget.assignmentService.sendImageMessage(
        assignmentDocId: widget.assignmentDocId,
        senderUid: user.uid,
        senderName: user.name,
        imageFile: image,
        caption: widget.textController.text.isNotEmpty ? widget.textController.text : null,
      );

      widget.textController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending image: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _sending = false);
        widget.onSendingChanged(false);
      }
    }
  }
}
