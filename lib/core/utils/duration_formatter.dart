/// Utility class for formatting durations into human-readable strings
class DurationFormatter {
  /// Format a Duration into a MM:SS format (e.g., 05:42)
  static String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Format a Duration into a readable string (e.g., 5 minutes, 10 seconds)
  static String formatDurationText(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    
    if (minutes > 0 && seconds > 0) {
      return '$minutes min${minutes > 1 ? 's' : ''} $seconds sec${seconds > 1 ? 's' : ''}';
    } else if (minutes > 0) {
      return '$minutes minute${minutes > 1 ? 's' : ''}';
    } else {
      return '$seconds second${seconds > 1 ? 's' : ''}';
    }
  }

  /// Format a Duration into hours and minutes (e.g., 1 hr 30 min)
  static String formatHoursAndMinutes(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    
    if (hours > 0 && minutes > 0) {
      return '$hours hr ${minutes}min';
    } else if (hours > 0) {
      return '$hours hr';
    } else {
      return '$minutes min';
    }
  }

  /// Format seconds to MM:SS
  static String formatSeconds(int seconds) {
    final duration = Duration(seconds: seconds);
    return formatDuration(duration);
  }
}
