import 'package:flutter/material.dart';
import '../../services/assignment_service.dart';
import '../../services/auth_service.dart';
import '../../theme/verifi_theme.dart';
import 'assignment_detail.dart';
import '../../models/assignment_model.dart';

class VerificationDashboard extends StatefulWidget {
  const VerificationDashboard({super.key});

  @override
  State<VerificationDashboard> createState() => _VerificationDashboardState();
}

class _VerificationDashboardState extends State<VerificationDashboard> {
  final _assignmentService = AssignmentService();
  final _authService = AuthService();

  String _todayDate() {
    final now = DateTime.now().toUtc();
    return '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    if (user == null) return const SizedBox.shrink();

    final date = _todayDate();

    return StreamBuilder<DailyAssignment?>(
      stream: _assignmentService.watchTodayAsVerifier(user.uid, date),
      builder: (context, snapVerifier) {
        return StreamBuilder<DailyAssignment?>(
          stream: _assignmentService.watchTodayAsOwner(user.uid, date),
          builder: (context, snapOwner) {
            final asVerifier = snapVerifier.data;
            final asOwner = snapOwner.data;

            if (asVerifier == null && asOwner == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(VerifiSpacing.md),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.checklist, size: 64, color: VerifiColors.darkGrey),
                      const SizedBox(height: VerifiSpacing.md),
                      Text('No verification duties today', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: VerifiSpacing.sm),
                      Text('You either have no verifiable tasks or assignments are not scheduled yet.', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              );
            }

            // Prefer verifier view if both exist
            final assignment = asVerifier ?? asOwner!;

            return AssignmentCard(assignment: assignment, isVerifier: asVerifier != null);
          },
        );
      },
    );
  }
}

class AssignmentCard extends StatelessWidget {
  final DailyAssignment assignment;
  final bool isVerifier;

  const AssignmentCard({required this.assignment, required this.isVerifier, super.key});

  @override
  Widget build(BuildContext context) {
    final title = isVerifier ? 'Verify ${assignment.uid}\'s tasks' : 'You are being verified by ${assignment.verifyingUserName}';

    return Padding(
      padding: const EdgeInsets.all(VerifiSpacing.md),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VerifiRadius.medium)),
        child: Padding(
          padding: const EdgeInsets.all(VerifiSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: VerifiSpacing.sm),
              Text('Date: ${assignment.date}', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: VerifiSpacing.md),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (c) => AssignmentDetail(assignment: assignment, isVerifier: isVerifier)));
                },
                child: Text(isVerifier ? 'Open to verify' : 'View verifier'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
