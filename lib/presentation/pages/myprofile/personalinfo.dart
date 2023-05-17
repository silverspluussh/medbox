import 'package:MedBox/constants/fonts.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../constants/colors.dart';
import '../../../domain/sharedpreferences/sharedprefs.dart';
import '../../widgets/formfieldwidget.dart';

class PersonalProfile extends StatefulWidget {
  const PersonalProfile({Key key}) : super(key: key);

  @override
  State<PersonalProfile> createState() => _PersonalProfileState();
}

class _PersonalProfileState extends State<PersonalProfile> {
  TextEditingController address = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController number = TextEditingController();

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  void initState() {
    referesh();
    super.initState();
  }

  String usernames;

  referesh() async {
    usernames = SharedCli().getusername();
    name.text = SharedCli().getusername() ?? 'username';
    email.text = SharedCli().getemail() ?? 'email';
    age.text = SharedCli().getage();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      padding: const EdgeInsets.all(10),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(width: 2, color: Colors.black12),
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(SharedCli().getgpfp()))),
            ).centered(),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: size.height * 0.49,
                width: size.width,
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    FormfieldX(
                      controller: name,
                      readonly: true,
                      prefixicon: const Icon(
                        Icons.person_4_outlined,
                      ),
                      label: 'Username',
                      hinttext: usernames ?? 'eg. Kingsford',
                    ),
                    FormfieldX(
                      controller: email,
                      readonly: true,
                      prefixicon: const Icon(
                        Icons.email_outlined,
                      ),
                      label: 'Email',
                      hinttext: SharedCli().getemail() != null
                          ? SharedCli().getemail() ?? 'eg. user@gmail.com'
                          : 'eg. user@gmail.com',
                    ),
                    FormfieldX(
                      inputType: TextInputType.phone,
                      readonly: false,
                      controller: number,
                      prefixicon: const Icon(Icons.phone,
                          color: AppColors.primaryColor),
                      label: 'Phone number',
                      hinttext: SharedCli().getcontact() != null
                          ? SharedCli().getcontact() ?? 'eg. 0## #### ###'
                          : 'eg. 0## #### ###',
                    ),
                    FormfieldX(
                      inputType: TextInputType.number,
                      controller: age,
                      readonly: false,
                      prefixicon: const Icon(
                        Icons.person_4_outlined,
                      ),
                      label: 'Age',
                      hinttext: SharedCli().getage() != null
                          ? SharedCli().getage() ?? 'eg. 25 years old'
                          : 'eg. 25 years old',
                    ),
                    FormfieldX(
                      inputType: TextInputType.streetAddress,
                      readonly: false,
                      controller: address,
                      prefixicon: const Icon(Icons.home_max_outlined,
                          color: AppColors.primaryColor),
                      label: 'Residential Address',
                      hinttext: SharedCli().getaddress() != null
                          ? SharedCli().getaddress() ?? 'Residential Address'
                          : 'Residential Address',
                    ),
                    InkWell(
                      onTap: () async {
                        await updatedetails().then((value) {
                          setState(() {});
                        });
                      },
                      child: Container(
                          height: 40,
                          width: size.width - 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.primaryColor),
                          child: const Center(
                            child: Text(
                              'save changes',
                              style: popwhite,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Powered by',
                    style: popheaderB,
                  ),
                  const SizedBox(width: 20),
                  Image.asset('assets/icons/google-95-128.png',
                      height: 40, width: 40)
                ],
              ),
              const SizedBox(height: 100)
            ]),
          ),
        ],
      ),
    );
  }

  Future updatedetails() async {
    if (age.text.isNotEmpty) {
      SharedCli().age(value: age.text);
    }

    if (address.text.isNotEmpty) {
      SharedCli().age(value: address.text);
    }
    if (number.text.isNotEmpty) {
      SharedCli().contact(value: number.text);
    }
  }
}
