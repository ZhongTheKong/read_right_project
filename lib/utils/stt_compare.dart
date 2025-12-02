import 'dart:math';

/// -------------------------------------------------------------
/// similarity
///
/// Computes similarity between two strings using Levenshtein distance.
///
/// PRE:
///   • s1 and s2 are non-null strings
///
/// POST:
///   • Returns a double between 0.0 and 1.0
///     - 1.0 if strings are identical
///     - 0.0 if completely different
/// -------------------------------------------------------------
double similarity(String s1, String s2) {
  final len1 = s1.length;
  final len2 = s2.length;

  if (len1 == 0) return len2 == 0 ? 1.0 : 0.0;
  if (len2 == 0) return 0.0;

  // Initialize DP table for Levenshtein distance
  List<List<int>> dp = List.generate(
    len1 + 1,
    (_) => List.filled(len2 + 1, 0),
  );

  for (int i = 0; i <= len1; i++) {
    dp[i][0] = i;
  }
  for (int j = 0; j <= len2; j++) {
    dp[0][j] = j;
  }

  for (int i = 1; i <= len1; i++) {
    for (int j = 1; j <= len2; j++) {
      if (s1[i - 1] == s2[j - 1]) {
        dp[i][j] = dp[i - 1][j - 1];
      } else {
        dp[i][j] = 1 + min(
          dp[i - 1][j],    // deletion
          min(
            dp[i][j - 1],  // insertion
            dp[i - 1][j - 1] // substitution
          ),
        );
      }
    }
  }

  int distance = dp[len1][len2];
  return 1.0 - (distance / max(len1, len2));
}

/// -------------------------------------------------------------
/// Result
///
/// Example result object for pronunciation assessment.
///
/// PRE:
///   • ok: whether the assessment was successful
///   • accuracy: numeric accuracy score (0.0 to 1.0 or percentage)
///   • text: text of the word or phrase assessed
///   • wavPath: path to the recorded audio file
///
/// POST:
///   • Creates an immutable object storing assessment result
/// -------------------------------------------------------------
class Result {
  final bool ok;
  final double accuracy;
  final String text;
  final String wavPath;

  Result(this.ok, this.accuracy, this.text, this.wavPath);
}
