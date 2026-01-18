class WhoStandard {
  final int month;
  final double l;
  final double m;
  final double s;
  final double sd3neg;
  final double sd2neg;
  final double sd0;
  final double sd2pos;
  final double sd3pos;

  WhoStandard({
    required this.month,
    required this.l,
    required this.m,
    required this.s,
    required this.sd3neg,
    required this.sd2neg,
    required this.sd0,
    required this.sd2pos,
    required this.sd3pos,
  });

  factory WhoStandard.fromJson(Map<String, dynamic> json) {
    return WhoStandard(
      month: json['month'],
      l: (json['l'] as num).toDouble(),
      m: (json['m'] as num).toDouble(),
      s: (json['s'] as num).toDouble(),
      sd3neg: (json['sd3neg'] as num).toDouble(),
      sd2neg: (json['sd2neg'] as num).toDouble(),
      sd0: (json['sd0'] as num).toDouble(),
      sd2pos: (json['sd2pos'] as num).toDouble(),
      sd3pos: (json['sd3pos'] as num).toDouble(),
    );
  }
}
