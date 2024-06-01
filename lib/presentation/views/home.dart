import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prep_for_dev/core/utils/app_helpers.dart';
import 'package:prep_for_dev/domain/entities/technology.dart';
import 'package:prep_for_dev/presentation/viewmodels/home.dart';
import 'package:prep_for_dev/presentation/widgets/technology.dart';
import 'package:prep_for_dev/themes/app_theme.dart';

import '../viewmodels/game.dart';
import 'loading.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return SafeArea(
        child: AnnotatedRegion(
            value: const SystemUiOverlayStyle(
              statusBarColor: AppTheme.primaryColor,
              statusBarIconBrightness: Brightness.light,
            ),
            child: Scaffold(body: Consumer(builder: (context, ref, child) {
              final homeViewModel = ref.watch(homeViewModelProvider);
              final gameViewModel = ref.watch(gameViewModelProvider);

              return homeViewModel.isLoading
                  ? const LoadingPage(
                      text: "Retrieving questions tailored to your profile...")
                  : SizedBox(
                      width: size.width,
                      child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          children: [
                            ListTile(
                              title: const Text(
                                "Hello guy!",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                              subtitle: const Text("Welcome back to Prep4Dev"),
                              trailing: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: AppTheme.secondaryColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const FaIcon(
                                  FontAwesomeIcons.clockRotateLeft,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),
                            AppHelpers.getSpacerHeight(1),
                            const Text(
                              "What type of position are you applying for?",
                              style: TextStyle(
                                  fontSize: 35, fontWeight: FontWeight.bold),
                            ),
                            AppHelpers.getSpacerHeight(2),
                            Card(
                              margin: EdgeInsets.zero,
                              elevation: 0.0,
                              color: Colors.transparent,
                              child: Container(
                                  width: size.width,
                                  alignment: Alignment.center,
                                  height: 52,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Autocomplete<Technology>(
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<
                                            Technology>.empty();
                                      }
                                      return homeViewModel.technologies
                                          .where((Technology option) {
                                        return option.title
                                            .toLowerCase()
                                            .contains(textEditingValue.text
                                                .toLowerCase());
                                      });
                                    },
                                    displayStringForOption: (option) =>
                                        option.title,
                                    fieldViewBuilder: (ctx,
                                            textEditingController,
                                            focusNode,
                                            onFieldSubmitted) =>
                                        TextFormField(
                                      keyboardType: TextInputType.text,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                      focusNode: focusNode,
                                      controller: textEditingController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.only(
                                            top: 9, left: 10),
                                        hintText: "Search here...",
                                        hintStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                        prefixIcon: const Padding(
                                            padding: EdgeInsets.only(top: 0),
                                            child: Icon(
                                              FontAwesomeIcons.magnifyingGlass,
                                              size: 20,
                                              color: Colors.black38,
                                            )),
                                        suffixIcon: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: GestureDetector(
                                            onTap: () {
                                              String text =
                                                  textEditingController.text;
                                              if (text.isNotEmpty) {
                                                if (homeViewModel.technologies
                                                    .any((Technology
                                                            technology) =>
                                                        technology.title ==
                                                        text)) {
                                                  homeViewModel
                                                      .changeQuestion(text);
                                                  TechnologyCard
                                                      .showModalBottomSheet(
                                                          context,
                                                          homeViewModel,
                                                          gameViewModel);
                                                } else {
                                                  AppHelpers.showSnackBar(
                                                      context,
                                                      "Please choose a technology first");
                                                }
                                              } else {
                                                AppHelpers.showSnackBar(context,
                                                    "Please type something");
                                              }
                                            },
                                            child: const CircleAvatar(
                                                backgroundColor:
                                                    AppTheme.secondaryColor,
                                                child: Icon(
                                                  FontAwesomeIcons.paperPlane,
                                                  size: 18,
                                                  color: Colors.white,
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                    onSelected: (Technology selection) {
                                      debugPrint(
                                          'You just selected $selection');
                                    },
                                  )),
                            ),
                            AppHelpers.getSpacerHeight(2),
                            GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 10,
                                padding: const EdgeInsets.only(bottom: 20),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20,
                                        childAspectRatio: 0.9),
                                itemBuilder: (ctx, index) {
                                  return TechnologyCard(
                                      parentContext: context,
                                      technology:
                                          homeViewModel.technologies[index]);
                                })
                          ]));
            }))));
  }
}
