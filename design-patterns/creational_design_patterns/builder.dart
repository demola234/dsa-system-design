class User {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? city;
  final String? state;
  final String? zip;

  User._({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.state,
    this.zip,
});


  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, phone: $phone, address: $address, city: $city, state: $state, zip: $zip}';
  }
}


class UserBuilder {
  String? _id;
  String? _name;
  String? _email;
  String? _phone;
  String? _address;
  String? _city;
  String? _state;
  String? _zip;

  UserBuilder setId(String id) {
    _id = id;
    return this;
  }

  UserBuilder setName(String name) {
    _name = name;
    return this;
  }

  UserBuilder setEmail(String email) {
    _email = email;
    return this;
  }

  UserBuilder setPhone(String phone) {
    _phone = phone;
    return this;
  }

  UserBuilder setAddress(String address) {
    _address = address;
    return this;
  }


  UserBuilder setCity(String city) {
    _city = city;
    return this;
  }



  UserBuilder setState(String state) {
    _state = state;
    return this;
  }


    UserBuilder setZip(String zip) {
    _zip = zip;
    return this;
  }


  User build() {
    if (_name == null || _name!.isEmpty) {
      throw Exception('Name is required');
    }

    return User._(
        id: _id,
        name: _name,
        email: _email,
        phone: _phone,
        address: _address,
        city: _city,
        state: _state,
        zip: _zip,
    );
  }
}

void main() {
  final user = UserBuilder()
    .setId('123')
    .setName('John Doe')
    .setEmail('james.monroe@examplepetstore.com')
    .setPhone('1234567890')
    .setAddress('123 Main St')
    .setCity('Anytown')
    .setState('CA')
    .setZip('12345')
    .build();

  print(user);
}