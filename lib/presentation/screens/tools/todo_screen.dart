import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../data/database/app_database.dart';
import '../../providers/tools/todo_provider.dart';

class TodoScreen extends ConsumerStatefulWidget {
  const TodoScreen({super.key});

  @override
  ConsumerState<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends ConsumerState<TodoScreen> {
  final _inputController = TextEditingController();
  final _inputFocusNode = FocusNode();

  @override
  void dispose() {
    _inputController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todosAsync = ref.watch(todosStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          todosAsync.maybeWhen(
            data: (todos) {
              final completedCount = todos.where((t) => t.isDone).length;
              if (completedCount > 0) {
                return TextButton.icon(
                  onPressed: () => _showClearCompletedDialog(completedCount),
                  icon: const Icon(LucideIcons.trash2, size: 16),
                  label: Text('Clear ($completedCount)'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                );
              }
              return const SizedBox.shrink();
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Input field
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    focusNode: _inputFocusNode,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Add a new task...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _addTodo(),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filled(
                  onPressed: _addTodo,
                  icon: const Icon(LucideIcons.plus),
                ),
              ],
            ),
          ),

          // Todo list
          Expanded(
            child: todosAsync.when(
              data: (todos) {
                if (todos.isEmpty) {
                  return _buildEmptyState();
                }

                final pending = todos.where((t) => !t.isDone).toList();
                final completed = todos.where((t) => t.isDone).toList();

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Stats
                    _StatsBar(
                      total: todos.length,
                      completed: completed.length,
                    ),
                    const SizedBox(height: 16),

                    // Pending tasks
                    if (pending.isNotEmpty) ...[
                      _SectionHeader(
                        title: 'Pending',
                        count: pending.length,
                      ),
                      const SizedBox(height: 8),
                      ...pending.asMap().entries.map((entry) {
                        return _TodoItem(
                          todo: entry.value,
                          onToggle: () => _toggleTodo(entry.value.id),
                          onDelete: () => _deleteTodo(entry.value.id),
                          onEdit: () => _showEditDialog(entry.value),
                        ).animate(delay: Duration(milliseconds: entry.key * 30))
                            .fadeIn()
                            .slideX(begin: 0.1, end: 0);
                      }),
                      const SizedBox(height: 24),
                    ],

                    // Completed tasks
                    if (completed.isNotEmpty) ...[
                      _SectionHeader(
                        title: 'Completed',
                        count: completed.length,
                        isCompleted: true,
                      ),
                      const SizedBox(height: 8),
                      ...completed.map((todo) {
                        return _TodoItem(
                          todo: todo,
                          onToggle: () => _toggleTodo(todo.id),
                          onDelete: () => _deleteTodo(todo.id),
                          onEdit: () => _showEditDialog(todo),
                        );
                      }),
                    ],

                    const SizedBox(height: 100),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.checkSquare,
            size: 64,
            color: Colors.grey.shade600,
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.1, 1.1),
                duration: 1000.ms,
              ),
          const SizedBox(height: 24),
          Text(
            'No Tasks Yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first task above',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade500,
                ),
          ),
        ],
      ),
    );
  }

  void _addTodo() {
    final content = _inputController.text.trim();
    if (content.isEmpty) return;

    HapticFeedback.lightImpact();
    ref.read(todoActionsProvider.notifier).addTodo(content);
    _inputController.clear();
    _inputFocusNode.requestFocus();
  }

  void _toggleTodo(String id) {
    HapticFeedback.lightImpact();
    ref.read(todoActionsProvider.notifier).toggleTodo(id);
  }

  void _deleteTodo(String id) {
    HapticFeedback.mediumImpact();
    ref.read(todoActionsProvider.notifier).deleteTodo(id);
  }

  void _showEditDialog(Todo todo) {
    final controller = TextEditingController(text: todo.content);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              ref
                  .read(todoActionsProvider.notifier)
                  .updateContent(todo.id, value);
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr()),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref
                    .read(todoActionsProvider.notifier)
                    .updateContent(todo.id, controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showClearCompletedDialog(int count) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Completed Tasks?'),
        content: Text('This will remove $count completed task${count > 1 ? 's' : ''}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr()),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              HapticFeedback.mediumImpact();
              ref.read(todoActionsProvider.notifier).clearCompleted();
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

class _StatsBar extends StatelessWidget {
  final int total;
  final int completed;

  const _StatsBar({required this.total, required this.completed});

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? completed / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$completed of $total completed',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor:
                  Theme.of(context).primaryColor.withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final bool isCompleted;

  const _SectionHeader({
    required this.title,
    required this.count,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: isCompleted ? Colors.grey : null,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: isCompleted
                ? Colors.grey.withValues(alpha: 0.2)
                : Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              color: isCompleted ? Colors.grey : Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _TodoItem({
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(LucideIcons.trash2, color: Colors.red),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          leading: GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: todo.isDone
                    ? Colors.green
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: todo.isDone ? Colors.green : Colors.grey,
                  width: 2,
                ),
              ),
              child: todo.isDone
                  ? const Icon(LucideIcons.check, size: 18, color: Colors.white)
                  : null,
            ),
          ),
          title: Text(
            todo.content,
            style: TextStyle(
              decoration: todo.isDone ? TextDecoration.lineThrough : null,
              color: todo.isDone ? Colors.grey : null,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(LucideIcons.pencil, size: 18),
            onPressed: onEdit,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
