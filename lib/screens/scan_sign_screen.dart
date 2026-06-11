import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../models/ai_result.dart';
import '../models/phrase.dart';
import '../services/ai_service.dart';
import '../services/storage_service.dart';
import '../widgets/app_primary_button.dart';
import '../widgets/loading_view.dart';
import '../widgets/result_section_card.dart';
import '../widgets/warning_badge.dart';

class ScanSignScreen extends StatefulWidget {
  const ScanSignScreen({
    super.key,
    required this.aiService,
    required this.storageService,
  });

  final AiService aiService;
  final StorageService storageService;

  @override
  State<ScanSignScreen> createState() => _ScanSignScreenState();
}

class _ScanSignScreenState extends State<ScanSignScreen> {
  final _picker = ImagePicker();
  XFile? _image;
  AiResult? _result;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Japanese Sign')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AppPrimaryButton(
                label: 'Take Photo',
                icon: Icons.camera_alt_rounded,
                onPressed: () => _pick(ImageSource.camera),
              ),
              AppPrimaryButton(
                label: 'Choose From Gallery',
                icon: Icons.photo_library_rounded,
                secondary: true,
                onPressed: () => _pick(ImageSource.gallery),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (_image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(_image!.path),
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 14),
          AppPrimaryButton(
            label: 'Analyze Sign',
            icon: Icons.travel_explore_rounded,
            onPressed: _loading ? null : _analyze,
          ),
          if (_loading) const LoadingView(message: 'Reading the sign...'),
          if (_result != null) ...[
            const SizedBox(height: 16),
            _SignResultView(
              result: _result!,
              onCopy: _copyPhrase,
              onSave: _savePhrase,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pick(ImageSource source) async {
    final image = await _picker.pickImage(source: source, imageQuality: 80);
    if (image == null) return;
    setState(() {
      _image = image;
      _result = null;
    });
  }

  Future<void> _analyze() async {
    if (_image == null) {
      _snack('Please select or take a photo first.');
      return;
    }
    setState(() => _loading = true);
    try {
      final result = await widget.aiService.analyzeSignImage(_image!.path);
      if (!mounted) return;
      setState(() => _result = result);
    } catch (_) {
      _snack('Sorry, the sign could not be analyzed.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _savePhrase() async {
    final result = _result;
    if (result == null) return;
    await widget.storageService.savePhrase(
      Phrase(
        id: const Uuid().v4(),
        englishTitle: result.phraseEnglish,
        japanese: result.phraseJapanese,
        romaji: result.phraseRomaji,
        english: result.phraseEnglish,
        category: result.category,
        note: result.travelerAction,
        createdAt: DateTime.now(),
      ),
    );
    _snack('Phrase saved.');
  }

  Future<void> _copyPhrase() async {
    final result = _result;
    if (result == null) return;
    await Clipboard.setData(
      ClipboardData(
        text:
            '${result.phraseJapanese}\n${result.phraseRomaji}\n${result.phraseEnglish}',
      ),
    );
    _snack('Phrase copied.');
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SignResultView extends StatelessWidget {
  const _SignResultView({
    required this.result,
    required this.onCopy,
    required this.onSave,
  });

  final AiResult result;
  final VoidCallback onCopy;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ResultSectionCard(
          title: 'Detected Japanese Text',
          child: Text(
            result.detectedText,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        ResultSectionCard(
          title: 'Translation',
          child: Text(result.translation),
        ),
        ResultSectionCard(
          title: 'Simple Explanation',
          child: Text(result.explanation),
        ),
        ResultSectionCard(
          title: 'What To Do Next',
          child: Text(result.travelerAction),
        ),
        ResultSectionCard(
          title: 'Category & Warning',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              WarningBadge(label: result.category),
              WarningBadge(label: result.warningLevel),
            ],
          ),
        ),
        ResultSectionCard(
          title: 'Useful Phrase',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result.phraseJapanese,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 4),
              Text(result.phraseRomaji),
              const SizedBox(height: 4),
              Text(result.phraseEnglish),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  AppPrimaryButton(
                    label: 'Save Phrase',
                    icon: Icons.bookmark_add_rounded,
                    onPressed: onSave,
                  ),
                  AppPrimaryButton(
                    label: 'Copy Phrase',
                    icon: Icons.copy_rounded,
                    secondary: true,
                    onPressed: onCopy,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
