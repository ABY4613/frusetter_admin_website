import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String _selectedFilter = 'Last 7 Days';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildRecentReviews()),
                const SizedBox(width: 24),
                Expanded(flex: 1, child: _buildStatsSidebar()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Dashboard',
                  style: GoogleFonts.inter(
                    color: AppColors.textLight,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right, size: 16, color: AppColors.textLight),
                const SizedBox(width: 8),
                Text(
                  'Feedback',
                  style: GoogleFonts.inter(
                    color: AppColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Feedback & Insights',
              style: GoogleFonts.inter(
                color: AppColors.black,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage customer sentiment and analyze meal performance data.',
              style: GoogleFonts.inter(
                color: AppColors.textLight,
                fontSize: 16,
              ),
            ),
          ],
        ),
        _buildFilterToggle(),
      ],
    );
  }

  Widget _buildFilterToggle() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _buildFilterButton('Last 7 Days'),
          _buildFilterButton('Last Month'),
          _buildFilterButton('All Time'),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text) {
    final isSelected = _selectedFilter == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : AppColors.textLight,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildRecentReviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Reviews',
              style: GoogleFonts.inter(
                color: AppColors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Row(
                children: [
                  Text(
                    'View All',
                    style: GoogleFonts.inter(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward,
                      size: 16, color: AppColors.primaryColor),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildReviewCard(
          name: 'Sarah Jenkins',
          role: 'Verified Subscriber',
          time: '2 hours ago',
          rating: 5,
          comment:
              'Absolutely loved the Keto Salad today! The dressing was separate which kept everything crisp. The portion size was perfect for lunch. Will definitely order this one again next week.',
          item: 'Spicy Chicken Keto Salad',
          avatarColor: Colors.purple.shade100,
        ),
        const SizedBox(height: 16),
        _buildReviewCard(
          name: 'Michael Chen',
          role: 'One-time Order',
          time: 'Yesterday',
          rating: 3,
          comment:
              'The flavors were good, but the rice was a bit undercooked and hard. It made the texture unpleasant. Hope you can fix this for next time.',
          item: 'Teriyaki Salmon Bowl',
          avatarColor: Colors.blue.shade100,
        ),
        const SizedBox(height: 16),
        _buildReviewCard(
          name: 'Anita Lopez',
          role: 'Verified Subscriber',
          time: '2 Days ago',
          rating: 2,
          comment:
              'Delivery was late by 45 minutes and the food was cold. Not acceptable for a premium subscription service.',
          item: 'Delivery Service',
          isDelivery: true,
          avatarColor: Colors.orange.shade100,
        ),
      ],
    );
  }

  Widget _buildReviewCard({
    required String name,
    required String role,
    required String time,
    required int rating,
    required String comment,
    required String item,
    required Color avatarColor,
    bool isDelivery = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: avatarColor,
                    child: Text(
                      name[0],
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold, color: AppColors.black),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.inter(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        role,
                        style: GoogleFonts.inter(
                          color: AppColors.textLight,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                time,
                style: GoogleFonts.inter(
                  color: AppColors.textLight,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star,
                size: 18,
                color: index < rating
                    ? AppColors.primaryColor
                    : Colors.grey.shade300,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            comment,
            style: GoogleFonts.inter(
              color: AppColors.black.withOpacity(0.8),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      isDelivery ? Icons.local_shipping : Icons.restaurant,
                      size: 16,
                      color: AppColors.textLight,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item,
                      style: GoogleFonts.inter(
                        color: AppColors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Dismiss',
                      style: GoogleFonts.inter(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.reply, size: 16),
                    label: Text(
                      'Reply',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSidebar() {
    return Column(
      children: [
        _buildSentimentCard(),
        const SizedBox(height: 24),
        _buildTopPerformersCard(),
        const SizedBox(height: 24),
        _buildNeedsImprovementCard(),
      ],
    );
  }

  Widget _buildSentimentCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overall Sentiment',
            style: GoogleFonts.inter(
              color: AppColors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                '4.2',
                style: GoogleFonts.inter(
                  color: AppColors.black,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        size: 20,
                        color: index < 4
                            ? AppColors.primaryColor
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Based on 1,248 reviews',
                    style: GoogleFonts.inter(
                      color: AppColors.textLight,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSentimentBar(5, 0.45),
          _buildSentimentBar(4, 0.30),
          _buildSentimentBar(3, 0.15),
          _buildSentimentBar(2, 0.07),
          _buildSentimentBar(1, 0.03),
        ],
      ),
    );
  }

  Widget _buildSentimentBar(int star, double percentage) {
    Color barColor;
    if (star >= 4)
      barColor = AppColors.primaryColor;
    else if (star == 3)
      barColor = Colors.grey;
    else
      barColor = AppColors.accentRed;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 12,
            child: Text(
              '$star',
              style: GoogleFonts.inter(
                color: AppColors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey.shade100,
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 32,
            child: Text(
              '${(percentage * 100).toInt()}%',
              textAlign: TextAlign.end,
              style: GoogleFonts.inter(
                color: AppColors.textLight,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopPerformersCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, color: AppColors.primaryColor),
              const SizedBox(width: 8),
              Text(
                'Top Performers',
                style: GoogleFonts.inter(
                  color: AppColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPerformerItem(
              'Spicy Chicken Wrap', 4.9, AppColors.primaryColor),
          _buildPerformerItem('Avocado Toast', 4.7, AppColors.primaryColor),
          _buildPerformerItem('Berry Smoothie', 4.5, AppColors.primaryColor),
        ],
      ),
    );
  }

  Widget _buildNeedsImprovementCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber, color: AppColors.accentOrange),
              const SizedBox(width: 8),
              Text(
                'Needs Improvement',
                style: GoogleFonts.inter(
                  color: AppColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPerformerItem('Vegan Tofu Curry', 2.1, AppColors.accentOrange),
          _buildPerformerItem(
              'Cold Pressed Juice', 2.8, AppColors.accentOrange),
          _buildPerformerItem('Delivery Time', 3.2, AppColors.accentOrange),
        ],
      ),
    );
  }

  Widget _buildPerformerItem(String name, double score, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: GoogleFonts.inter(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                score.toString(),
                style: GoogleFonts.inter(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / 5.0,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
