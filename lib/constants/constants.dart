import 'package:flutter/cupertino.dart';
import 'package:expoleap/utils/utils.dart';
import 'package:expoleap/models/event.dart';
import 'package:expoleap/models/social.dart';
import 'package:expoleap/models/address.dart';
import 'package:expoleap/models/contact.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart';

class Constants extends InheritedWidget {
  final Widget child;

  static Constants of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Constants>()!;

  Constants({required this.child, Key? key}) : super(key: key, child: child);

  final String darkTheme = 'Dark';
  final String lightTheme = 'Light';
  final String appName = 'ExpoLeap';
  final String appLogoHeroTag = 'logo';
  final String appImageHeroTag = 'image';
  final String appPinnedEventHeroTag = 'pinned';
  final String mapImage = 'assets/images/map.png';
  final String search = 'assets/images/search.png';
  final String appIcon = 'assets/icons/app_icon.png';
  final String pinLogo = 'assets/icons/pin_icon.png';
  final String menuIcon = 'assets/icons/menu_icon.svg';
  final String bellIcon = 'assets/icons/bell_icon.svg';
  final String errorIcon = 'assets/icons/error_icon.png';
  final String markerIcon = 'assets/icons/marker_icon.svg';
  final String pinIcon = 'assets/icons/event_pin_icon.png';
  final String defaultEvent = 'assets/images/no_event.jpg';
  final String appLogoDark = 'assets/images/logo_dark.png';
  final String appLogoLight = 'assets/images/logo_light.png';
  final String pinIconDark = 'assets/icons/pin_icon_dark.svg';
  final String pinIconLight = 'assets/icons/pin_icon_light.svg';
  final String apiKey = 'AIzaSyANhL5uys4sdZCmXRTE5hUOKHQyh0EHdE0';
  final String closeIconDark = 'assets/icons/close_icon_dark.svg';

  final EventModel placeHolderEvent = new EventModel(
    id: '969a6ca3-5982-4c99-b5d5-3a613219b3fc',
    description:
        'fdgfdgdfgdf;lgklfdgkkldfjgkdfjgjdifhgjdfgjkdfgjkdfngkjdfngndndfngkdfngjdfngjdfngjdfnkgndfjgndfngkjdfngjkdnfgkdnfkgjnfdgndfngkjdfngjkdfngkjdfngjdikfngkjdfngkjdfngkjdfngkj',
    name: 'Test Event',
    dates: [
      new EventDate(
          start: new DateTime.now().toString(),
          end: new DateTime.now().toString(),
          id: 0)
    ],
    timezone: 'America',
    social: new Social(
      id: 0,
      facebook: '',
      instagram: '',
      twitter: '',
      youtube: '',
      linkedin: '',
    ),
    address: Address(
        address1: '6210 Frontage Rd',
        address2: 'Myrtle Beach',
        country: new CountryModel(name: 'United States', code: 'fdgd43'),
        postalCode: '',
        id: 2,
        region: '',
        locality: ''),
  );

  final darkStaticMap = [
    MapStyle(
      element: StyleElement.geometry,
      feature: StyleFeature.all,
      rules: <StyleRule>[
        StyleRule.color(HexColor('#242f3e')),
      ],
    ),
    MapStyle(
      feature: StyleFeature.all,
      element: StyleElement.labels.text.stroke,
      rules: <StyleRule>[
        StyleRule.lightness(-30),
      ],
    ),
    MapStyle(
      feature: StyleFeature.administrative,
      element: StyleElement.labels.text.fill,
      rules: <StyleRule>[
        StyleRule.color(HexColor('#746855')),
      ],
    ),
    MapStyle(
      feature: StyleFeature.administrative.locality,
      element: StyleElement.labels.text.fill,
      rules: <StyleRule>[
        StyleRule.color(HexColor('#d59563')),
      ],
    ),
    MapStyle(
      feature: StyleFeature.poi,
      element: StyleElement.geometry,
      rules: <StyleRule>[
        StyleRule.color(HexColor('#263c3f')),
      ],
    ),
    MapStyle(
      feature: StyleFeature.poi.park,
      element: StyleElement.labels.text.fill,
      rules: <StyleRule>[
        StyleRule.color(HexColor('#6b9a76')),
      ],
    ),
    MapStyle(
      feature: StyleFeature.road,
      element: StyleElement.geometry.fill,
      rules: <StyleRule>[
        StyleRule.color(HexColor('#2b3544')),
      ],
    ),
    MapStyle(
      feature: StyleFeature.road,
      element: StyleElement.labels.text.fill,
      rules: <StyleRule>[
        StyleRule.color(HexColor('#9ca5b3')),
      ],
    ),
    MapStyle(
      feature: StyleFeature.road.arterial,
      element: StyleElement.geometry.fill,
      rules: <StyleRule>[
        StyleRule.color(HexColor('#38414e')),
      ],
    ),
    MapStyle(
      feature: StyleFeature.road.arterial,
      element: StyleElement.geometry.stroke,
      rules: <StyleRule>[
        StyleRule.color(HexColor('#212a37')),
      ],
    ),
    MapStyle(
      feature: StyleFeature.road.highway,
      element: StyleElement.geometry.fill,
      rules: <StyleRule>[
        StyleRule.color(HexColor('#746855')),
      ],
    ),
    MapStyle(
      feature: StyleFeature.road.highway,
      element: StyleElement.geometry.stroke,
      rules: <StyleRule>[
        StyleRule.color(HexColor('#1f2835')),
      ],
    ),
    MapStyle(
      feature: StyleFeature.road.highway,
      element: StyleElement.labels.text.fill,
      rules: <StyleRule>[
        StyleRule.color(HexColor('#f3d19c')),
      ],
    ),
    MapStyle(
      feature: StyleFeature.road.local,
      element: StyleElement.geometry.fill,
      rules: <StyleRule>[
        StyleRule.color(HexColor('#38414e')),
      ],
    ),
    MapStyle(
      feature: StyleFeature.road.local,
      element: StyleElement.geometry.stroke,
      rules: <StyleRule>[
        StyleRule.color(HexColor('#212a37')),
      ],
    ),
    MapStyle(
      feature: StyleFeature.transit,
      element: StyleElement.geometry,
      rules: <StyleRule>[
        StyleRule.color(HexColor('#2f3948')),
      ],
    ),
    MapStyle(
      feature: StyleFeature.transit.station,
      element: StyleElement.labels.text.fill,
      rules: <StyleRule>[
        StyleRule.color(HexColor('#d59563')),
      ],
    ),
    MapStyle(
      feature: StyleFeature.water,
      element: StyleElement.geometry,
      rules: <StyleRule>[
        StyleRule.color(HexColor('#17263c')),
      ],
    ),
    MapStyle(
      feature: StyleFeature.water,
      element: StyleElement.labels.text.fill,
      rules: <StyleRule>[
        StyleRule.color(HexColor('#515c6d')),
      ],
    ),
    MapStyle(
      feature: StyleFeature.water,
      element: StyleElement.labels.text.stroke,
      rules: <StyleRule>[
        StyleRule.lightness(-20),
      ],
    )
  ];

