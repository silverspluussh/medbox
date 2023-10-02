class Pharm {
  String name;
  String location;
  String servicenumber;
  List<String> services;
  String urllocation;

  Pharm(
      {required this.location,
      required this.name,
      required this.servicenumber,
      required this.urllocation,
      required this.services});
}

const medtests =
    'Experience the future of healthcare with our "Instant Medical Test Results Delivery" feature. Now, you can receive your rapid medical test results conveniently via SMS or directly into your Medbox app from your trusted health center. Stay informed, stay healthy, and take control of your well-being like never before.';
List<Pharm> pharmacies = [
  Pharm(
      location: 'Santa Maria',
      name: 'Espat Pharmacy',
      servicenumber: '+233506793609',
      urllocation:
          'https://www.google.com/maps/dir//ESPAT+PHARMACY,+Williams+St,+Kwashieman/data=!4m6!4m5!1m1!4e2!1m2!1m1!1s0xfdf99ec844c5439:0xe3483953495ecd55?sa=X&ved=2ahUKEwjap5HZsPL_AhVvTkEAHWB-DuwQ48ADegQIExAA&ved=2ahUKEwjap5HZsPL_AhVvTkEAHWB-DuwQ48ADegQIHBAM&hl=en',
      services: [
        'Malaria test',
        'Typhoid test',
        'Anaemia test',
        'Pregnancy test',
        'Cholesterol level test',
        'Hepatitis B test'
      ]),
  Pharm(
      location: 'Adumase',
      name: 'Nekassa Pharmacy',
      servicenumber: '+233503110300',
      urllocation: '',
      services: [
        'Malaria test',
        'Typhoid test',
        'Anaemia test',
        'Pregnancy test',
        'Cholesterol level test',
        'Hepatitis B test'
      ]),
  Pharm(
      location: 'Mayera and Afiaman',
      name: 'Klad Pharmacy',
      servicenumber: '+233500750122',
      urllocation:
          'https://www.google.com/maps/dir/5.6098816,-0.2097152/klad+pharmacy+afiaman/@5.6614054,-0.3236922,12z/data=!3m1!4b1!4m9!4m8!1m1!4e1!1m5!1m1!1s0xfdf9fedecf97667:0x10f02bcc878366c7!2m2!1d-0.2894204!2d5.712947?hl=en&entry=ttu',
      services: [
        'Malaria test',
        'Typhoid test',
        'Anaemia test',
        'Pregnancy test',
        'Cholesterol level test',
        'Hepatitis B test'
      ]),
  Pharm(
      location: 'Achimota and Tesano',
      name: 'Hale Pharmacy',
      servicenumber: '+233243709299',
      urllocation:
          'https://www.google.com/maps/dir//Hale+Pharmacy,+Achimota,+Accra/data=!4m6!4m5!1m1!4e2!1m2!1m1!1s0xfdf9b35b2944d79:0xe18bf68f56439b36?sa=X&ved=2ahUKEwie8vyqr_L_AhUjoVwKHWN4DT4Q48ADegQIDxAA&ved=2ahUKEwie8vyqr_L_AhUjoVwKHWN4DT4Q48ADegQIFhAK&hl=en',
      services: [
        'Malaria test',
        'Typhoid test',
        'Anaemia test',
        'Pregnancy test',
        'Cholesterol level test',
        'Hepatitis B test'
      ])
];

const rtest = [
  'Malaria test',
  'Typhoid test',
  'Anaemia test',
  'Pregnancy test',
  'Cholesterol level test',
  'Hepatitis B test'
];
