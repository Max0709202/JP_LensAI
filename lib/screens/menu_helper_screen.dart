import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../models/menu_item_result.dart';
import '../models/phrase.dart';
import '../services/ai_service.dart';
import '../services/storage_service.dart';
import '../widgets/app_primary_button.dart';
import '../widgets/loading_view.dart';
import '../widgets/result_section_card.dart';
import '../widgets/warning_badge.dart';

class MenuHelperScreen extends StatefulWidget {
  const MenuHelperScreen({
    super.key,
    required this.aiService,
    required this.storageService,
  });

  final AiService aiService;
  final StorageService storageService;

  @override
  State<MenuHelperScreen> createState() => _MenuHelperScreenState();
}

class _MenuHelperScreenState extends State<MenuHelperScreen> {
  final _picker = ImagePicker();
  XFile? _image;
  MenuItemResult? _item;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu Helper')),
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
            label: 'Analyze Menu',
            icon: Icons.restaurant_rounded,
            onPressed: _loading ? null : _analyze,
          ),
          if (_loading) const LoadingView(message: 'Checking the menu...'),
          const SizedBox(height: 12),
          if (_item != null)
            _MenuItemCard(
              item: _item!,
              onCopy: () => _copyPhrase(_item!),
              onSave: () => _savePhrase(_item!),
            ),
        ],
      ),
    );
  }

  Future<void> _pick(ImageSource source) async {
    final image = await _picker.pickImage(source: source, imageQuality: 80);
    if (image == null) return;
    setState(() {
      _image = image;
      _item = null;
    });
  }

  Future<void> _analyze() async {
    if (_image == null) {
      _snack('Please select or take a photo first.');
      return;
    }
    setState(() => _loading = true);
    try {
      final item = await widget.aiService.analyzeMenuImage(_image!.path);
      if (!mounted) return;
      setState(() => _item = item);
    } catch (_) {
      _snack('Sorry, the menu could not be analyzed.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _savePhrase(MenuItemResult item) async {
    await widget.storageService.savePhrase(
      Phrase(
        id: const Uuid().v4(),
        englishTitle: item.usefulPhraseEnglish,
        japanese: item.usefulPhraseJapanese,
        romaji: item.usefulPhraseRomaji,
        english: item.usefulPhraseEnglish,
        category: 'Menu',
        note: 'Useful for asking about ${item.dishName}.',
        createdAt: DateTime.now(),
      ),
    );
    _snack('Phrase saved.');
  }

  Future<void> _copyPhrase(MenuItemResult item) async {
    await Clipboard.setData(
      ClipboardData(
        text:
            '${item.usefulPhraseJapanese}\n${item.usefulPhraseRomaji}\n${item.usefulPhraseEnglish}',
      ),
    );
    _snack('Phrase copied.');
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _MenuItemCard extends StatelessWidget {
  const _MenuItemCard({
    required this.item,
    required this.onSave,
    required this.onCopy,
  });

  final MenuItemResult item;
  final VoidCallback onSave;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return ResultSectionCard(
      title: item.dishName,
      icon: Icons.ramen_dining_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.japaneseName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Text(item.description),
          const SizedBox(height: 12),
          _ListLine(title: 'Main ingredients', values: item.ingredients),
          _ListLine(title: 'Allergy risks', values: item.allergyRisks),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tag in [...item.allergyRisks, ...item.dietaryTags])
                WarningBadge(label: tag),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            item.usefulPhraseJapanese,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(item.usefulPhraseRomaji),
          Text(item.usefulPhraseEnglish),
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
    );
  }
}

class _ListLine extends StatelessWidget {
  const _ListLine({required this.title, required this.values});

  final String title;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text('$title: ${values.join(', ')}'),
    );
  }
}
