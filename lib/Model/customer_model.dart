class CustomerModel {
  int? id;
  String? name;
  String? owner;
  String? phone;
  String? cnic;
  String? address;
  String? area;
  String? day;

  CustomerModel(
      {this.id,
        this.name,
        this.owner,
        this.phone,
        this.cnic,
        this.address,
        this.area,
        this.day});

  CustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    owner = json['owner'];
    phone = json['phone'];
    cnic = json['cnic'];
    address = json['address'];
    area = json['area'];
    day = json['day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['owner'] = owner;
    data['phone'] = phone;
    data['cnic'] = cnic;
    data['address'] = address;
    data['area'] = area;
    data['day'] = day;
    return data;
  }
}
