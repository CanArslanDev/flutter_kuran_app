class GeneralOption {
  final String imagePath;
  final String? routeName;
  final Function()? onTap;
  final String title;
  final String subtitle;

  GeneralOption({
    required this.imagePath,
    required this.onTap,
    required this.title,
    required this.subtitle,
    this.routeName,
  });
}

final List<GeneralOption> generalOptions = [
  GeneralOption(
    imagePath: 'assets/about_icons_svg/thank.svg',
    onTap: null,
    title: 'Yapılan hizmetin devamı için',
    subtitle:
        '“Hizmetlerin devamı, sunucu ve geliştirme ücretleri için reklamları 1 kere ödeme yaparak kaldırabilir. Okunan her kurandaki sevaba ortak olabilirsiniz. ',
  ),
  GeneralOption(
    imagePath: 'assets/about_icons_svg/star.svg',
    onTap: () async {
      // await launchURL(
      //     'https://play.google.com/store/apps/details?id=com.islam.uygulamasi');
    },
    title: 'Daha fazla kişiye ulaşmak için lütfen bizi değerlendirin..',
    subtitle: 'Peygamberin izinden gidenler olarak dualarınızı bekleriz.  '
        'Diğer kullanıcıların da faydalanması için güzel yorumlarınızı bekliyoruz.',
  ),
  GeneralOption(
    imagePath: 'assets/about_icons_svg/share.svg',
    onTap: () async {
      // await onShare('Uygulamayı kontrol et '
      //     'mailto:gmail.com');
    },
    title: 'İletişim',
    subtitle:
        'Şikayet istek, dilek ve telif hakkı için E-posta adresimiz: mbayar104@gmail.com',
  ),
  GeneralOption(
    imagePath: 'assets/about_icons_svg/donate.svg',
    onTap: () {},
    title: 'Telif Hakkı',
    subtitle:
        'Mobil uygulamamız ve websitemizdeki yer alan kitaplar, videolar, sesler, resimler ve diğer içerikler internet üzerinden alınıyor, içeriklerden herhangi birisinin telif hakkını ihlal ettiğini düşünüyorsanız, bize iletişim bölümündeki mail adresine bilgi vermeniz halinde 7 iş günü içerisinde söz konusu içerik kaldırılacaktır.',
  ),
];
