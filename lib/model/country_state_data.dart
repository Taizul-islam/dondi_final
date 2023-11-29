class CountryStateData {
  List<CountryState>? data;

  CountryStateData({this.data});

  CountryStateData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CountryState>[];
      json['data'].forEach((v) {
        data!.add(new CountryState.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CountryState {
  int? id;
  String? name;

  CountryState({this.id, this.name});

  CountryState.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}