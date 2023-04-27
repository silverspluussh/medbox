import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/colors.dart';
import '../../../data/datasource/fbasehelper.dart';
import '../../../data/repos/Dbhelpers/profiledb.dart';
import '../../../domain/models/pmodel.dart';
import '../../../main.dart';
import '../../../utils/extensions/photos_extension.dart';

class PersonalProfile extends StatefulWidget {
  const PersonalProfile({
    super.key,
  });

  @override
  State<PersonalProfile> createState() => _PersonalProfileState();
}

class _PersonalProfileState extends State<PersonalProfile> {
  bool editprofileoff = true;
  TextEditingController username = TextEditingController();
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    referesh();
    super.initState();
  }

  var pfp;
  bool google = false;
  String? googleid;
  late List<Map<String, dynamic>> profile = [];

  bool loading = true;
  void referesh() async {
    final data1 = await ProfileDB.querymedication();
    pfp = prefs.getString('pfp');
    google = prefs.getBool('googleloggedin') ?? false;
    googleid = prefs.getString('googlename');
    setState(() {
      profile = data1;
      loading = false;
    });
  }

  String? imagepath;
  Uint8List? imagepickedd;

  Future pickImageFromLocal() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
      allowCompression: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );
    if (result != null) {
      setState(() {
        imagepickedd = result.files.first.bytes;
        imagepath = imagepickedd.toString();
        pfp = Utility.base64String(imagepickedd!);
        prefs.setString('pfp', pfp!);
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(width: 2, color: Colors.black12),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: google == true
                              ? NetworkImage(prefs.getString('googleimage')!)
                              : pfp != null
                                  ? MemoryImage(
                                      Utility().dataFromBase64String(pfp))
                                  : const AssetImage(
                                          'assets/icons/profile-35-64.png')
                                      as ImageProvider)),
                ),
                google == false
                    ? Positioned(
                        bottom: -12,
                        right: -12,
                        child: IconButton(
                            iconSize: 25,
                            onPressed: () {
                              pickImageFromLocal().then((value) {});
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: AppColors.primaryColor,
                            )))
                    : const SizedBox()
              ],
            ).centered(),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              inputformfield(
                  controller: username,
                  widget: const Icon(Icons.person_4_outlined,
                      color: AppColors.primaryColor),
                  title: 'Username',
                  hinttext: google == true
                      ? googleid
                      : profile.isNotEmpty
                          ? profile[0]['username'] != ''
                              ? profile[0]['username']
                              : 'username'
                          : 'username',
                  width: size.width),
              inputformfield(
                  controller: fname,
                  widget: const Icon(Icons.details_outlined,
                      color: AppColors.primaryColor),
                  title: 'First name',
                  hinttext: google == true
                      ? googleid!.split(' ').first
                      : profile.isNotEmpty
                          ? profile[0]['fname'] != ''
                              ? profile[0]['fname']
                              : 'first name'
                          : 'first name',
                  width: size.width),
              inputformfield(
                  widget: const Icon(Icons.details_sharp,
                      color: AppColors.primaryColor),
                  title: 'Last name',
                  hinttext: google == true
                      ? googleid!.split(' ').last
                      : profile.isNotEmpty
                          ? profile[0]['lname'] != ''
                              ? profile[0]['lname']
                              : 'last name'
                          : 'last name',
                  width: size.width),
              inputformfield(
                  controller: email,
                  widget: const Icon(Icons.email_outlined,
                      color: AppColors.primaryColor),
                  title: 'Email address',
                  hinttext: google == true
                      ? prefs.getString('googleemail')
                      : profile.isNotEmpty
                          ? profile[0]['email'] != ''
                              ? profile[0]['email']
                              : prefs.getString('email')
                          : 'email',
                  width: size.width),
              google == false
                  ? inputformfield(
                      controller: dob,
                      widget: const Icon(Icons.date_range_outlined,
                          color: AppColors.primaryColor),
                      title: 'Date of Birth',
                      hinttext: profile.isNotEmpty
                          ? profile[0]['dob'] != ''
                              ? profile[0]['dob']
                              : 'date of birth'
                          : 'date of birth',
                      width: size.width)
                  : const SizedBox(),
              google == false
                  ? inputformfield(
                      widget: const Icon(Icons.password_outlined,
                          color: AppColors.primaryColor),
                      title: 'Password',
                      hinttext: '***********',
                      width: size.width)
                  : const SizedBox(),
              Visibility(
                visible: !editprofileoff,
                child: InkWell(
                  onTap: () async {
                    prefs.setString('username', username.text);
                    PModel pModel = PModel(
                      id: Random().nextInt(200),
                      dob: dob.text,
                      fname: fname.text,
                      lname: lname.text,
                      email: email.text,
                      username: username.text,
                    );

                    if (profile.isEmpty) {
                      await ProfileDB.insertProfile(pModel);
                    } else {
                      PModel pModel = PModel(
                        id: profile[0]['id'],
                        dob: dob.text.isNotEmpty ? dob.text : profile[0]['dob'],
                        fname: fname.text.isNotEmpty
                            ? fname.text
                            : profile[0]['fname'],
                        lname: lname.text.isNotEmpty
                            ? lname.text
                            : profile[0]['lname'],
                        email: email.text.isNotEmpty
                            ? email.text
                            : profile[0]['email'],
                        username: username.text.isNotEmpty
                            ? username.text
                            : profile[0]['username'],
                      );
                      await ProfileDB.updateprofile(pModel);
                    }
                    await updatedetails().then((value) {
                      setState(() {
                        editprofileoff = !editprofileoff;
                      });
                    }).then((value) {
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
                          style: TextStyle(
                              fontFamily: 'Popb',
                              color: Colors.white,
                              fontSize: 12),
                        ),
                      )),
                ),
              ),
              const SizedBox(height: 20),
              google == false
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          editprofileoff = !editprofileoff;
                        });
                      },
                      child: Container(
                          height: 40,
                          width: size.width - 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.primaryColor.withOpacity(0.7)),
                          child: Center(
                            child: Text(
                              editprofileoff ? 'edit profile' : 'turn off edit',
                              style: const TextStyle(
                                  fontFamily: 'Popb',
                                  color: Colors.white,
                                  fontSize: 12),
                            ),
                          )),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Powered by',
                          style: TextStyle(
                              fontFamily: 'Popb',
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                        const SizedBox(width: 20),
                        Image.asset('assets/icons/google-95-128.png',
                            height: 40, width: 40)
                      ],
                    ),
              const SizedBox(height: 100)
            ]),
            key: const ValueKey('silverlist'),
          ),
        ],
      ),
    );
  }

  Future updatedetails() async {
    email.text.isNotEmpty ? await FireBaseCLi().updateEmail(email.text) : null;

    password.text.isNotEmpty
        ? await FireBaseCLi().updatepassword(password.text)
        : null;
  }

  inputformfield(
      {required String title,
      TextEditingController? controller,
      required String hinttext,
      double? width,
      double? height,
      Widget? widget}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontFamily: 'Popb', fontSize: 12, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.black38,
              ),
              borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width! - 100,
                  height: height,
                  child: TextFormField(
                    autofocus: false,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 12),
                    keyboardType: TextInputType.name,
                    controller: controller,
                    readOnly: editprofileoff,
                    decoration: InputDecoration(
                      hintText: hinttext,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget ?? const SizedBox(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}
