import 'package:flutter/material.dart';
import 'package:broncorideshare/utils/carouselForIntroPageWidget.dart';
import 'package:broncorideshare/pages/signInPage.dart';

class introPage extends StatefulWidget {
  @override
  introPageState createState() {
    return introPageState();
  }
}

class introPageState extends State<introPage> {
  /*Carousel
  * controller : to control the behavior of the page & data
  * currentPage := 0 , start at first page
  * lastPage : to check if the page is the lastPage yet*/
  final PageController controller = new PageController();
  int currentPage = 0;
  bool lastPage = false;

  /*Change the page of the carousel and validation if it is the lastPage yet*/
  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
      if (currentPage == 3) {
        lastPage = true;
      } else {
        lastPage = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFEEEEEE),
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 3,
            child: PageView(
              children: <Widget>[
                Carousel(
                  title: "Welcome",
                  content:
                      "Bronco RideShare is made for Only Cal Poly Pomona students",
                  imageIcon: Icons.airport_shuttle,
                ),
                Carousel(
                  title: "Search and Commute Safe",
                  content:
                      "Commute More Safe With The Student Who live near you",
                  imageIcon: Icons.search,
                ),
                Carousel(
                  title: "Make Friends and Ride",
                  content:
                      "chatroom to communicate one another in a safe environment",
                  imageIcon: Icons.verified_user,
                ),
                Carousel(
                  title: "Rate & Reward",
                  content:
                      "Reward the Driver and Rate the Driver for safer community ",
                  imageIcon: Icons.rate_review,
                ),
              ],
              controller: controller,
              onPageChanged: _onPageChanged,
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text(lastPage ? "" : "SKIP",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                  onPressed: () => lastPage
                      ? null
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => authenticationPage())),
                ),
                FlatButton(
                  child: Text(lastPage ? "GOT IT" : "NEXT",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                  onPressed: () => lastPage
//                      ? Navigator.pushNamed(context, '/authen')
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => authenticationPage()))
                      : controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
