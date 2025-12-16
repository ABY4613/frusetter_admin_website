class FeedbackItem {
  final String id;
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;
  final String? profileImageUrl;

  FeedbackItem({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
    this.profileImageUrl,
  });
}
