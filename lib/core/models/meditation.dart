import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

/// Meditation model representing a user-created meditation
class Meditation {
  final String id;
  final String name;
  final String userId;
  final String purpose;
  final int durationMinutes;
  final DateTime createdAt;
  final DateTime? lastPlayedAt;
  final int playCount;
  final bool isFavorite;
  final MeditationContent content;
  final MeditationAudio audio;

  Meditation({
    required this.id,
    required this.name,
    required this.userId,
    required this.purpose,
    required this.durationMinutes,
    required this.createdAt,
    this.lastPlayedAt,
    this.playCount = 0,
    this.isFavorite = false,
    required this.content,
    required this.audio,
  });

  /// Create a new meditation with default values
  factory Meditation.create({
    required String id,
    required String name,
    required String userId,
    required String purpose,
    required int durationMinutes,
    required MeditationContent content,
    required MeditationAudio audio,
  }) {
    return Meditation(
      id: id,
      name: name,
      userId: userId,
      purpose: purpose,
      durationMinutes: durationMinutes,
      createdAt: DateTime.now(),
      content: content,
      audio: audio,
    );
  }

  /// Create Meditation from Firestore document
  factory Meditation.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return Meditation(
      id: doc.id,
      name: data['name'] ?? 'Untitled Meditation',
      userId: data['userId'] ?? '',
      purpose: data['purpose'] ?? '',
      durationMinutes: data['durationMinutes'] ?? 10,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastPlayedAt: data['lastPlayedAt'] != null 
          ? (data['lastPlayedAt'] as Timestamp).toDate() 
          : null,
      playCount: data['playCount'] ?? 0,
      isFavorite: data['isFavorite'] ?? false,
      content: MeditationContent.fromMap(data['content'] ?? {}),
      audio: MeditationAudio.fromMap(data['audio'] ?? {}),
    );
  }
  
  /// Create Meditation from generic Map (for JSON serialization)
  factory Meditation.fromMap(Map<String, dynamic> map) {
    return Meditation(
      id: map['id'] ?? '',
      name: map['name'] ?? 'Untitled Meditation',
      userId: map['userId'] ?? '',
      purpose: map['purpose'] ?? '',
      durationMinutes: map['durationMinutes'] ?? 10,
      createdAt: DateTime.parse(map['createdAt']),
      lastPlayedAt: map['lastPlayedAt'] != null 
          ? DateTime.parse(map['lastPlayedAt']) 
          : null,
      playCount: map['playCount'] ?? 0,
      isFavorite: map['isFavorite'] ?? false,
      content: MeditationContent.fromMap(map['content'] ?? {}),
      audio: MeditationAudio.fromMap(map['audio'] ?? {}),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'userId': userId,
      'purpose': purpose,
      'durationMinutes': durationMinutes,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastPlayedAt': lastPlayedAt != null ? Timestamp.fromDate(lastPlayedAt!) : null,
      'playCount': playCount,
      'isFavorite': isFavorite,
      'content': content.toMap(),
      'audio': audio.toMap(),
    };
  }
  
  /// Convert to generic Map (for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
      'purpose': purpose,
      'durationMinutes': durationMinutes,
      'createdAt': createdAt.toIso8601String(),
      'lastPlayedAt': lastPlayedAt?.toIso8601String(),
      'playCount': playCount,
      'isFavorite': isFavorite,
      'content': content.toMap(),
      'audio': audio.toMap(),
    };
  }
  
  /// Convert to JSON string
  String toJson() => json.encode(toMap());

  /// Create a copy with updated fields
  Meditation copyWith({
    String? id,
    String? name,
    String? userId,
    String? purpose,
    int? durationMinutes,
    DateTime? createdAt,
    DateTime? lastPlayedAt,
    int? playCount,
    bool? isFavorite,
    MeditationContent? content,
    MeditationAudio? audio,
  }) {
    return Meditation(
      id: id ?? this.id,
      name: name ?? this.name,
      userId: userId ?? this.userId,
      purpose: purpose ?? this.purpose,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      createdAt: createdAt ?? this.createdAt,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      playCount: playCount ?? this.playCount,
      isFavorite: isFavorite ?? this.isFavorite,
      content: content ?? this.content,
      audio: audio ?? this.audio,
    );
  }

  /// Increment play count and update last played timestamp
  Meditation incrementPlayCount() {
    return copyWith(
      playCount: playCount + 1,
      lastPlayedAt: DateTime.now(),
    );
  }

  /// Toggle favorite status
  Meditation toggleFavorite() {
    return copyWith(
      isFavorite: !isFavorite,
    );
  }
}

