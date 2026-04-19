import 'package:flutter/material.dart';

import '../models/productModel.dart';

final List<Product> productsData = [
  Product(
    id: 'p1',
    name: 'ايفون 15 برو ماكس',
    category: 'موبايلات',
    description:
        'يتميز بهيكل من التيتانيوم القوي والخفيف، مع معالج A17 Pro الأسرع في العالم وكاميرا بدقة 48 ميجابكسل.',
    price: 1199.99,
    image: 'assets/images/products/1.jpg',
    variants: [
      ProductVariant(
        color: Colors.black,
        image: "assets/images/products/2.jpg",
      ),
      ProductVariant(
        // اللون الذهبي باستخدام الهيكس كود
        color: const Color(0xFFEFBF04),
        image: "assets/images/products/3.jpg",
      ),
    ],
  ),
  Product(
    id: 'p2',
    name: ' ايفون 15 برو ',
    category: 'موبايلات',
    description:
        'يأتي بشاشة Dynamic AMOLED 2X بحجم 6.8 بوصة، مع معالج Snapdragon 8 Gen 2 وكاميرا رباعية بدقة 200 ميجابكسل.',
    price: 1099.99,
    image: 'assets/images/products/2.jpg',
    variants: [
      ProductVariant(
        color: Colors.black,
        image: "assets/images/products/2.jpg",
      ),
      ProductVariant(
        // اللون الذهبي باستخدام الهيكس كود
        color: const Color(0xFFEFBF04),
        image: "assets/images/products/3.jpg",
      ),
    ],
  ),
  Product(
    id: 'p3',
    name: '  ايفون 16 برو ماكس ',
    category: 'موبايلات',
    description:
        'كاميرا بدون مرآة بدقة 33 ميجابكسل، مع أداء ممتاز في التصوير الفوتوغرافي والفيديو، وشاشة قابلة للإمالة.',
    price: 2499.99,
    image: 'assets/images/products/3.jpg',
    variants: [
      ProductVariant(
        color: Colors.black,
        image: "assets/images/products/3.jpg",
      ),
      ProductVariant(color: Colors.blue, image: "assets/images/products/4.jpg"),
    ],
  ),
  Product(
    id: 'p5',
    name: ' سماعات Sony WH-1000XM5',
    category: 'سماعات',
    description:
        'سماعات رأسية رائدة في عزل الضوضاء، توفر صوتاً نقياً جداً وعمر بطارية يصل إلى 30 ساعة.',
    price: 349.99,
    image: 'assets/images/products/5.jpg',
    variants: [
      ProductVariant(
        color: Colors.black,
        image: "assets/images/products/5.jpg",
      ),
      ProductVariant(color: Colors.blue, image: "assets/images/products/6.jpg"),
    ],
  ),
  Product(
    id: 'p6',
    name: 'سماعات AirPods Pro 2',
    category: 'سماعات',
    description:
        'تتميز بعزل نشط للضوضاء، وضع الشفافية، وعمر بطارية يصل إلى 6 ساعات مع شحنة واحدة.',
    price: 249.99,
    image: 'assets/images/products/6.jpg',
    variants: [
      ProductVariant(
        color: Colors.black,
        image: "assets/images/products/6.jpg",
      ),
      ProductVariant(color: Colors.blue, image: "assets/images/products/6"),
    ],
  ),
  Product(
    id: 'p7',
    name: 'سماعات Sony WH-1000XM4',
    category: 'سماعات',
    description:
        'تقدم عزل ضوضاء ممتاز، جودة صوت عالية، وراحة طوال اليوم مع عمر بطارية يصل إلى 30 ساعة.',
    price: 349.99,
    image: 'assets/images/products/6.jpg',
    variants: [
      ProductVariant(
        color: Colors.black,
        image: "assets/images/products/6.jpg",
      ),
      ProductVariant(color: Colors.blue, image: "assets/images/products/6.jpg"),
    ],
  ),
  Product(
    id: 'p8',
    name: '  ساعات ROLEX Submariner',
    category: 'ساعات',
    description:
        'تتميز بعزل ضوضاء فعال، جودة صوت ممتازة، وراحة فائقة مع عمر بطارية يصل إلى 24 ساعة.',
    price: 329.99,
    image: 'assets/images/products/watches/market-watch-1.jpg',
    variants: [
      ProductVariant(
        color: Colors.black,
        image: "assets/images/products/watches/market-watch-1.jpg",
      ),
      ProductVariant(
        color: Colors.blue,
        image: "assets/images/products/watches/market-watch-2.jpg",
      ),
    ],
  ),
  Product(
    id: 'p9',
    name: 'ساعات Apple Watch Series 8',
    category: 'ساعات',
    description:
        'تقدم ميزات صحية متقدمة، شاشة Retina Always-On، وعمر بطارية يصل إلى 18 ساعة.',
    price: 399.99,
    image: 'assets/images/products/watches/market-watch-2.jpg',
    variants: [
      ProductVariant(
        color: Colors.black,
        image: "assets/images/products/watches/market-watch-2.jpg",
      ),
      ProductVariant(
        color: Colors.blue,
        image: "assets/images/products/watches/market-watch-3.jpg",
      ),
    ],
  ),
  Product(
    id: 'p10',
    name: 'ساعات Samsung Galaxy Watch 5',
    category: 'ساعات',
    description:
        'تتميز بشاشة Super AMOLED، ميزات صحية متقدمة، وعمر بطارية يصل إلى 40 ساعة.',
    price: 279.99,
    image: 'assets/images/products/watches/market-watch-3.jpg',
    variants: [
      ProductVariant(
        color: Colors.black,
        image: "assets/images/products/iphone_black.jpg",
      ),
      ProductVariant(
        color: Colors.blue,
        image: "assets/images/products/iphone_blue.jpg",
      ),
    ],
  ),
  Product(
    id: 'p11',
    name: 'لابتوب MacBook Pro M2',
    category: 'لابتوبات',
    description:
        'يتميز بشريحة M2 القوية، شاشة Retina بحجم 13.3 بوصة، وعمر بطارية يصل إلى 18 ساعة.',
    price: 1299.99,
    image: 'assets/images/products/laptop/1.jpg',
    variants: [
      ProductVariant(
        color: Colors.black,
        image: "assets/images/products/laptop/2.jpg",
      ),
      ProductVariant(
        color: Colors.blue,
        image: "assets/images/products/laptop/3.jpg",
      ),
    ],
  ),
  Product(
    id: 'p12',
    name: 'لابتوب Dell XPS 13',
    category: 'لابتوبات',
    description:
        'يتميز بشاشة OLED بحجم 13.4 بوصة، معالج Intel Core i7، وعمر بطارية يصل إلى 20 ساعة.',
    price: 999.99,
    image: 'assets/images/products/laptop/2.jpg',
    variants: [
      ProductVariant(
        color: Colors.black,
        image: "assets/images/products/laptop/3.jpg",
      ),
      ProductVariant(
        color: Colors.blue,
        image: "assets/images/products/laptop/1.jpg",
      ),
    ],
  ),
  Product(
    id: 'p13',
    name: 'لابتوب Lenovo ThinkPad X1 Carbon',
    category: 'لابتوبات',
    description:
        'يتميز بشاشة Full HD بحجم 14 بوصة، معالج Intel Core i7، وعمر بطارية يصل إلى 19 ساعة.',

    price: 1149.99,
    image: 'assets/images/products/laptop/3.jpg',
    variants: [
      ProductVariant(
        color: Colors.black,
        image: "assets/images/products/laptop/1.jpg",
      ),
      ProductVariant(
        color: Colors.blue,
        image: "assets/images/products/laptop/2.jpg",
      ),
    ],
  ),
  Product(
    id: 'p14',
    name: '  كاميرا CANON EOS R5',
    category: 'كاميرات',
    description:
        'يتميز بشاشة 4K UHD بحجم 13.3 بوصة، معالج Intel Core i7، وعمر بطارية يصل إلى 22 ساعة.',
    price: 1249.99,
    image: 'assets/images/products/cameras/1.jpg',
    variants: [
      ProductVariant(
        color: Colors.black,
        image: "assets/images/products/cameras/2.jpg",
      ),
      ProductVariant(
        color: Colors.blue,
        image: "assets/images/products/cameras/3.jpg",
      ),
    ],
  ),
  Product(
    id: 'p15',
    name: 'كاميرا Nikon Z7 II',
    category: 'كاميرات',
    description:
        'تتميز بشاشة 4K UHD بحجم 13.3 بوصة، معالج Intel Core i7، وعمر بطارية يصل إلى 22 ساعة.',
    price: 1199.99,
    image: 'assets/images/products/cameras/2.jpg',
    variants: [
      ProductVariant(
        color: Colors.black,
        image: "assets/images/products/cameras/3.jpg",
      ),
      ProductVariant(
        color: Colors.blue,
        image: "assets/images/products/cameras/1.jpg",
      ),
    ],
  ),
  Product(
    id: 'p16',
    name: 'كاميرا Sony A7 IV',
    category: 'كاميرات',
    description:
        'تتميز بشاشة 4K UHD بحجم 13.3 بوصة، معالج Intel Core i7، وعمر بطارية يصل إلى 22 ساعة.',
    price: 1099.99,
    image: 'assets/images/products/cameras/3.jpg',
    variants: [
      ProductVariant(
        color: Colors.black,
        image: "assets/images/products/cameras/1.jpg",
      ),
      ProductVariant(
        color: Colors.blue,
        image: "assets/images/products/cameras/2.jpg",
      ),
    ],
  ),
  // ... أضف المزيد من المنتجات بنفس الطريقة

  // ... أضف حقل category لبقية المنتجات بنفس الطريقة
];
