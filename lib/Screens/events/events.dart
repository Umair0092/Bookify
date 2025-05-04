import 'package:bookify/Screens/Colors.dart';
import 'package:bookify/Screens/events/eventssearch.dart';
import 'package:flutter/material.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
   String dropdownvalue = 'sports';
  var  items = [
      'sports',
      'concert'
  ];
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
@override
  void dispose() {
    _dateController.dispose();
    
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Events",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),), 
        centerTitle: true,
      ),
        body:  SingleChildScrollView(
           padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
            
               //Text("Events",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
               //SizedBox(height: 10,),
                Container(
                  height: 300,
                  //padding: EdgeInsets.all(9.0),
          
                  //color: const Color.fromARGB(255, 17, 111, 42),
                  //child: Image.asset('flights.jpg',fit:BoxFit.fill,),
                  decoration: BoxDecoration(
                    image: DecorationImage(image:AssetImage("events.jpg"),fit: BoxFit.fill),
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow:[ BoxShadow(blurStyle: BlurStyle.normal)]
                  ),
                ),
                Text("Category",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                Container(
                   width: double.infinity, 
                   height: 50,
                    decoration: BoxDecoration(
                   // color: searchbutton,
                    borderRadius: BorderRadius.circular(12),
                  ),
  //padding: EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButton(items:
                       items.map((String items) {
                         return DropdownMenuItem(value: items, child: Text(items));
                          }).toList(), 
                          onChanged:  (String? newValue) 
                          {
                            setState(() {
                                          dropdownvalue = newValue!;
                                        });
                         },
                         style: TextStyle(
                             color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                         value: dropdownvalue,
                         alignment: Alignment.centerLeft,
                         isExpanded: true,
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
                            labelText: "   Date",
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
                SizedBox(height: 80,),
                SizedBox(
            width: double.infinity, 
            height: 50, 
            child: ElevatedButton(
              onPressed: () {
                // Your action here
                Navigator.push(context, 
                MaterialPageRoute(builder: (context)=>Eventssearch(
                  category: dropdownvalue,
                  date: _dateController.text,
                )));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:searchbutton, 
                shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), 
                ),
                elevation: 0, 
              ),
              child: Text(
                'Search Events',
                style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
          

                ]
          )),
          );
  }
}