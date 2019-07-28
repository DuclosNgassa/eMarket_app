import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var divheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: divheight/2*0.3,
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top:30.0, left: 15.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  new Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        //icon: const Icon(Icons.calendar_today),
                        hintText: 'Enter your date of birth',
                        labelText: 'Dob',
                      ),
                      //controller: _controller,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.white,),
                    tooltip: 'rechercher',
                    onPressed: (() {
                      print('Recherche en cours...');
                      //_chooseDate(context, _controller.text);
                    }),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
