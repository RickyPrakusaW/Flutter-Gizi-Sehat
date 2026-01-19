import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/data/models/news_article_model.dart';
import 'package:intl/intl.dart';

class NewsCard extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback onTap;

  const NewsCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('d MMM yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250, // Fixed width for horizontal list
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: article.urlToImage.isNotEmpty
                  ? Image.network(
                      article.urlToImage,
                      height: 110,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 110,
                          color: Colors.grey[200],
                          child: const Center(
                              child: Icon(Icons.image, color: Colors.grey)),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 110,
                        color: Colors.grey[200],
                        child: const Center(
                            child:
                                Icon(Icons.broken_image, color: Colors.grey)),
                      ),
                    )
                  : Container(
                      height: 110,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Center(
                          child: Icon(Icons.article, color: Colors.grey)),
                    ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Badge & Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(
                                0xFFE0F2F1), // Light teal/green for 'Parenting'
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Parenting',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00796B),
                            ),
                          ),
                        ),
                        Text(
                          _formatDate(article.publishedAt),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Title
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),

                    // Author Info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 8,
                          backgroundImage: const AssetImage(
                              'assets/images/user_placeholder.png'),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            article.author ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2D3748),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
