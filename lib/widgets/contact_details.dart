import 'package:flutter/material.dart';
import 'package:expoleap/models/contact.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:expoleap/widgets/conditional_render_delegate.dart';

class ContactDetails extends StatelessWidget {
  final Contact contact;
  ContactDetails({required this.contact});

  @override
  Widget build(BuildContext context) {
    final bool isNotContact = contact.website == null &&
        contact.email == null &&
        contact.phone == null;

    return ConditionalRenderDelegate(
        condition: isNotContact,
        renderWidget: Center(),
        fallbackWidget:
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text('\nContact\n',
                  style: TextStyle(
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.8)))),
          ConditionalRenderDelegate(
              condition: contact.email != null && contact.email != '',
              renderWidget: InkWell(
                  onTap: () => UrlLauncher.launch("mailto:${contact.email}"),
                  child: Container(
                      child: Row(
                    children: [
                      Icon(MaterialCommunityIcons.email),
                      Text('  ${contact.email}',
                          style: TextStyle(
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(1.4)))
                    ],
                  ))),
              fallbackWidget: Center()),
          ConditionalRenderDelegate(
              condition: contact.phone != null && contact.phone != '',
              renderWidget: InkWell(
                  onTap: () => UrlLauncher.launch("tel:${contact.phone}"),
                  child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Icon(MaterialCommunityIcons.phone),
                          Text('  ${contact.phone}',
                              style: TextStyle(
                                  fontSize: ResponsiveFlutter.of(context)
                                      .fontSize(1.4)))
                        ],
                      ))),
              fallbackWidget: Center()),
          ConditionalRenderDelegate(
              condition: contact.website != null && contact.website != '',
              renderWidget: InkWell(
                  onTap: () => UrlLauncher.launch(
                        "${contact.website}",
                        forceSafariVC: false,
                        forceWebView: false,
                      ),
                  child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Icon(Icons.web),
                          Text('  ${contact.website}',
                              style: TextStyle(
                                  fontSize: ResponsiveFlutter.of(context)
                                      .fontSize(1.4)))
                        ],
                      ))),
              fallbackWidget: Center())
        ]));
  }
}
