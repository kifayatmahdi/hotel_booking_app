class Car{
  String brand;
  String model;
  int year;
  double milesDriven = 0.0;
  static int numberOfCars = 0;

  Car(this.brand, this.model, this.year){
    numberOfCars++;
  }

  void drive(double miles){
    milesDriven += miles;
  }

  double getMilesDriven(){
    return milesDriven;
  }

  String getBrand(){
    return brand;
  }

  String getModel(){
    return model;
  }

  int getYear(){
    return year;
  }

  int getAge(){
    int currentYear = DateTime.now().year;
    return currentYear - year;
  }

}

class dog implements Car{

}

void main(){
  Car car1 = Car("Toyota", 'Carmy', 2018);
  Car car2 = Car('Honda', 'Civic', 2020);
  Car car3 = Car('Ford', 'Mustang', 2015);
  
  car1.drive(1000.0);
  car2.drive(1200.50);
  car3.drive(1850.37);
  
  print('Car-1');
  print('\tBrand: ${car1.getBrand()}');
  print('\tModel: ${car1.getModel()}');
  print('\tBrand: ${car1.getYear()}');
  print('\tDriven: ${car1.getMilesDriven()} miles');
  print('\tAge: ${car1.getAge()} years\n');

  print('Car-2');
  print('\tBrand: ${car2.getBrand()}');
  print('\tModel: ${car2.getModel()}');
  print('\tBrand: ${car2.getYear()}');
  print('\tDriven: ${car2.getMilesDriven()} miles');
  print('\tAge: ${car2.getAge()} years\n');

  print('Car-3');
  print('\tBrand: ${car3.getBrand()}');
  print('\tModel: ${car3.getModel()}');
  print('\tBrand: ${car3.getYear()}');
  print('\tDriven: ${car3.getMilesDriven()} miles');
  print('\tAge: ${car3.getAge()} years\n');
  
  print('Total number of cars: ${Car.numberOfCars}');
}