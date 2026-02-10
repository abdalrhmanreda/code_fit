import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  // Navigation Stack (Breadcrumbs)
  final List<FileSystemItem> _navigationStack = [];

  // Root Data (The mock file system)
  late List<FileSystemItem> _rootItems;

  // Selection state
  final Set<String> _selectedIds = {};
  bool _isSelectionMode = false;

  // Drag state
  String? _draggedItemId;

  @override
  void initState() {
    super.initState();
    _rootItems = _generateMockData();
  }

  /// Get the items to display (current folder or root)
  List<FileSystemItem> get _currentItems {
    if (_navigationStack.isEmpty) return _rootItems;
    return _navigationStack.last.children;
  }

  String get _currentTitle {
    if (_navigationStack.isEmpty) return 'My Cloud';
    return _navigationStack.last.name;
  }

  @override
  Widget build(BuildContext context) {
    // Handle back button on Android
    return WillPopScope(
      onWillPop: () async {
        if (_navigationStack.isNotEmpty) {
          setState(() => _navigationStack.removeLast());
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            // Main File Grid
            Padding(
              padding: EdgeInsets.all(16.r),
              child: _currentItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.folder_open_rounded,
                            size: 64.r,
                            color: Colors.grey[300],
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            "This folder is empty",
                            style: GoogleFonts.dmSans(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: _currentItems.length,
                      itemBuilder: (context, index) {
                        final item = _currentItems[index];
                        return _buildFileItem(item, index);
                      },
                    ),
            ),

            // Selection Overlay / Bottom Action Bar
            if (_selectedIds.isNotEmpty)
              Positioned(
                bottom: 30.h,
                left: 20.w,
                right: 20.w,
                child: _buildSelectionBar(),
              ).animate().slideY(
                begin: 1.0,
                end: 0.0,
                duration: 300.ms,
                curve: Curves.easeOutBack,
              ),
          ],
        ),
        floatingActionButton:
            FloatingActionButton(
                  onPressed: _createNewFolder,
                  backgroundColor: const Color(0xFF5E6AD2),
                  child: const Icon(
                    Icons.create_new_folder,
                    color: Colors.white,
                  ),
                )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .moveY(
                  begin: 0,
                  end: -5,
                  curve: Curves.easeInOutSine,
                  duration: 2.seconds,
                )
                .scaleXY(
                  begin: 1.0,
                  end: 1.1,
                  curve: Curves.easeInOutSine,
                  duration: 2.seconds,
                )
                .animate()
                .scale(delay: 500.ms), // Initial entrance scale
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: _navigationStack.isNotEmpty
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black87,
              ),
              onPressed: () => setState(() => _navigationStack.removeLast()),
            )
          : null,
      title: Text(
        _currentTitle,
        style: GoogleFonts.dmSans(
          color: Colors.black87,
          fontWeight: FontWeight.w700,
          fontSize: 20.sp,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _isSelectionMode ? Icons.check : Icons.select_all,
            color: const Color(0xFF5E6AD2),
          ),
          onPressed: () {
            setState(() {
              _isSelectionMode = !_isSelectionMode;
              if (!_isSelectionMode) _selectedIds.clear();
            });
          },
        ),
        SizedBox(width: 16.w),
      ],
    );
  }

  Widget _buildFileItem(FileSystemItem item, int index) {
    final isSelected = _selectedIds.contains(item.id);
    final isDragging = _draggedItemId == item.id;

    // The core item widget content
    Widget content = Container(
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE8EAFF) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isSelected ? const Color(0xFF5E6AD2) : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          if (!isDragging)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIcon(item),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              item.name,
              style: GoogleFonts.dmSans(
                fontSize: 14.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (item.type == ItemType.folder && !isSelected) ...[
            SizedBox(height: 4.h),
            Text(
              '${item.itemCount} items',
              style: GoogleFonts.dmSans(fontSize: 10.sp, color: Colors.grey),
            ),
          ],
        ],
      ),
    );

    // Make it interactable
    Widget gestureWidget = GestureDetector(
      onLongPress: () => _toggleSelection(item.id),
      onTap: () {
        if (_isSelectionMode) {
          _toggleSelection(item.id);
        } else if (item.type == ItemType.folder) {
          // OPEN FOLDER
          setState(() {
            _navigationStack.add(item);
          });
        }
      },
      child: content,
    );

    // Apply animations: Entrance + Continuous Floating/Breathing
    Widget animatedWidget = gestureWidget
        .animate(delay: (50 * index).ms) // Staggered entrance
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad)
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
          delay: (index * 150).ms, // Randomize float start
        )
        .moveY(
          begin: 0,
          end: -3,
          curve: Curves.easeInOutSine,
          duration: 2.5.seconds,
        )
        .scaleXY(
          begin: 1.0,
          end: 1.02,
          curve: Curves.easeInOutSine,
          duration: 2.5.seconds,
        );

    // Wrap with Draggable/DragTarget
    return _buildDragAndDropWrapper(item, animatedWidget);
  }

  Widget _buildIcon(FileSystemItem item) {
    final isFolder = item.type == ItemType.folder;
    return Container(
      width: 50.r,
      height: 50.r,
      decoration: BoxDecoration(
        color: isFolder
            ? const Color(0xFFFFF4E5) // Light orange for folders
            : const Color(0xFFE5F1FF), // Light blue for files
        shape: BoxShape.circle,
      ),
      child: Icon(
        isFolder ? Icons.folder_rounded : Icons.insert_drive_file_rounded,
        color: isFolder ? const Color(0xFFFFA048) : const Color(0xFF4894FF),
        size: 28.r,
      ),
    );
  }

  Widget _buildDragAndDropWrapper(FileSystemItem item, Widget child) {
    if (item.type == ItemType.folder) {
      // Folders are Drop Targets
      return DragTarget<String>(
        onWillAccept: (draggedId) {
          return draggedId != item.id && draggedId != null;
        },
        onAccept: (draggedId) {
          _handleDrop(draggedId, item);
        },
        builder: (context, candidateData, rejectedData) {
          final isHovering = candidateData.isNotEmpty;

          return AnimatedScale(
            scale: isHovering ? 1.1 : 1.0,
            duration: 200.ms,
            child: child,
          );
        },
      );
    } else {
      // Files are Draggable
      return Draggable<String>(
        data: item.id,
        feedback: Material(
          color: Colors.transparent,
          child: _buildDragFeedback(item),
        ),
        childWhenDragging: Opacity(opacity: 0.3, child: child),
        onDragStarted: () => setState(() => _draggedItemId = item.id),
        onDragEnd: (_) => setState(() => _draggedItemId = null),
        child: child,
      );
    }
  }

  Widget _buildDragFeedback(FileSystemItem item) {
    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIcon(item),
          SizedBox(height: 8.h),
          Text(
            item.name,
            style: GoogleFonts.dmSans(
              fontSize: 12.sp,
              color: Colors.black,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_selectedIds.length} selected',
            style: GoogleFonts.dmSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Row(
            children: [
              if (_selectedIds.length == 1) ...[
                _buildActionButton(
                  Icons.edit_outlined,
                  onTap: () => _showRenameDialog(_selectedIds.first),
                ),
                SizedBox(width: 16.w),
              ],
              _buildActionButton(
                Icons.drive_file_move_outline,
                onTap: _moveSelectedItems,
              ), // Move Action
              SizedBox(width: 16.w),
              _buildActionButton(
                Icons.share_outlined,
                onTap: _shareSelectedItems,
              ),
              SizedBox(width: 16.w),
              _buildActionButton(
                Icons.delete_outline,
                isDestructive: true,
                onTap: _deleteSelectedItems,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon, {
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: isDestructive
              ? const Color(0xFFFFEBEE)
              : const Color(0xFFF5F7FA),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red : Colors.black54,
          size: 20.r,
        ),
      ),
    );
  }

  // --- Logic Methods ---

  void _createNewFolder() {
    setState(() {
      _currentItems.add(
        FileSystemItem(
          id: DateTime.now().toString(),
          name: 'New Folder',
          type: ItemType.folder,
          children: [],
        ),
      );
    });
  }

  void _shareSelectedItems() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.share_rounded, color: Colors.white),
            SizedBox(width: 12.w),
            Text(
              'Sharing ${_selectedIds.length} items...',
              style: GoogleFonts.dmSans(),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF5E6AD2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    setState(() {
      _selectedIds.clear();
      _isSelectionMode = false;
    });
  }

  void _deleteSelectedItems() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Items?',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete ${_selectedIds.length} items?',
          style: GoogleFonts.dmSans(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.dmSans(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _currentItems.removeWhere(
                  (item) => _selectedIds.contains(item.id),
                );
                _selectedIds.clear();
                _isSelectionMode = false;
              });
              Navigator.pop(context);
            },
            child: Text(
              'Delete',
              style: GoogleFonts.dmSans(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  void _showRenameDialog(String itemId) {
    final item = _currentItems.firstWhere((i) => i.id == itemId);
    final textController = TextEditingController(text: item.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Rename',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: textController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter new name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.dmSans(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                setState(() {
                  item.name = textController.text;
                });
                _selectedIds.clear();
                _isSelectionMode = false;
                Navigator.pop(context);
              }
            },
            child: Text(
              'Rename',
              style: GoogleFonts.dmSans(
                color: const Color(0xFF5E6AD2),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  void _moveSelectedItems() {
    // For now, just show a message since we rely on Drag & Drop mainly
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Drag and drop files to move them!',
          style: GoogleFonts.dmSans(),
        ),
        backgroundColor: const Color(0xFF5E6AD2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleSelection(String id) {
    setState(() {
      _isSelectionMode = true;
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
        if (_selectedIds.isEmpty) _isSelectionMode = false;
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _handleDrop(String draggedId, FileSystemItem targetFolder) {
    setState(() {
      final draggedItemIndex = _currentItems.indexWhere(
        (i) => i.id == draggedId,
      );
      if (draggedItemIndex != -1) {
        final draggedItem = _currentItems[draggedItemIndex];

        // 1. Remove from current list
        _currentItems.removeAt(draggedItemIndex);

        // 2. Add to target folder's children
        targetFolder.children.add(draggedItem);

        // 3. Show feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Moved "${draggedItem.name}" to "${targetFolder.name}"',
              style: GoogleFonts.dmSans(),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF5E6AD2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            action: SnackBarAction(
              label: 'OPEN',
              textColor: Colors.white,
              onPressed: () {
                // Navigate to that folder
                setState(() {
                  _navigationStack.add(targetFolder);
                });
              },
            ),
          ),
        );
      }
    });
  }

  List<FileSystemItem> _generateMockData() {
    // Helper to make files
    FileSystemItem makeFile(String name, String id) {
      return FileSystemItem(id: id, name: name, type: ItemType.file);
    }

    return [
      FileSystemItem(
        id: '1',
        name: 'Work Projects',
        type: ItemType.folder,
        children: [
          makeFile('Project Plan.docx', '1-1'),
          makeFile('Q3 Budget.xlsx', '1-2'),
          makeFile('Design Specs.pdf', '1-3'),
        ],
      ),
      FileSystemItem(
        id: '2',
        name: 'Personal',
        type: ItemType.folder,
        children: [makeFile('Vacation List.txt', '2-1')],
      ),
      FileSystemItem(
        id: '3',
        name: 'Images',
        type: ItemType.folder,
        children: [
          makeFile('IMG_2023.jpg', '3-1'),
          makeFile('IMG_2024.jpg', '3-2'),
          makeFile('Logo.png', '3-3'),
          makeFile('Banner.png', '3-4'),
        ],
      ),
      FileSystemItem(
        id: '4',
        name: 'Documents',
        type: ItemType.folder,
        children: [makeFile('Resume.pdf', '4-1')],
      ),
      makeFile('report.pdf', '5'),
      makeFile('vacation.jpg', '6'),
      makeFile('budget.xlsx', '7'),
      makeFile('notes.txt', '8'),
      makeFile('design.fig', '9'),
      FileSystemItem(
        id: '10',
        name: 'Music',
        type: ItemType.folder,
        children: [
          makeFile('Song 1.mp3', '10-1'),
          makeFile('Song 2.mp3', '10-2'),
        ],
      ),
    ];
  }
}

enum ItemType { folder, file }

class FileSystemItem {
  final String id;
  String name;
  final ItemType type;
  final List<FileSystemItem> children;

  FileSystemItem({
    required this.id,
    required this.name,
    required this.type,
    this.children = const [],
  });

  int get itemCount => children.length;
}
