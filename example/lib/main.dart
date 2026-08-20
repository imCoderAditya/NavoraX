import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:navorax/navorax.dart';

void main() {
  runApp(const NavoraXDemoApp());
}

class NavoraXDemoApp extends StatefulWidget {
  const NavoraXDemoApp({super.key});

  @override
  State<NavoraXDemoApp> createState() => _NavoraXDemoAppState();
}

class _NavoraXDemoAppState extends State<NavoraXDemoApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  bool _isOled = false;

  void toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
        _isOled = false;
      } else if (_themeMode == ThemeMode.dark && !_isOled) {
        _isOled = true;
      } else {
        _themeMode = ThemeMode.light;
        _isOled = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NavoraX Design System',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor:
            _isOled ? Colors.black : const Color(0xFF0F172A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
          surface: _isOled ? Colors.black : const Color(0xFF1E293B),
        ),
        useMaterial3: true,
      ),
      home: GalleryHomeScreen(
        onToggleTheme: toggleTheme,
        isOled: _isOled,
        themeMode: _themeMode,
      ),
    );
  }
}

class GalleryHomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isOled;
  final ThemeMode themeMode;

  const GalleryHomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.isOled,
    required this.themeMode,
  });

  @override
  State<GalleryHomeScreen> createState() => _GalleryHomeScreenState();
}

class _GalleryHomeScreenState extends State<GalleryHomeScreen> {
  int _currentTabIndex = 0;
  int _navIndex = 0;
  String _searchQuery = '';
  NavoraXCategory? _selectedCategory;
  final Set<String> _favorites = {};
  NavoraXConfig _activeConfig =
      NavoraXTemplateRegistry.get(NavoraXTemplateEnum.glassMorph);

  final TextEditingController _aiPromptController = TextEditingController();
  bool _isGeneratingAI = false;

  // Composer Live Builder Parameters
  NavoraXShape _composerShape = NavoraXShape.pill;
  NavoraXIndicator _composerIndicator = NavoraXIndicator.liquidBubble;
  NavoraXAnimation _composerAnimation = NavoraXAnimation.elastic;
  NavoraXBackgroundStyle _composerBgStyle = NavoraXBackgroundStyle.glassMorph;
  final Color _composerColor = const Color(0xFF6366F1);
  double _composerHeight = 64;
  double _composerElevation = 8;
  double _composerBlur = 16;

  List<NavoraXItem> get _demoItems => const [
        NavoraXItem(
          icon: Icons.home_outlined,
          activeIcon: Icons.home_rounded,
          label: 'Home',
        ),
        NavoraXItem(
          icon: Icons.explore_outlined,
          activeIcon: Icons.explore_rounded,
          label: 'Discover',
          badge: NavoraXBadge(type: NavoraXBadgeType.dot),
        ),
        NavoraXItem(
          icon: Icons.shopping_bag_outlined,
          activeIcon: Icons.shopping_bag_rounded,
          label: 'Cart',
          badge: NavoraXBadge(type: NavoraXBadgeType.count, count: 4),
        ),
        NavoraXItem(
          icon: Icons.person_outline_rounded,
          activeIcon: Icons.person_rounded,
          label: 'Profile',
        ),
      ];

