class BottomNav {
  String? icon;
  String? title;
  BottomNav({this.icon, this.title});
}

List<BottomNav> navitems = [
  BottomNav(icon: 'assets/icons/heart-rate.png', title: 'Health tracker'),
  BottomNav(icon: 'assets/icons/first-aid-kit.png', title: 'Medication'),
  BottomNav(icon: 'assets/icons/shield.png', title: 'Medical Tests'),
];
