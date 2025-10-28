class FontSizeValues {
  late double _safeBlockHorizontal;
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
    this.sixty = this._safeBlockHorizontal * (10 * 2); // 40 / 9 = 4.44
    this.fifty = this._safeBlockHorizontal * (10 * 1.5); // 40 / 9 = 4.44
    this.forty = this._safeBlockHorizontal * 10; // 40 / 9 = 4.44
    this.thirtyTwo = this._safeBlockHorizontal * (32 / 4);
    this.thirtyFour = this._safeBlockHorizontal * (34 / 4);
    this.twentyEight = this._safeBlockHorizontal * (28 / 4);
    this.twentySix = this._safeBlockHorizontal * (26 / 4);
    this.twentyFour = this._safeBlockHorizontal * (24 / 4);
    this.twentyTwo = this._safeBlockHorizontal * (22 / 4);
    this.twenty = this._safeBlockHorizontal * (20 / 4);
    this.eighteen = this._safeBlockHorizontal * (18 / 4);
    this.seventeen = this._safeBlockHorizontal * (17 / 4);
    this.sixteen = this._safeBlockHorizontal * (16 / 4);
    this.fifteen = this._safeBlockHorizontal * (15 / 4);
    this.fourteen = this._safeBlockHorizontal * (14 / 4);
    this.thirteen = this._safeBlockHorizontal * (13 / 4);
    this.twelve = this._safeBlockHorizontal * (12 / 4);
  }
}
