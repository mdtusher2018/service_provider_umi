import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  static const _content = '''
granda elit enim. lobortis, ex orci lobortis. Donec odio elit felis, luctus ultrices odio tincidunt cursus elit in nec vehicula. Morbi feugiat Morbi venenatis sollicitudin, tortor. dui non ipsum dui – nibh tortor, sit viverra maximus ipsum

massa tincidunt viverra non. Ut ex lobortis, ultor et orci Nam massa viverra venenatis massa placerat In viverra laoreet massa Lorem at elit scelerisque Quisque viverra at ipsum at ipsum ipsum quam Lorem id quis ultrices vel placerat dui est.

lobortis, vehicula, tempor Quisque sed felis, vitae Sed varius dolor volutpat in sed nunc, massa mi porttitor ac, purus nulla, turpis efficitur. dolor dolor sit amet in met nec. luctus volutm lacerat; elementum dignissim, Vestibulum

quam efficitur, gravida non, lacus, vehicula nac id commodo turpis Donec Nam faucibus quis elementum tincidunt tortor, orci adipiscing odio sed ullamcorper, eget amet faucibus diam Cras fringilla. Nam Lorem adipiscing vel in Vestibulum
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.textPrimary,
            size: 18,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const AppText.h3('About Us'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: AppText.bodyMd(
          _content,
          color: AppColors.textSecondary,
          height: 1.7,
        ),
      ),
    );
  }
}
