
import 'package:bookify/Screens/Colors.dart';
import 'package:bookify/Screens/flights/flightsearch.dart';
import 'package:flutter/material.dart';

class Flightsui extends StatefulWidget {
  const Flightsui({super.key});

  @override
  State<Flightsui> createState() => _FlightsuiState();
}

class _FlightsuiState extends State<Flightsui> {
  DateTime selecteddate=DateTime.now();
 final TextEditingController _dateController = TextEditingController(); // also in state
String formatDate(DateTime date) {
  return "${date.day}/${date.month}/${date.year}";
}
@override
void initState() {
  super.initState();
  _dateController.text = formatDate(selecteddate); // initial value
}
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Flight",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
        centerTitle: true,

      ),
        body:  SingleChildScrollView(
           padding: const EdgeInsets.all(16.0),
          child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
            
               
               SizedBox(height: 10,),
                Container(
                  height: 300,
                  //padding: EdgeInsets.all(9.0),
          
                  //color: const Color.fromARGB(255, 17, 111, 42),
                  //child: Image.asset('flights.jpg',fit:BoxFit.fill,),
                  decoration: BoxDecoration(
                    image: DecorationImage(image:AssetImage("flight.jpg"),fit: BoxFit.fill),
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow:[ BoxShadow(blurStyle: BlurStyle.normal)]
                  ),
                ),
                Text("From",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                Opacity(
                  opacity: 0.7,
                  child: Container(
                     height: 50,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(15),
                      right: Radius.circular(20)
                      
                      ),
                    ),
                    child: Row(children: [
                       SizedBox(width: 8,),
                      Icon(Icons.location_pin,color: Colors.white,),
                     // Expanded(child: SizedBox.shrink()),
                     SizedBox(width: 8,),
                      // here the input box will come later during api 
                      Text("New York",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w100,color: Colors.white,),)
                    ],),
                  ),
                ),
                Text("To",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                Opacity(
                  opacity: 0.7,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(15),
                      right: Radius.circular(20)
                      ),
                    ),
                    
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        SizedBox(width: 8),
                        Icon(Icons.location_pin,color: Colors.white,),
                     // Expanded(child: SizedBox.shrink()),
                        SizedBox(width: 8),
                      // here the input box will come later during api 
                        Text("Las Vegas",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w100,color:Colors.white),)
                    ],),
                  ),
                ),
                SizedBox(height: 20,),
                Opacity(
                  opacity: 0.7,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(15),
                      right: Radius.circular(20)
                      ),
                    ),
          
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: _dateController,
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selecteddate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2027),
                        );
                    
                        if (pickedDate != null) {
                          setState(() {
                            selecteddate = pickedDate;
                            _dateController.text = formatDate(pickedDate); // update text
                          });
                        }
                      },
                        decoration: InputDecoration(
                            labelText: "  Departure Date",
                            labelStyle: TextStyle(color: Colors.white), 
                            hintText: "   Choose a date",
                            hintStyle: TextStyle(color: Colors.white70),
                            suffixIcon: Icon(Icons.calendar_today, color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                SizedBox(
            width: double.infinity, 
            height: 50, 
            child: ElevatedButton(
              onPressed: () {
                
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Flightsearch(),)
                 

                );
                // print(Navigator.of(context).canPop());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:searchbutton, 
                shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), 
                ),
                elevation: 0, 
              ),
              child: Text(
                'Search Flights',
                style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
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