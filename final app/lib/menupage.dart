import 'package:app/button.dart';
import 'package:app/components/chem_tile.dart';
import 'package:app/maps/map_page.dart';
import 'package:app/models/chemicals.dart';
import 'package:app/scanner/scannerapp.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/main.dart';

class Menupage extends StatefulWidget {
  const Menupage({Key? key}) : super(key: key);

  @override
  State<Menupage> createState() => MenupageState();
}

class MenupageState extends State<Menupage> {
  //chems
  List chemicalList = [
    //first chem
    chemicals(
        name: "Silica",
        price: "DEP",
        imagepath: 'lib/app images/silica.png',
        Rating: "high"),
    //second chem
    chemicals(
        name: "Phthalates",
        price: "Sio2",
        imagepath: 'lib/app images/path.png',
        Rating: "high"),
    chemicals(
        name: "Lead",
        price: "Pb",
        imagepath: 'lib/app images/ledo.png',
        Rating: "high"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // This line removes the back icon
        title: Padding(
          padding: EdgeInsets.only(left: 10.0), // Add left padding of 20 pixels
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "CosmoScan",
                style: TextStyle(color: Colors.grey[900], fontSize: 25),
              ),
              SizedBox(
                height: 1,
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //promo banner
            Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(
                    255,
                    138,
                    60,
                    55,
                  ),
                  borderRadius: BorderRadius.circular(20)),
              margin: EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.all(27),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        //message
                        Text(
                          "scan the items",
                          style: GoogleFonts.dmSans(
                            fontSize: 35,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        //button
                        MyButton(
                          text: 'Scan',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const App()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  //image
                  Image.asset(
                    'lib/app images/concealer.png',
                    height: 120,
                  )
                ],
              ),
            ),

            //search bar

            //menu list
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "Chemicals",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800]),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: chemicalList.length,
                itemBuilder: (context, index) => ChemTile(
                  chem: chemicalList[index],
                ),
              ),
            ),

            SizedBox(
              height: 40,
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                        255,
                        138,
                        60,
                        55,
                      ), // Background color
                      borderRadius: BorderRadius.circular(20), // Border radius
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.all(20), // Padding for the text and image
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 70),
                            child: Text(
                              "Skin Clinics",
                              style: GoogleFonts.dmSans(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          MyButton(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MapPage()),
                              );
                            },
                            text: 'Go',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
