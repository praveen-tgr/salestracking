
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salespersontracking/Controller/Network/NetworkController.dart';
import 'package:salespersontracking/Style/Stylecustomer.dart';

class NoInternetWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoInternetWidget({Key? key, this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/NoInternet.png', height: 300),
          const SizedBox(height: 20),
          Text(
            'No Internet Connection',
            style: Stylecustomer.BlackText16W500,
          ),
          const SizedBox(height: 10),
          InkWell(
            splashColor: Colors.transparent, // Disables splash
            highlightColor: Colors.transparent,
            onTap: () {
              final isConnected = Provider.of<ConnectivityService>(
                context,
                listen: false,
              ).isConnected;
              if (isConnected && onRetry != null) {
                onRetry!();
              }
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Stylecustomer.CrmColor,
                borderRadius: BorderRadius.circular(5),
              ),
              height: 40,
              width: MediaQuery.of(context).size.width * 0.3,
              child: Center(
                child: Text(
                  'Retry',
                  style: Stylecustomer.WhiteText12W500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
