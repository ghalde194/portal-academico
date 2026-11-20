// Modelos simples usados na Home: avisos do mural, notificações e banners.

/// Card do "Mural" (avisos, monitorias, eventos).
class Notice {
  final String id;
  final String title;
  final String subtitle;
  final String category;

  const Notice({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
  });

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
    id: json['id'] as String,
    title: json['title'] as String,
    subtitle: json['subtitle'] as String? ?? '',
    category: json['category'] as String? ?? '',
  );
}

/// Notificação exibida ao tocar no sino.
class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime date;
  final bool read;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.read,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
    id: json['id'] as String,
    title: json['title'] as String,
    body: json['body'] as String? ?? '',
    date: DateTime.parse(json['date'] as String),
    read: json['read'] as bool? ?? false,
  );

  AppNotification markAsRead() =>
      AppNotification(id: id, title: title, body: body, date: date, read: true);
}

/// Banner promocional (fictício) do carrossel da Home.
class PromoBannerData {
  final String id;
  final String eyebrow;
  final String title;
  final String subtitle;
  final String cta;

  /// Nome da paleta de cores definida em `AppColors.bannerPalettes`.
  final String palette;

  const PromoBannerData({
    required this.id,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.cta,
    required this.palette,
  });

  factory PromoBannerData.fromJson(Map<String, dynamic> json) => PromoBannerData(
    id: json['id'] as String,
    eyebrow: json['eyebrow'] as String? ?? '',
    title: json['title'] as String,
    subtitle: json['subtitle'] as String? ?? '',
    cta: json['cta'] as String? ?? 'Saiba mais',
    palette: json['palette'] as String? ?? 'night',
  );
}
