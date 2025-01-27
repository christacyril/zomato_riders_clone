class Address {

  String? name;
  String? phoneNumber;
  String? flatNumber;
  String? city;
  String? state;
  String? completeAddress;
  double? lat;
  double? lng;

  Address({
    this.name,
    this.phoneNumber,
    this.flatNumber,
    this.city,
    this.state,
    this.completeAddress,
    this.lat,
    this.lng,
});

  Address.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    phoneNumber = json["phoneNumber"];
    flatNumber = json["flatNumber"];
    city = json["city"];
    state = json["state"];
    completeAddress = json["completeAddress"];
    lat = json["lat"];
    lng = json["lng"];
  }

  Map<String, dynamic> toJson () {
    final Map <String, dynamic> data = Map<String, dynamic> ();
    data ["name"] = name;
    data ["phoneNumber"] = phoneNumber;
    data ["flatNumber"] = flatNumber;
    data ["city"] = city;
    data ["state"] = state;
    data ["completeAddress"] = completeAddress;
    data ["lat"] = lat;
    data ["lng"] = lng;
    return data;
  }

}