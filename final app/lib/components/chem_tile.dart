import 'package:app/models/chemicals.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChemTile extends StatelessWidget {
  final chemicals chem;
  const ChemTile({
    super.key,
    required this.chem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(25),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //image
        Image.asset(
          chem.imagepath,
          height: 140,
        ),

        //text
        Text(
          chem.name,
          style: GoogleFonts.dmSans(fontSize: 20),
        ),

        //price+rating
        SizedBox(
            width: 160,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //price
                Text(chem.price),

                //rating
                Row(
                  children: [
                    const Icon(
                      Icons.warning,
                      color: Colors.red,
                    ),
                    Text(
                      chem.Rating,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ))
      ]),
    );
  }
}
