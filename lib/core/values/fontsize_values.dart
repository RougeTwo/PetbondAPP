class FontSizeValues {
  late final double _safeBlockHorizontal;
  late double sixty;
  late double fifty;
  late double forty;
  late double thirtyFour;
  late double thirtyTwo;
  late double twentyEight;
  late double twentySix;
  late double twentyFour;
  late double twentyTwo;
  late double twenty;
  late double eighteen;
  late double seventeen;
  late double sixteen;
  late double fifteen;
  late double fourteen;
  late double thirteen;
  late double twelve;

  FontSizeValues(this._safeBlockHorizontal) {
    sixty = _safeBlockHorizontal * (10 * 2); // 40 / 9 = 4.44
    fifty = _safeBlockHorizontal * (10 * 1.5); // 40 / 9 = 4.44
    forty = _safeBlockHorizontal * 10; // 40 / 9 = 4.44
    thirtyTwo = _safeBlockHorizontal * (32 / 4);
    thirtyFour = _safeBlockHorizontal * (34 / 4);
    twentyEight = _safeBlockHorizontal * (28 / 4);
    twentySix = _safeBlockHorizontal * (26 / 4);
    twentyFour = _safeBlockHorizontal * (24 / 4);
    twentyTwo = _safeBlockHorizontal * (22 / 4);
    twenty = _safeBlockHorizontal * (20 / 4);
    eighteen = _safeBlockHorizontal * (18 / 4);
    seventeen = _safeBlockHorizontal * (17 / 4);
    sixteen = _safeBlockHorizontal * (16 / 4);
    fifteen = _safeBlockHorizontal * (15 / 4);
    fourteen = _safeBlockHorizontal * (14 / 4);
    thirteen = _safeBlockHorizontal * (13 / 4);
    twelve = _safeBlockHorizontal * (12 / 4);
  }
}
