import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../core/constants/app_colors.dart';
import '../core/services/serverpod_service.dart';
import '../models/report_model.dart';

class OfficerResolutionDialog extends StatefulWidget {
  final CivicIssueItem issue;
  final VoidCallback onResolved;

  const OfficerResolutionDialog({
    super.key,
    required this.issue,
    required this.onResolved,
  });

  @override
  State<OfficerResolutionDialog> createState() => _OfficerResolutionDialogState();
}

class _OfficerResolutionDialogState extends State<OfficerResolutionDialog> {
  final TextEditingController _remarksController = TextEditingController();
  String? _afterPhotoName;
  Uint8List? _afterPhotoBytes;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _remarksController.text = 'Municipal maintenance crew dispatched. Work completed according to civic safety standards.';
  }

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  void _pickAfterPhoto() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _afterPhotoName = result.files.first.name;
          _afterPhotoBytes = result.files.first.bytes;
        });
      }
    } catch (e) {
      setState(() {
        _afterPhotoName = 'repair_proof_${DateTime.now().millisecondsSinceEpoch}.jpg';
      });
    }
  }

  void _handleResolution() async {
    setState(() {
      _isSubmitting = true;
    });

    String photoRef = _afterPhotoName ?? 'resolution_proof.jpg';
    if (_afterPhotoBytes != null && _afterPhotoName != null) {
      final cloudRef = await ServerpodService().uploadImage(_afterPhotoBytes!, _afterPhotoName!);
      if (cloudRef != null) {
        photoRef = cloudRef;
      }
    }

    final rawId = int.tryParse(widget.issue.id.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
    await ServerpodService().resolveIssue(
      issueId: rawId,
      description: _remarksController.text.trim(),
      afterImageReference: photoRef,
    );

    setState(() {
      _isSubmitting = false;
    });

    if (mounted) {
      Navigator.of(context).pop();
      widget.onResolved();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Container(
        width: 520,
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.resolvedBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.verified_rounded, color: AppColors.resolved, size: 24),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Municipal Officer Resolution',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                      ),
                    ),
                    Text(
                      'Issue: ${widget.issue.title} (${widget.issue.id})',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Issue Summary Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: widget.issue.statusBgColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.issue.statusLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: widget.issue.statusColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.issue.category,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.issue.location,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // After Repair Photo Proof
            const Text(
              'Attach After-Repair Photo Evidence',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickAfterPhoto,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _afterPhotoName != null ? AppColors.resolved : AppColors.border,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _afterPhotoName != null ? Icons.check_circle_rounded : Icons.camera_alt_outlined,
                      color: _afterPhotoName != null ? AppColors.resolved : AppColors.primary,
                      size: 28,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _afterPhotoName != null ? 'Evidence Attached: $_afterPhotoName' : 'Upload photo showing resolved site',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _afterPhotoName != null ? AppColors.resolved : AppColors.navy,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Resolution remarks
            const Text(
              'Resolution Remarks',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _remarksController,
              maxLines: 2,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                contentPadding: const EdgeInsets.all(14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Mark Resolved Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _handleResolution,
                icon: const Icon(Icons.check_circle_rounded, size: 20),
                label: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Mark Resolved & Update Public Feed',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.resolved,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
