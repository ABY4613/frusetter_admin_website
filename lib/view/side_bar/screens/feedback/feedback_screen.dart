import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frusette_admin_operations_web_dashboard/core/theme/app_colors.dart';
import 'package:frusette_admin_operations_web_dashboard/model/feedback_item.dart';
import 'package:provider/provider.dart';
import '../../../../controller/feedback_controller.dart';
import 'package:intl/intl.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String _selectedFilter = 'Last 7 Days';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedbackController>().fetchFeedbacks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Consumer<FeedbackController>(
        builder: (context, controller, child) {
          if (controller.isLoading && controller.feedbackResponse == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage != null &&
              controller.feedbackResponse == null) {
            return Center(child: Text(controller.errorMessage!));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 900;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(isMobile),
                    const SizedBox(height: 32),
                    if (isMobile)
                      Column(
                        children: [
                          _buildStatsSidebar(controller),
                          const SizedBox(height: 32),
                          _buildRecentReviews(controller),
                        ],
                      )
                    else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 2, child: _buildRecentReviews(controller)),
                          const SizedBox(width: 24),
                          Expanded(
                              flex: 1, child: _buildStatsSidebar(controller)),
                        ],
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Feedback', // Simplified path
                    style: GoogleFonts.inter(
                      color: AppColors.textLight,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Feedback & Insights',
                    style: GoogleFonts.inter(
                      color: AppColors.black,
                      fontSize: 24, // Smaller font
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // Filter Toggle can be below or beside if space allows.
            ],
          ),
          const SizedBox(height: 16),
          _buildFilterToggle(),
        ],
      );
    }

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

  Widget _buildRecentReviews(FeedbackController controller) {
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
        if (controller.feedbacks.isEmpty)
          const Center(child: Text('No reviews found'))
        else
          ...controller.feedbacks.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: InkWell(
                  onTap: () => _showFeedbackDetails(item),
                  borderRadius: BorderRadius.circular(24),
                  child: _buildReviewCard(
                    name: item.customerName,
                    role: 'Verified Subscriber',
                    time: DateFormat('MMM d, yyyy').format(item.createdAt),
                    rating: item.rating,
                    comment: item.comments,
                    item: item.planName,
                    avatarColor: Colors.blue.shade100,
                    isDelivery: item.feedbackType == 'delivery',
                  ),
                ),
              )),
      ],
    );
  }

  void _showFeedbackDetails(FeedbackItem item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Feedback Details',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      item.customerName.isNotEmpty ? item.customerName[0] : 'U',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                          fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.customerName,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.black),
                      ),
                      Text(
                        'Verified Subscriber',
                        style: GoogleFonts.inter(
                            fontSize: 14, color: AppColors.textLight),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '${item.rating}/5',
                    style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Comment:',
                style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(
                  item.comments,
                  style:
                      GoogleFonts.inter(fontSize: 16, color: AppColors.black),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Food Quality: ${item.foodQualityRating}/5',
                style:
                    GoogleFonts.inter(fontSize: 14, color: AppColors.textLight),
              ),
              Text(
                'Delivery Rating: ${item.deliveryRating}/5',
                style:
                    GoogleFonts.inter(fontSize: 14, color: AppColors.textLight),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Close',
                        style: TextStyle(color: AppColors.textLight)),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Reply sent to ${item.customerName}')));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Reply',
                        style: GoogleFonts.inter(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSidebar(FeedbackController controller) {
    return Column(
      children: [
        _buildSentimentCard(controller),
        const SizedBox(height: 24),
        _buildTopPerformersCard(),
        const SizedBox(height: 24),
        _buildNeedsImprovementCard(),
      ],
    );
  }

  Widget _buildSentimentCard(FeedbackController controller) {
    final summary = controller.summary;
    final avgOverall = summary?.avgOverall ?? 0.0;
    final totalReviews = summary?.totalReviews ?? 0;
    final distribution = summary?.ratingDistribution ?? {};

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
                avgOverall.toStringAsFixed(1),
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
                        color: index < avgOverall.floor()
                            ? AppColors.primaryColor
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Based on $totalReviews reviews',
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
          _buildSentimentBar(5,
              totalReviews > 0 ? (distribution['5'] ?? 0) / totalReviews : 0),
          _buildSentimentBar(4,
              totalReviews > 0 ? (distribution['4'] ?? 0) / totalReviews : 0),
          _buildSentimentBar(3,
              totalReviews > 0 ? (distribution['3'] ?? 0) / totalReviews : 0),
          _buildSentimentBar(2,
              totalReviews > 0 ? (distribution['2'] ?? 0) / totalReviews : 0),
          _buildSentimentBar(1,
              totalReviews > 0 ? (distribution['1'] ?? 0) / totalReviews : 0),
        ],
      ),
    );
  }

  Widget _buildSentimentBar(int star, double percentage) {
    Color barColor;
    if (star >= 4) {
      barColor = AppColors.primaryColor;
    } else if (star == 3)
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
