class HlsLinkExcluder {
  final Set<String> _links = {};

  void addLink(String link) {
    _links.add(link);
  }

  bool contains(String link) {
    return _links.contains(link);
  }

  bool get isEmpty => _links.isEmpty;
}
