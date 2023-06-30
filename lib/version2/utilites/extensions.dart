extension CalculateBMI on double {
  double solveBmi({required height, required weight}) =>
      this + (weight / (height * height));
}

extension HeartPercent on double {
  double heartpercent() => this * (100 / 480);
}
