import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pahg_group/data/vos/company_images_vo.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../bloc/home_bloc.dart';

class HomeBannerCard extends StatefulWidget {
  const HomeBannerCard({super.key});

  @override
  State<HomeBannerCard> createState() => _HomeBannerCardState();
}

class _HomeBannerCardState extends State<HomeBannerCard> {
  final CarouselSliderController _carouselController = CarouselSliderController();
  double _currentPage = 0.0; // <-- Keep as double

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<HomeBloc, List<CompanyImagesVo>>(
      selector: (context, bloc) => bloc.imageList,
      builder: (context, sliders, _) {
        if (sliders.isEmpty) {
          return SizedBox(
            height: 200.0,
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                margin: const EdgeInsets.only(left: 16,right: 16,top: 8,bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white, // this is important for shimmer to show
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          );
        }

        return Column(
          children: [
            CarouselSlider.builder(
              carouselController: _carouselController,
              itemCount: sliders.length,
              itemBuilder: (context, index, realIdx) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      image: DecorationImage(
                        image: NetworkImage(
                          sliders[index].getImageWithBaseUrl(),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                viewportFraction: 0.98, // <-- Match your PageController
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                enlargeCenterPage: false,
                aspectRatio: 16 / 9,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentPage = index.toDouble();
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DotsIndicator(
                dotsCount: sliders.length,
                position: _currentPage,
                decorator: DotsDecorator(
                  spacing: const EdgeInsets.all(4),
                  color: Colors.grey,
                  activeColor: Colors.red,
                  size: const Size(6.0, 6.0),
                  activeSize: const Size(10, 6.0),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onTap: (index) {
                  _carouselController.animateToPage(
                    index.toInt(),
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}