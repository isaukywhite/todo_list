import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: 1,
                itemBuilder: (ctx, index) {
                  return SizedBox(
                    child: Card(
                      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          CheckboxListTile(
                            title: const Text('VOICE'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            autofocus: false,
                            value: _value,
                            onChanged: (bool? value) {
                              setState(() {
                                _value = value ?? false;
                              });
                            },
                            checkColor: Colors.green[900],
                            activeColor: Colors.greenAccent,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {},
        child: Icon(
          Icons.mic,
          color: Colors.green[900],
        ),
      ),
    );
  }
}
