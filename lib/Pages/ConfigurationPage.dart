import 'package:flutter/material.dart';

class ConfigurationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chat Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SwitchListTile(
              title: Text('Enable Chat'),
              value:
                  true, // You can set the initial value based on user preferences.
              onChanged: (value) {
                // Implement logic to enable/disable chat here.
              },
            ),
            Divider(),
            Text(
              'Location Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SwitchListTile(
              title: Text('Enable Location Sharing'),
              value:
                  true, // You can set the initial value based on user preferences.
              onChanged: (value) {
                // Implement logic to enable/disable location sharing here.
              },
            ),
          ],
        ),
      ),
    );
  }
}
