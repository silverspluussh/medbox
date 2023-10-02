import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/version2/models/medication_model.dart';
import 'package:MedBox/version2/wiis/txt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../firebase/medicfirebase.dart';
import '../../wiis/formfieldwidget.dart';

class EditMedication extends ConsumerStatefulWidget {
  const EditMedication(this.model, {super.key});
  final MModel model;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditMedicationState();
}

class _EditMedicationState extends ConsumerState<EditMedication> {
  TextEditingController name = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController dose = TextEditingController();
  TextEditingController time = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    type.dispose();
    dose.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(color: kBackgroundColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.width,
                  child: HStack([
                    Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 0.5)),
                        child: IconButton(
                            onPressed: () => context.pop(context),
                            icon: const Icon(Icons.close,
                                size: 30, color: Colors.red))),
                    const Spacer(),
                    const Ltxt(text: 'Edit Medication'),
                  ]).px12(),
                ),
                20.heightBox,
                Image.asset(widget.model.image!, width: 80, height: 80),
                10.heightBox,
                const Ltxt(text: 'Medication Name:'),
                Customfield(
                  readonly: false,
                  controller: name,
                  hinttext: widget.model.medicinename,
                  inputType: TextInputType.name,
                  validator: (value) {
                    return;
                  },
                ),
                15.heightBox,
                const Ltxt(text: 'Medication Type:'),
                Customfield(
                    readonly: false,
                    controller: type,
                    hinttext: widget.model.medicinetype,
                    inputType: TextInputType.name,
                    validator: (value) {
                      return;
                    },
                    suffix: DropdownButton(
                        underline: const SizedBox(),
                        items: [
                          ...['medication', 'prescription'].map((e) =>
                              DropdownMenuItem(value: e, child: Btxt(text: e)))
                        ],
                        onChanged: (e) {
                          type.text = e ?? 'Medication';
                        })),
                15.heightBox,
                const Ltxt(text: 'Medication Dosage:'),
                Customfield(
                  readonly: false,
                  controller: dose,
                  hinttext: widget.model.dose,
                  inputType: TextInputType.name,
                  validator: (value) {
                    return;
                  },
                ),
                20.heightBox,
                GestureDetector(
                  onTap: () async {
                    final aduro = ref.watch(medicationFirebaseProvider);
                    final aduromodel = MModel(
                        mid: FirebaseAuth.instance.currentUser!.uid,
                        dose: dose.text.isEmpty
                            ? widget.model.dose ?? ''
                            : dose.text,
                        medicinename: name.text.isEmpty
                            ? widget.model.medicinename ?? ''
                            : name.text,
                        image: widget.model.image,
                        medicinetype: type.text.isEmpty
                            ? widget.model.medicinetype ?? ''
                            : type.text,
                        did: widget.model.did);

                    try {
                      await aduro
                          .updateMedication(med: aduromodel)
                          .whenComplete(() {
                        setState(() {});
                        context.pop();
                        return VxToast.show(context,
                            textSize: 11,
                            msg: 'Medication updated successfully.',
                            bgColor: const Color.fromARGB(255, 38, 99, 40),
                            textColor: Colors.white,
                            pdHorizontal: 30,
                            pdVertical: 20);
                      });
                      setState(() {});
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red[400],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          content: Itxt(text: e.toString()).centered()));
                    }
                  },
                  child: Container(
                    width: size.width * 0.9,
                    margin: const EdgeInsets.symmetric(vertical: 25),
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(15)),
                    child: const Text('Update Medication',
                            style: TextStyle(
                                fontFamily: 'Pop',
                                fontSize: 14,
                                color: Colors.white))
                        .centered(),
                  ),
                )
              ],
            ),
          ).animate().slideY(duration: 300.ms, begin: 1),
        ),
      ),
    );
  }
}
