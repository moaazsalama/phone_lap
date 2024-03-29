import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:phone_lap/helpers/size_config.dart';
import 'package:phone_lap/models/analysis.dart';
import 'package:phone_lap/models/analyzer.dart';
import 'package:phone_lap/providers/analyzer.dart';
import 'package:phone_lap/providers/cart.dart';
import 'package:phone_lap/widgets/button.dart';
import 'package:phone_lap/widgets/custom_textfeilds.dart' show CustomTextField;
import 'package:provider/provider.dart';

class PcrDataScreen extends StatefulWidget {
  static const routName = 'Pcr-data-Page';
  @override
  State<PcrDataScreen> createState() => _PcrDataScreenState();
}

class _PcrDataScreenState extends State<PcrDataScreen> {
  final TextEditingController _lineController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  ImageProvider? image;
  final ImagePicker imagePicker = ImagePicker();
  File? _imageFile;
  File? _pickedImage;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    if (_imageFile == null)
      image = const AssetImage('assets/img/placeholder.png');
    else
      image = FileImage(_imageFile!);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AnalyzerProvider>(context);
    SizeConfig().init(context);
    return Scaffold(
      body: isLoading
          ? Stack(
              children: [
                Container(
                  color: Theme.of(context).primaryColor,
                ),
                Opacity(
                  opacity: 0.2,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/img/background.PNG'),
                            fit: BoxFit.fitHeight)),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator.adaptive(
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(20),
                      ),
                      Text(
                        AppLocalizations.of(context)!.camera,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: getProportionScreenration(16),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: SizeConfig.screenWidth,
                    height: getProportionateScreenHeight(100),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        )),
                    alignment: const Alignment(0, 0),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                        Text(
                          AppLocalizations.of(context)!.complete,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: getProportionScreenration(20),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight -
                        getProportionateScreenHeight(100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomTextField(
                          controller: _lineController,
                          labelText: AppLocalizations.of(context)!.flightline,
                          hintText: AppLocalizations.of(context)!.qflight,
                          icon: Icons.airplane_ticket_outlined,
                        ),
                        CustomTextField(
                          controller: _countryController,
                          labelText:
                              AppLocalizations.of(context)!.travelcountry,
                          hintText: AppLocalizations.of(context)!.qcountry,
                          textInputType: TextInputType.text,
                          icon: Icons.flag_outlined,
                        ),
                        Stack(
                          children: [
                            Image(
                              image: image!,
                              fit: BoxFit.cover,
                              height: getProportionateScreenHeight(250),
                            ),
                            IconButton(
                              alignment: Alignment.center,
                              onPressed: () {
                                setState(() {
                                  image = const AssetImage(
                                      'assets/img/placeholder.png');
                                  _pickedImage = null;
                                });
                              },
                              icon: const Icon(
                                Icons.close,
                                size: 30,
                              ),
                              color: Colors.red,
                              highlightColor: Colors.red,
                            )
                          ],
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of(context)!.qpassport,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: getProportionScreenration(20),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Button(
                              titleSize: getProportionScreenration(10),
                              width: getProportionateScreenWidth(150),
                              height: getProportionateScreenHeight(60),
                              title: AppLocalizations.of(context)!.gallery,
                              onPressed: () async {
                                try {
                                  final result = await imagePicker.pickImage(
                                      source: ImageSource.gallery);

                                  if (result != null)
                                    setState(() {
                                      _imageFile = File(result.path);
                                      _pickedImage = _imageFile;
                                      image = FileImage(_imageFile!);
                                    });
                                } catch (e) {
                                  showToast(
                                    AppLocalizations.of(context)!.noconnection,
                                    duration: const Duration(seconds: 2),
                                    position: ToastPosition.center,
                                    backgroundColor:
                                        Colors.black.withOpacity(0.8),
                                    radius: getProportionScreenration(3),
                                    textStyle: TextStyle(
                                        fontSize:
                                            getProportionScreenration(20.0)),
                                  );
                                }
                              },
                            ),
                            Button(
                                titleSize: getProportionScreenration(10),
                                height: getProportionateScreenHeight(60),
                                width: getProportionateScreenWidth(150),
                                title: AppLocalizations.of(context)!.camera,
                                onPressed: () async {
                                  try {
                                    final result = await imagePicker.pickImage(
                                        source: ImageSource.camera);

                                    if (result != null)
                                      setState(() {
                                        _imageFile = File(result.path);
                                        _pickedImage = _imageFile;
                                        image = FileImage(_imageFile!);
                                      });
                                  } catch (e) {
                                    showToast(
                                      AppLocalizations.of(context)!
                                          .noconnection,
                                      duration: const Duration(seconds: 2),
                                      position: ToastPosition.center,
                                      backgroundColor:
                                          Colors.black.withOpacity(0.8),
                                      radius: getProportionScreenration(3),
                                      textStyle: TextStyle(
                                          fontSize:
                                              getProportionScreenration(20.0)),
                                    );
                                  }
                                }),
                          ],
                        ),
                        const Expanded(child: SizedBox()),
                        Button(
                          title: AppLocalizations.of(context)!.submit,
                          onPressed: () {
                            onSubmit(provider.analyzer!);
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> onSubmit(Analyzer user) async {
    if (_countryController.text.isEmpty || _lineController.text.isEmpty) {
      showToast(
        AppLocalizations.of(context)!.validatepcr,
        duration: const Duration(seconds: 2),
        position: ToastPosition.center,
        backgroundColor: Colors.black.withOpacity(0.8),
        radius: getProportionScreenration(3),
        textStyle: TextStyle(fontSize: getProportionScreenration(30.0)),
      );
    } else if (_pickedImage == null) {
      showToast(
        AppLocalizations.of(context)!.qpassport,
        duration: const Duration(seconds: 2),
        position: ToastPosition.center,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
        animationCurve: Curves.easeIn,
        animationDuration: const Duration(milliseconds: 500),
        radius: 3.0,
        textStyle: TextStyle(
            fontSize: getProportionScreenration(20.0), color: Colors.black),
      );
    } else {
      try {
        setState(() {
          isLoading = true;
        });
        final taskSnapshot = await firebase_storage.FirebaseStorage.instance
            .ref()
            .child('${user.analyzerId}/${_pickedImage!.path.split('/').last}')
            .putFile(_pickedImage!);
        final s = await taskSnapshot.ref.getDownloadURL();
        print(s);
        final cart = Provider.of<Cart>(context, listen: false);
        cart.addItem(
          Analysis(name: 'Pcr Travling', analysisType: 'PCr', price: '100'),
          passportImageUrl: s,
          flightLine: _lineController.text,
          travlingCountry: _countryController.text,
        );

        print(cart.itemCount);
        // ignore: prefer_final_locals
      } catch (e) {
        showToast(
          AppLocalizations.of(context)!.noconnection,
          duration: const Duration(seconds: 2),
          position: ToastPosition.center,
          backgroundColor: Colors.black.withOpacity(0.8),
          radius: getProportionScreenration(3),
          textStyle: TextStyle(fontSize: getProportionScreenration(20.0)),
        );
      }

      setState(() {
        isLoading = false;
      });

      Navigator.pop(context);
      showToast(
        AppLocalizations.of(context)!.requestsuccessful,
        duration: const Duration(seconds: 2),
        position: ToastPosition.center,
        backgroundColor: Colors.black.withOpacity(0.8),
        radius: getProportionScreenration(3),
        textStyle: TextStyle(fontSize: getProportionScreenration(20.0)),
      );
    }
  }
}