  List<NavoraXConfig> get _filteredTemplates {
    List<NavoraXConfig> list = NavoraXTemplateRegistry.all;
    if (_selectedCategory != null) {
      list = list.where((t) => t.category == _selectedCategory).toList();
    }
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      list = list.where((t) {
        return t.name.toLowerCase().contains(q) ||
            t.category.name.toLowerCase().contains(q) ||
            t.shape.name.toLowerCase().contains(q) ||
            t.indicator.name.toLowerCase().contains(q);
      }).toList();
    }
    return list;
  }

  void _showCodeDialog(NavoraXConfig config) {
    final code = '''
// Implementation with NavoraX Design System
NavoraX(
  currentIndex: _currentIndex,
  config: NavoraXTemplateRegistry.get(NavoraXTemplateEnum.${config.id}),
  items: const [
    NavoraXItem(icon: Icons.home, label: 'Home'),
    NavoraXItem(icon: Icons.explore, label: 'Discover'),
    NavoraXItem(icon: Icons.shopping_bag, label: 'Cart', badge: NavoraXBadge(type: NavoraXBadgeType.count, count: 4)),
    NavoraXItem(icon: Icons.person, label: 'Profile'),
  ],
  onChanged: (index) {
    setState(() => _currentIndex = index);
  },
)
''';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Code Generator - ${config.name}'),
        content: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              code,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Color(0xFF38BDF8),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: code));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Code copied to clipboard!')),
              );
            },
            child: const Text('Copy Code'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _generateAITemplate() async {
    final prompt = _aiPromptController.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      _isGeneratingAI = true;
    });

    final aiConfig = await NavoraXAI.generate(prompt);

    setState(() {
      _isGeneratingAI = false;
      _activeConfig = aiConfig;
      _currentTabIndex = 2; // Switch to live demo tab
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('AI Template Generated for: "$prompt"')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 12,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.navigation_rounded, color: Color(0xFF6366F1)),
            SizedBox(width: 6),
            Flexible(
              child: Text(
                'NavoraX',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          // Compact Quick Template Selector Dropdown
          Tooltip(
            message: 'Quick Template Selector',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<NavoraXTemplateEnum>(
                  value: NavoraXTemplateEnum.values.firstWhere(
                    (e) => e.name == _activeConfig.id,
                    orElse: () => NavoraXTemplateEnum.glassMorph,
                  ),
                  icon: const Icon(Icons.palette_outlined,
                      color: Color(0xFF6366F1), size: 22),
                  isDense: true,
                  items: NavoraXTemplateEnum.values.map((t) {
                    return DropdownMenuItem<NavoraXTemplateEnum>(
                      value: t,
                      child: Text(
                        t.name.toUpperCase(),
                        style: const TextStyle(fontSize: 11),
                      ),
                    );
                  }).toList(),
                  onChanged: (template) {
                    if (template != null) {
                      setState(() {
                        _activeConfig = NavoraXTemplateRegistry.get(template);
                      });
                    }
                  },
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Toggle Light/Dark/OLED Theme',
            icon: Icon(
              widget.themeMode == ThemeMode.light
                  ? Icons.light_mode
                  : widget.isOled
                      ? Icons.contrast
                      : Icons.dark_mode,
              size: 22,
            ),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentTabIndex,
        children: [
          _buildGalleryTab(),
          _buildComposerTab(),
          _buildLiveDemoTab(),
          _buildAIGeneratorTab(),
        ],
      ),
      bottomNavigationBar: NavoraX(
        currentIndex: _navIndex,
        config: _activeConfig,
        items: _demoItems,
        adaptive: true,
        onChanged: (index) {
          setState(() {
            _navIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildGalleryTab() {
    final templates = _filteredTemplates;
    return Column(
      children: [
        // Search & Mode Switcher Bar
        Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText:
                        'Search 1000+ templates (glass, pill, gaming...)...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<int>(
                icon: const Icon(Icons.grid_view_rounded),
                onSelected: (idx) => setState(() => _currentTabIndex = idx),
                itemBuilder: (ctx) => [
                  const PopupMenuItem(value: 0, child: Text('1000+ Gallery')),
                  const PopupMenuItem(
                      value: 1, child: Text('Navigation Composer')),
                  const PopupMenuItem(
                      value: 2, child: Text('Live Demo Screen')),
                  const PopupMenuItem(value: 3, child: Text('AI Generator')),
                ],
              ),
            ],
          ),
        ),

        // All Categories Filter Chips Bar
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('All Categories (1000+)'),
                selected: _selectedCategory == null,
                onSelected: (_) => setState(() => _selectedCategory = null),
              ),
              const SizedBox(width: 8),
              ...NavoraXCategory.values.map((cat) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat.name.toUpperCase()),
                    selected: _selectedCategory == cat,
                    onSelected: (sel) {
                      setState(() {
                        _selectedCategory = sel ? cat : null;
                      });
                    },
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Templates List
        Expanded(
          child: ListView.builder(
            itemCount: templates.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final itemConfig = templates[index];
              final isFav = _favorites.contains(itemConfig.id);
              final isSelected = _activeConfig.id == itemConfig.id;

              return TemplatePreviewCard(
                key: ValueKey(itemConfig.id),
                config: itemConfig,
                demoItems: _demoItems,
                isSelected: isSelected,
                isFavorite: isFav,
                onToggleFavorite: () {
                  setState(() {
                    if (isFav) {
                      _favorites.remove(itemConfig.id);
                    } else {
                      _favorites.add(itemConfig.id);
                    }
                  });
                },
                onApply: () {
                  setState(() {
                    _activeConfig = itemConfig;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Applied template: ${itemConfig.name}')),
                  );
                },
                onCopyCode: () => _showCodeDialog(itemConfig),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildComposerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Navigation Composer Playground',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Combine matrix properties to create unlimited navigation designs.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Live Composer Preview
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('Live Custom Build Preview',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: NavoraX(
                      currentIndex: 0,
                      config: NavoraXNavBuilder()
                          .shape(_composerShape)
                          .indicator(_composerIndicator)
                          .animation(_composerAnimation)
                          .background(_composerBgStyle)
                          .activeColor(_composerColor)
                          .height(_composerHeight)
                          .elevation(_composerElevation)
                          .blurAmount(_composerBlur)
                          .build(),
                      items: _demoItems,
                      onChanged: (_) {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Dropdowns & Controls
          DropdownButtonFormField<NavoraXShape>(
            initialValue: _composerShape,
            decoration: const InputDecoration(labelText: 'Navigation Shape'),
            items: NavoraXShape.values.map((s) {
              return DropdownMenuItem(value: s, child: Text(s.name));
            }).toList(),
            onChanged: (v) => setState(() => _composerShape = v!),
          ),
          const SizedBox(height: 12),

          DropdownButtonFormField<NavoraXIndicator>(
            initialValue: _composerIndicator,
            decoration: const InputDecoration(labelText: 'Selection Indicator'),
            items: NavoraXIndicator.values.map((i) {
              return DropdownMenuItem(value: i, child: Text(i.name));
            }).toList(),
            onChanged: (v) => setState(() => _composerIndicator = v!),
          ),
          const SizedBox(height: 12),

          DropdownButtonFormField<NavoraXAnimation>(
            initialValue: _composerAnimation,
            decoration: const InputDecoration(labelText: 'Animation Style'),
            items: NavoraXAnimation.values.map((a) {
              return DropdownMenuItem(value: a, child: Text(a.name));
            }).toList(),
            onChanged: (v) => setState(() => _composerAnimation = v!),
          ),
          const SizedBox(height: 12),

          DropdownButtonFormField<NavoraXBackgroundStyle>(
            initialValue: _composerBgStyle,
            decoration: const InputDecoration(labelText: 'Background Style'),
            items: NavoraXBackgroundStyle.values.map((b) {
              return DropdownMenuItem(value: b, child: Text(b.name));
            }).toList(),
            onChanged: (v) => setState(() => _composerBgStyle = v!),
          ),
          const SizedBox(height: 16),

          // Height Slider
          Text('Height: ${_composerHeight.round()} px'),
          Slider(
            value: _composerHeight,
            min: 50,
            max: 90,
            onChanged: (v) => setState(() => _composerHeight = v),
          ),

          // Elevation Slider
          Text('Elevation: ${_composerElevation.round()}'),
          Slider(
            value: _composerElevation,
            min: 0,
            max: 20,
            onChanged: (v) => setState(() => _composerElevation = v),
          ),

          // Blur Slider
          Text('Glass Blur: ${_composerBlur.round()}'),
          Slider(
            value: _composerBlur,
            min: 0,
            max: 30,
            onChanged: (v) => setState(() => _composerBlur = v),
          ),
          const SizedBox(height: 16),

          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check_circle_rounded),
              label: const Text('Apply Composer Build'),
              onPressed: () {
                final customConfig = NavoraXNavBuilder()
                    .shape(_composerShape)
                    .indicator(_composerIndicator)
                    .animation(_composerAnimation)
                    .background(_composerBgStyle)
                    .activeColor(_composerColor)
                    .height(_composerHeight)
                    .elevation(_composerElevation)
                    .blurAmount(_composerBlur)
                    .build();

                setState(() {
                  _activeConfig = customConfig;
                  _currentTabIndex = 2; // Jump to live demo screen
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveDemoTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _navIndex == 0
                ? Icons.home_rounded
                : _navIndex == 1
                    ? Icons.explore_rounded
                    : _navIndex == 2
                        ? Icons.shopping_bag_rounded
                        : Icons.person_rounded,
            size: 80,
            color: const Color(0xFF6366F1),
          ),
          const SizedBox(height: 16),
          Text(
            'Active Screen Index: $_navIndex',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Current Active Config: ${_activeConfig.name}',
              style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.code),
            label: const Text('Copy Implementation Code'),
            onPressed: () => _showCodeDialog(_activeConfig),
          ),
        ],
      ),
    );
  }

  Widget _buildAIGeneratorTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NavoraX Smart AI Generator',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Type a natural language prompt to auto-generate a navigation bar.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _aiPromptController,
            decoration: InputDecoration(
              hintText: 'e.g. "Frosted glass floating bar with cyan glow"',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.auto_awesome),
                onPressed: _isGeneratingAI ? null : _generateAITemplate,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _isGeneratingAI
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton.icon(
                  icon: const Icon(Icons.bolt_rounded),
                  label: const Text('Generate with AI'),
                  onPressed: _generateAITemplate,
                ),
        ],
      ),
    );
  }
}

/// Interactive Card displaying a single NavoraX template preview with rich styling.
class TemplatePreviewCard extends StatefulWidget {
  final NavoraXConfig config;
  final List<NavoraXItem> demoItems;
  final bool isSelected;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onApply;
  final VoidCallback onCopyCode;

  const TemplatePreviewCard({
    super.key,
    required this.config,
    required this.demoItems,
    required this.isSelected,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onApply,
    required this.onCopyCode,
  });

  @override
  State<TemplatePreviewCard> createState() => _TemplatePreviewCardState();
}

class _TemplatePreviewCardState extends State<TemplatePreviewCard> {
  int _cardIndex = 0;

  @override
  Widget build(BuildContext context) {
    final previewHeight = math.max(
      96.0,
      widget.config.height + widget.config.margin.vertical + 24.0,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: widget.isSelected ? 6 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: widget.isSelected
            ? const BorderSide(color: Color(0xFF6366F1), width: 2.5)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Template Title & Favorite Star
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.config.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    widget.isFavorite
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: widget.isFavorite ? Colors.amber : Colors.grey,
                    size: 24,
                  ),
                  onPressed: widget.onToggleFavorite,
                ),
              ],
            ),

            // Metadata Chips
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _buildTag(widget.config.category.name.toUpperCase(),
                    const Color(0xFF6366F1)),
                _buildTag('Shape: ${widget.config.shape.name}',
                    const Color(0xFF0EA5E9)),
                _buildTag('Indicator: ${widget.config.indicator.name}',
                    const Color(0xFF10B981)),
                _buildTag('Anim: ${widget.config.animation.name}',
                    const Color(0xFF8B5CF6)),
              ],
            ),
            const SizedBox(height: 12),

            // Rich Gradient Background Container for High Contrast Preview
            Container(
              height: previewHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0F172A),
                    Color(0xFF1E1E38),
                    Color(0xFF0F172A),
                  ],
                ),
              ),
              child: Center(
                child: NavoraX(
                  currentIndex: _cardIndex,
                  config: widget.config,
                  items: widget.demoItems,
                  onChanged: (idx) {
                    setState(() {
                      _cardIndex = idx;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Action Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.code_rounded, size: 18),
                  label: const Text('Code'),
                  onPressed: widget.onCopyCode,
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: Icon(
                    widget.isSelected
                        ? Icons.check_circle_rounded
                        : Icons.play_arrow_rounded,
                    size: 18,
                  ),
                  label: Text(widget.isSelected ? 'Active' : 'Apply Template'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        widget.isSelected ? const Color(0xFF10B981) : null,
                    foregroundColor: widget.isSelected ? Colors.white : null,
                  ),
                  onPressed: widget.onApply,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