  final String emailIcon = 'assets/icons/email_icon.svg';
  final String phoneIcon = 'assets/icons/phone_icon.svg';
  final String facebookIcon = 'assets/icons/facebook_icon.png';
  final String instgramIcon = 'assets/icons/instagram_icon.png';
  final String twitterIcon = 'assets/icons/twitter_icon.png';
  final String linkedlnIcon = 'assets/icons/linkedln_icon.png';
  final String youTubeIcon = 'assets/icons/youtube_icon.png';

  final String emptySearch = 'assets/icons/no-results.png';
  final String notificationBell = 'assets/icons/bell.png';
  final String homeOutlineIcon = 'assets/icons/tab/home_outline.png';

  final String homeSelectedIcon = 'assets/icons/tab/home_selected.png';
  final String settingOutlineIcon = 'assets/icons/tab/settings_outline.png';
  final String calendarOutlineIcon = 'assets/icons/tab/calendar_outline.png';
  final String settingSelectedIcon = 'assets/icons/tab/settings_selected.png';
  final String calendarSelectedIcon = 'assets/icons/tab/calendar_selected.png';
  final String notificationOutlineIcon =
      'assets/icons/tab/notification_outline.png';
  final String notificationSelectedIcon =
      'assets/icons/tab/notification_selected.png';

  final List<Map<dynamic, dynamic>> data = [
    {
      'id': '1',
      'logo':
          'https://firebasestorage.googleapis.com/v0/b/pricehunt-3444c.appspot.com/o/d7e2eaba4f85b9261b619a658ef79988%202.png?alt=media&token=a75ef424-2931-4031-82dd-4727c02deb85',
      'name': 'Hawk Conference',
      'location': 'Nashville, Florida',
      'contact': {
        'email': 'hawkconference@gmail.com',
        'phone': '8765813233',
      },
      'description':
          'Increase awareness about the natural resources and to make people understand about the importance of the conservion of hawks.'
    },
    {
      'id': '2',
      'logo':
          'https://firebasestorage.googleapis.com/v0/b/pricehunt-3444c.appspot.com/o/images%20(2)%202.png?alt=media&token=33ef52f2-840c-4ff6-9487-4107c90ef70b',
      'name': 'Vizel Conference ',
      'location': 'Mrytle Beach, South Carolina',
      'contact': {
        'email': 'vizelconference@gmail.com',
        'phone': '652699522',
      },
      'description':
          'Increase awareness about the natural resources and to make people understand about the importance of the conservion of hawks.'
    }
  ];

  final List<Map<dynamic, dynamic>> speakers = [
    {
      'id': 1,
      'level': 'Platinum',
      'name': 'Michael Cage',
      'title': 'Doctor',
      'session': '9 - 5pm',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/pricehunt-3444c.appspot.com/o/professional-mens-hairstyles-combed-min-1024x683%203%20(1).png?alt=media&token=746065ec-ed4e-406f-bbfe-a4464d58f279',
      'bio':
          "My name is Alex Drysdale and I am a Junior Web Developer for Oswald Technologies. I graduated from the California Institute of Technology in 2016 with a Bachelor's Degree in Software Development. While in school, I earned the 2015 Edmund Gains Award for my exemplary academic performance and leadership skills.",
      'contact': {
        'email': 'michaelcage@gmail.com',
        'phone': '652699522',
      },
    }
  ];

  final List<Map<dynamic, dynamic>> exhibitors = [{}];

  final List<Map<dynamic, dynamic>> sponsors = [{}];

  @override
  bool updateShouldNotify(Constants oldWidget) => false;
}
