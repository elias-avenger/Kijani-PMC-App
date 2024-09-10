class Branch {
  final String coordinator;
  final String branch;
  final List parishes;
  Branch({
    required this.coordinator,
    required this.branch,
    required this.parishes,
  });
  factory Branch.fromJson(Map<String, dynamic> data) {
    return Branch(
      coordinator: data['coordinator'],
      branch: data['branch'],
      parishes: data['parishes'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'coordinator': coordinator,
      'branch': branch,
      'parishes': parishes,
    };
  }
}