/// Meditation content model
class MeditationContent {
  final String theme; // sleep, stress relief, focus, etc.
  final int guidanceLevel; // 1 (minimal) to 3 (detailed)
  final bool includeIntroduction;
  final bool includeBodyScan;
  final bool includeSilencePeriods;
  final bool includeClosingGratitude;
  final int silencePeriodDuration; // seconds
  final int breathingPace; // seconds per breath cycle

  MeditationContent({
    required this.theme,
    required this.guidanceLevel,
    required this.includeIntroduction,
    required this.includeBodyScan,
    required this.includeSilencePeriods,
    required this.includeClosingGratitude,
    required this.silencePeriodDuration,
    required this.breathingPace,
  });

  /// Create default meditation content
  factory MeditationContent.defaults({required String theme}) {
    return MeditationContent(
      theme: theme,
      guidanceLevel: 2, // Moderate
      includeIntroduction: true,
      includeBodyScan: true,
      includeSilencePeriods: true,
      includeClosingGratitude: true,
      silencePeriodDuration: 30, // 30 seconds
      breathingPace: 5, // 5 seconds per breath cycle
    );
  }

  /// Create from map
  factory MeditationContent.fromMap(Map<String, dynamic> map) {
    return MeditationContent(
      theme: map['theme'] ?? 'Relaxation',
      guidanceLevel: map['guidanceLevel'] ?? 2,
      includeIntroduction: map['includeIntroduction'] ?? true,
      includeBodyScan: map['includeBodyScan'] ?? true,
      includeSilencePeriods: map['includeSilencePeriods'] ?? true,
      includeClosingGratitude: map['includeClosingGratitude'] ?? true,
      silencePeriodDuration: map['silencePeriodDuration'] ?? 30,
      breathingPace: map['breathingPace'] ?? 5,
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'theme': theme,
      'guidanceLevel': guidanceLevel,
      'includeIntroduction': includeIntroduction,
      'includeBodyScan': includeBodyScan,
      'includeSilencePeriods': includeSilencePeriods,
      'includeClosingGratitude': includeClosingGratitude,
      'silencePeriodDuration': silencePeriodDuration,
      'breathingPace': breathingPace,
    };
  }

  /// Create a copy with updated fields
  MeditationContent copyWith({
    String? theme,
    int? guidanceLevel,
    bool? includeIntroduction,
    bool? includeBodyScan,
    bool? includeSilencePeriods,
    bool? includeClosingGratitude,
    int? silencePeriodDuration,
    int? breathingPace,
  }) {
    return MeditationContent(
      theme: theme ?? this.theme,
      guidanceLevel: guidanceLevel ?? this.guidanceLevel,
      includeIntroduction: includeIntroduction ?? this.includeIntroduction,
      includeBodyScan: includeBodyScan ?? this.includeBodyScan,
      includeSilencePeriods: includeSilencePeriods ?? this.includeSilencePeriods,
      includeClosingGratitude: includeClosingGratitude ?? this.includeClosingGratitude,
      silencePeriodDuration: silencePeriodDuration ?? this.silencePeriodDuration,
      breathingPace: breathingPace ?? this.breathingPace,
    );
  }
}

/// Meditation audio model
class MeditationAudio {
  final Voice voice;
  final List<Sound> backgroundSounds;
  final double backgroundVolumeDuringGuidance; // 0.0 to 1.0

  MeditationAudio({
    required this.voice,
    required this.backgroundSounds,
    required this.backgroundVolumeDuringGuidance,
  });

