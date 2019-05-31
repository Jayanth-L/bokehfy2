import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/**
 * author: Jayanrh L
 * email: jayanthl@protonmail.com
 */

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text("Privacy Policy", style: TextStyle(color: Colors.black),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Text("Jayanth L built the Bokehfy an Ad Supported app. This SERVICE is provided by Jayanth L at no cost and is intended for use as is.\nThis page is used to inform website visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service.\nIf you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy.\nThe terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at Bokehfy unless otherwise defined in this Privacy Policy. \n \nPermissions which we use in our App to serve you \nStorage: We need 'Storage' permission to Bokehfy and save images Files only. \nWe use these permission to do the above mentioned particular task, these permissions are asked to solely to do the above mentioned particular tasks. \nNOTICE: All the Bokehfyed images are stored locally on the device, We do not transmit or store any type of Image files files on servers. \nInformation Collection and Use and Analytics\nFor a better experience, while using our Service, I may require you to provide us with certain personally identifiable information, including but not limited to App Usage. The information that I request is retained on your device and is not collected by me in any wayThe app does use third party services that may collect information used to identify you. Link to privacy policy of third party service providers used by the app. We may use third-party Service Providers to monitor and analyze the use of our Service. \n \nGoogle Firebase Analytics \nFirebase Analytics is a web analytics service offered by Google that tracks and reports website traffic. Firebase uses the data collected to track and monitor the use of our Service. This data is shared with other Firebase services. Firebase may use the collected data to contextualise and personalise the ads of its own advertising network.\n \nGoogle Firebase Analytics \Facebook Analytics is a web analytics service offered by Facebook that tracks and reports website traffic. Facebook analytics uses the data collected to track and monitor the use of our Service. This data is shared with other Facebook services. Facebook may use the collected data to contextualise and personalise the ads of its own advertising network. \n \nData collected \nThe data we collected is  given below. \n(1) crashlytics and analytics according to firebase \n \nLog Data \nI want to inform you that whenever you use my Service, in a case of an error in the app I collect data and information (through third party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing my Service, the time and date of your use of the Service, and other statistics. \n \nCookies \nCookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your devices internal memory. This Service does not use these “cookies” explicitly. However, the app may use third party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service. \n \nService Providers \nI may employ third-party companies and individuals due to the following reasons:\nTo facilitate our Service.\nTo provide the Service on our behalf.\nTo perform Service-related services. or\nTo assist us in analyzing how our Service is used. I want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose. \n \nSecurity \nI value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security. \n \nLinks to Other Sites \nThis Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by me. Therefore, I strongly advise you to review the Privacy Policy of these websites. I have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services. \n \nChildren’s Privacy \nThese Services do not address anyone under the age of 13. I do not knowingly collect personally identifiable information from children under 13. In the case I discover that a child under 13 has provided me with personal information, I immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact me so that I will be able to do necessary actions. \n \nChanges to This Privacy Policy \nI may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page. These changes are effective immediately after they are posted on this page. \n \nContact Us\nIf you have any questions or suggestions about my Privacy Policy, do not hesitate to contact me.", style: TextStyle(fontSize: 17.0)),
              Center(
                child: RaisedButton(
                  color: Colors.white,
                  onPressed: () {
                    _launchTheUrl("https://sites.google.com/view/privacypolicyforbokehfyapp/home");
                  },
                  child: Text("Read on internet", style: TextStyle(color: Colors.black),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _launchTheUrl(url) async {
    try {
      if(await canLaunch(url)) {
        await launch(url);
      }
    } catch(exception, stacktrace) {
      print(exception);
      print(stacktrace);
    }
  }
}