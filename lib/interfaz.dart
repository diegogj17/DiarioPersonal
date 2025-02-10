import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Victoria FP';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              ImageSection(
                image: 'images/victoriafpfoto.jpg',
              ),
              TitleSection(
                name: 'Victoria FP',
                location: 'Sanlucar, España',
              ),
              ButtonSection(),
              TextSection(
                description: 'Instituto Victora Fp situado en Sanlucar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class TitleSection extends StatelessWidget {
  const TitleSection({
    super.key,
    required this.name,
    required this.location,
  });


  final String name;
  final String location;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  location,
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.star,
            color: Colors.yellow[500],
          ),
          const Text('100'),
          Icon(
            Icons.star,
            color: Colors.yellow[500],
          ),
        ],
      ),
    );
  }
}


class ButtonSection extends StatelessWidget {
  const ButtonSection({super.key});


  Future<void> _makeCall() async {
    const phoneNumber = 'tel:+34601568976'; // Número de teléfono
    if (await canLaunchUrl(Uri.parse(phoneNumber))) {
      await launchUrl(Uri.parse(phoneNumber));
    } else {
      throw 'No se pudo realizar la llamada';
    }
  }


  Future<void> _openMaps() async {
    const mapsUrl = 'https://www.google.es/maps/place/VictoriaFP+-+Victoria+Institute+of+Technology/@36.7658522,-6.3787951,17z/data=!3m1!4b1!4m6!3m5!1s0xd0ddf9a7b522733:0xe371adaf82d8e0ec!8m2!3d36.7658479!4d-6.3762202!16s%2Fg%2F11krhnj9qp?entry=ttu&g_ep=EgoyMDI1MDEyMC4wIKXMDSoASAFQAw%3D%3D';
    if (await canLaunchUrl(Uri.parse(mapsUrl))) {
      await launchUrl(Uri.parse(mapsUrl));
    } else {
      throw 'No se pudo abrir Google Maps';
    }
  }


  void _shareContent() {
    Share.share('¡Visita el Instituto Victoria FP en Sanlucar!');
  }


  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).primaryColor;
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: _makeCall,
            child: ButtonWithText(
              color: color,
              icon: Icons.call,
              label: 'Llamar',
            ),
          ),
          GestureDetector(
            onTap: _openMaps,
            child: ButtonWithText(
              color: color,
              icon: Icons.near_me,
              label: 'Como llegar',
            ),
          ),
          GestureDetector(
            onTap: _shareContent,
            child: ButtonWithText(
              color: color,
              icon: Icons.share,
              label: 'Compartir',
            ),
          ),
        ],
      ),
    );
  }
}


class ButtonWithText extends StatelessWidget {
  const ButtonWithText({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
  });


  final Color color;
  final IconData icon;
  final String label;


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}


class TextSection extends StatelessWidget {
  const TextSection({
    super.key,
    required this.description,
  });


  final String description;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Text(
        description,
        softWrap: true,
      ),
    );
  }
}


class ImageSection extends StatelessWidget {
  const ImageSection({super.key, required this.image});


  final String image;


  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/victoriafpfoto.jpg',
      width: 600,
      height: 240,
      fit: BoxFit.cover,
    );
  }
}
