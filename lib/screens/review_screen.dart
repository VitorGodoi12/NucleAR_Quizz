import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nuclear_quizdefinitivo/data/app_progress.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.watch<AppProgress>().reviewItems;
    return Scaffold(
      appBar: AppBar(title: Text('Revisar respostas')),
      body: items.isEmpty
          ? Center(child: Text('Nenhuma resposta para revisar.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                final options = (item['options'] as List?) ?? const [];
                final answerIndex = item['correctIndex'] as int? ?? -1;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['text']?.toString() ?? '',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        if (answerIndex >= 0 && answerIndex < options.length)
                          Text(
                            'Resposta: ${options[answerIndex]}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        if ((item['explanation']?.toString() ?? '')
                            .isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(item['explanation'].toString()),
                        ],
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => context
                                .read<AppProgress>()
                                .removeReviewItem(item),
                            icon: const Icon(Icons.check_circle_outline),
                            label: Text('Concluir revisão'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
