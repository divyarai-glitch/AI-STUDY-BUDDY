import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../theme/app_theme.dart';
import 'home_screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  // Change this to your actual backend URL
  static const String _uploadUrl = 'http://localhost:8080/api/notes/upload';

  String? _selectedFileName;
  String? _selectedFilePath;    // mobile/desktop
  Uint8List? _selectedFileBytes; // web

  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();

  bool _isUploading = false;
  double _uploadProgress = 0;

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  Future<void> _pickPDF() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true, // load bytes always, simplest for multipart upload
      );

      if (result == null || result.files.isEmpty) {
        debugPrint('File picker: no file selected');
        return;
      }

      final file = result.files.single;

      setState(() {
        _selectedFileName = file.name;
        _selectedFilePath = kIsWeb ? null : file.path;
        _selectedFileBytes = file.bytes;
        _titleController.text = file.name.replaceAll('.pdf', '');
      });
    } catch (e) {
      debugPrint('File picker error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting file: $e')),
        );
      }
    }
  }

  Future<void> _upload() async {
    if (_selectedFileName == null || _selectedFileBytes == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to upload.')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
    });

    try {
      // Optional: get Firebase ID token to authenticate the request on the backend
      final idToken = await user.getIdToken();

      final uri = Uri.parse(_uploadUrl);
      final request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer $idToken';

      request.fields['title'] = _titleController.text.trim();
      request.fields['subject'] = _subjectController.text.trim();
      request.fields['userId'] = user.uid;

      request.files.add(
        http.MultipartFile.fromBytes(
          'file', // must match the @RequestParam name in Spring Boot
          _selectedFileBytes!,
          filename: _selectedFileName!,
        ),
      );

      // Simulated progress since http package doesn't expose upload progress
      // natively — swap to dio if you need real byte-level progress.
      setState(() => _uploadProgress = 0.3);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      setState(() => _uploadProgress = 0.9);

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() => _uploadProgress = 1.0);
        if (mounted) {
          setState(() => _isUploading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Upload successful! AI is processing your notes.'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
          Navigator.pop(context);
        }
      } else {
        throw Exception('Server error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      debugPrint('Upload error: $e');
      if (mounted) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Upload Notes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upload Your Notes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Upload a PDF and let AI summarize it for you',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),

            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: _pickPDF,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: _selectedFileName != null
                        ? AppColors.primary.withOpacity(0.05)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _selectedFileName != null
                          ? AppColors.primary
                          : AppColors.borderColor,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _selectedFileName != null
                            ? Icons.check_circle_rounded
                            : Icons.cloud_upload_outlined,
                        size: 52,
                        color: _selectedFileName != null
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _selectedFileName != null
                            ? _selectedFileName!
                            : 'Tap to select a PDF',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: _selectedFileName != null
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (_selectedFileName == null) ...[
                        const SizedBox(height: 6),
                        const Text(
                          'PDF files only, up to 50MB',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'e.g. Data Structures Chapter 1',
                prefixIcon: Icon(Icons.title_rounded, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                hintText: 'e.g. Computer Science',
                prefixIcon: Icon(Icons.school_outlined, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 32),

            if (_isUploading) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Uploading...',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${(_uploadProgress * 100).toInt()}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _uploadProgress,
                      minHeight: 8,
                      backgroundColor: AppColors.borderColor,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],

            ElevatedButton.icon(
              onPressed: (_selectedFileName != null && !_isUploading) ? _upload : null,
              icon: const Icon(Icons.upload_rounded, color: Colors.white),
              label: const Text('Upload & Analyze'),
            ),
          ],
        ),
      ),
    );
  }
}