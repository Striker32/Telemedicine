import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:last_telemedicine/components/Avatar/AvatarWithPicker.dart';
import 'package:last_telemedicine/components/Create_application.dart';
import 'package:last_telemedicine/components/SettingsRow.dart';
import 'package:last_telemedicine/components/custom_button.dart';
import 'package:last_telemedicine/Services/Bottom_Navigator.dart';
import 'package:last_telemedicine/pages/user_pages/subpages/Change_city.dart';

import '../components/Appbar/CustomAppBar.dart';
import '../../components/DividerLine.dart';
import '../components/Appbar/AppBarButton.dart';
import '../../themes/AppColors.dart';
import '../components/Create_claim_news_feed.dart';
import '../components/News_pallet.dart';

class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({Key? key}) : super(key: key);

  @override
  State<NewsFeedPage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<NewsFeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background2,
      appBar: CustomAppBar(
        titleText: 'Лента новостей',
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Опишите свою проблему и врач сам найдет Вас!',
                          style: TextStyle(
                            color: AppColors.grey600,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 12),

                        Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: CreateRequestButton(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) =>
                                    const CreateApplicationPopup(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Image(
                      image: AssetImage("assets/images/app/News_2.png"),
                      fit: BoxFit.cover,
                    ),

                    // NewsCard(
                    //   date: '9 февраля 2025 15:45',
                    //   title: 'Дистанционные\nконсультации у терапевта',
                    //   image:
                    // ),
                    const SizedBox(height: 12),

                    Image(
                      image: AssetImage("assets/images/app/News_1.png"),
                      fit: BoxFit.cover,
                    ),

                    // NewsCard(
                    //   date: '9 февраля 2025 15:45',
                    //   title: 'Следите за приёмом\nв личном кабинете',
                    //   image: AssetImage(
                    //     "assets/images/app/News_1.png",
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