  /// Create default meditation audio
  factory MeditationAudio.defaults({required Voice voice}) {
    return MeditationAudio(
      voice: voice,
      backgroundSounds: [],
      backgroundVolumeDuringGuidance: 0.5,
    );
  }

  /// Create from map
  factory MeditationAudio.fromMap(Map<String, dynamic> map) {
    List<Sound> sounds = [];
    if (map['backgroundSounds'] != null) {
      sounds = (map['backgroundSounds'] as List)
          .map((sound) => Sound.fromMap(sound))
          .toList();
    }
    
    return MeditationAudio(
      voice: Voice.fromMap(map['voice'] ?? {}),
      backgroundSounds: sounds,
      backgroundVolumeDuringGuidance: map['backgroundVolumeDuringGuidance']?.toDouble() ?? 0.5,
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'voice': voice.toMap(),
      'backgroundSounds': backgroundSounds.map((sound) => sound.toMap()).toList(),
      'backgroundVolumeDuringGuidance': backgroundVolumeDuringGuidance,
    };
  }

  /// Create a copy with updated fields
  MeditationAudio copyWith({
    Voice? voice,
    List<Sound>? backgroundSounds,
    double? backgroundVolumeDuringGuidance,
  }) {
    return MeditationAudio(
      voice: voice ?? this.voice,
      backgroundSounds: backgroundSounds ?? this.backgroundSounds,
      backgroundVolumeDuringGuidance: backgroundVolumeDuringGuidance ?? this.backgroundVolumeDuringGuidance,
    );
  }
}

/// Voice model
class Voice {
  final String id;
  final String name;
  final String gender; // male, female
  final String accent; // American, British, Australian, etc.
  final String tone; // calm, energetic, soothing, etc.
  final double speed; // 0.5 to 1.5
  final double volume; // 0.0 to 1.0
  final String? assetPath; // local file path
  final String? url; // remote URL

  Voice({
    required this.id,
    required this.name,
    required this.gender,
    required this.accent,
    required this.tone,
    required this.speed,
    required this.volume,
    this.assetPath,
    this.url,
  });

  /// Create from map
  factory Voice.fromMap(Map<String, dynamic> map) {
    return Voice(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      gender: map['gender'] ?? '',
      accent: map['accent'] ?? '',
      tone: map['tone'] ?? '',
      speed: map['speed']?.toDouble() ?? 1.0,
      volume: map['volume']?.toDouble() ?? 1.0,
      assetPath: map['assetPath'],
      url: map['url'],
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'accent': accent,
      'tone': tone,
      'speed': speed,
      'volume': volume,
      'assetPath': assetPath,
      'url': url,
    };
  }

  /// Create a copy with updated fields
  Voice copyWith({
    String? id,
    String? name,
    String? gender,
    String? accent,
    String? tone,
    double? speed,
    double? volume,
    String? assetPath,
    String? url,
  }) {
    return Voice(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      accent: accent ?? this.accent,
      tone: tone ?? this.tone,
      speed: speed ?? this.speed,
      volume: volume ?? this.volume,
      assetPath: assetPath ?? this.assetPath,
      url: url ?? this.url,
    );
  }
}

/// Sound model
class Sound {
  final String id;
  final String name;
  final String category; // nature, music, ambient
  final double volume; // 0.0 to 1.0
  final String? assetPath; // local file path
  final String? url; // remote URL

  Sound({
    required this.id,
    required this.name,
    required this.category,
    required this.volume,
    this.assetPath,
    this.url,
  });

  /// Create from map
  factory Sound.fromMap(Map<String, dynamic> map) {
    return Sound(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      volume: map['volume']?.toDouble() ?? 1.0,
      assetPath: map['assetPath'],
      url: map['url'],
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'volume': volume,
      'assetPath': assetPath,
      'url': url,
    };
  }

  /// Create a copy with updated fields
  Sound copyWith({
    String? id,
    String? name,
    String? category,
    double? volume,
    String? assetPath,
    String? url,
  }) {
    return Sound(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      volume: volume ?? this.volume,
      assetPath: assetPath ?? this.assetPath,
      url: url ?? this.url,
    );
  }
}
