import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../constants/colors.dart';
import '../../../data/datasource/fbasehelper.dart';
import '../../../domain/sharedpreferences/profileshared.dart';
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
  TextEditingController phonenumber = TextEditingController();

  @override
  void initState() {
    referesh();
    super.initState();
  }

  var pfp;
  bool google = false;
  String? usernames;

  void referesh() async {
    pfp = SharedCli().getpfp();
    google = SharedCli().getgmailstatus() ?? false;
    usernames = SharedCli().getusername();
    setState(() {});
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
        SharedCli().setpfp(value: pfp);
      });
    } else {}
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
                              ? NetworkImage(SharedCli().getgpfp()!)
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
                  hinttext: usernames != null ? usernames! : 'username',
                  width: size.width),
              inputformfield(
                  controller: fname,
                  widget: const Icon(Icons.details_outlined,
                      color: AppColors.primaryColor),
                  title: 'First name',
                  hinttext: SharedCli().getfname() != null
                      ? SharedCli().getfname()!
                      : 'first name',
                  width: size.width),
              inputformfield(
                  widget: const Icon(Icons.details_sharp,
                      color: AppColors.primaryColor),
                  title: 'Last name',
                  hinttext: SharedCli().getemail() != null
                      ? SharedCli().getemail()!
                      : 'last name',
                  width: size.width),
              inputformfield(
                  controller: email,
                  widget: const Icon(Icons.email_outlined,
                      color: AppColors.primaryColor),
                  title: 'Phone number',
                  hinttext: SharedCli().getcontact() != null
                      ? SharedCli().getcontact()!
                      : 'contact',
                  width: size.width),
              inputformfield(
                  controller: email,
                  widget: const Icon(Icons.email_outlined,
                      color: AppColors.primaryColor),
                  title: 'Email address',
                  hinttext: SharedCli().getemail() != null
                      ? SharedCli().getemail()!
                      : 'email',
                  width: size.width),
              google == false
                  ? inputformfield(
                      controller: dob,
                      widget: const Icon(Icons.date_range_outlined,
                          color: AppColors.primaryColor),
                      title: 'Date of Birth',
                      hinttext: SharedCli().getdob() != null
                          ? SharedCli().getdob()!
                          : 'date of birth',
                      width: size.width)
                  : const SizedBox(),
              Visibility(
                visible: !editprofileoff,
                child: InkWell(
                  onTap: () async {
                    await updatedetails().then((value) {
                      setState(() {
                        editprofileoff = !editprofileoff;
                      });
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
    if (lname.text.isNotEmpty) {}
    if (fname.text.isNotEmpty) {
      SharedCli().firstname(value: fname.text);
    }
    if (dob.text.isNotEmpty) {
      SharedCli().dob(value: dob.text);
    }
    if (email.text.isNotEmpty) {
      await FireBaseCLi().updateEmail(email.text);
      SharedCli().email(value: dob.text);
    }

    if (lname.text.isNotEmpty) {
      SharedCli().lastname(value: lname.text);
    }
    if (username.text.isNotEmpty) {
      SharedCli().lastname(value: username.text);
    }

    if (phonenumber.text.isNotEmpty) {
      SharedCli().contact(value: phonenumber.text);
    }
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
