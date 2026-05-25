import '../models/product.dart';
import '../models/coupon.dart';

class DummyData {
  static final List<String> carouselBanners = [
    'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=1000&q=80', // Shopping banner
    'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=1000&q=80', // High fashion banner
    'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=1000&q=80', // Store banner
    'https://images.unsplash.com/photo-1479064555552-3ef4979f8908?w=1000&q=80', // Suit banner
  ];

  static final List<Map<String, String>> categories = [
    {
      'title': 'Men',
      'image': 'https://images.unsplash.com/photo-1617137968427-85924c800a22?w=300&q=80',
    },
    {
      'title': 'Women',
      'image': 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=300&q=80',
    },
    {
      'title': 'Kids',
      'image': 'https://images.unsplash.com/photo-1519457431-44ccd64a579b?w=300&q=80',
    },
    {
      'title': 'Indie',
      'image': 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=300&q=80',
    },
    {
      'title': 'Footwear',
      'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300&q=80',
    },
    {
      'title': 'Accessories',
      'image': 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=300&q=80',
    },
  ];

  static final List<Coupon> coupons = [
    Coupon(
      code: 'AJIOMANIA',
      title: 'EXTRA 30% OFF',
      description: 'Get extra 30% off on purchase of ₹2,999 and above. Max discount ₹1,500.',
      discountPercentage: 30.0,
      minPurchaseAmount: 2999.0,
      maxDiscountAmount: 1500.0,
    ),
    Coupon(
      code: 'TRENDS40',
      title: 'FLAT 40% OFF',
      description: 'Applicable on select styles for orders above ₹3,499. Max discount ₹2,000.',
      discountPercentage: 40.0,
      minPurchaseAmount: 3499.0,
      maxDiscountAmount: 2000.0,
    ),
    Coupon(
      code: 'FIRSTBUY',
      title: 'FLAT ₹500 OFF (NEW USER)',
      description: 'Flat 15% discount for your very first fashion order. Min purchase ₹1,499. Max discount ₹500.',
      discountPercentage: 15.0,
      minPurchaseAmount: 1499.0,
      maxDiscountAmount: 500.0,
    ),
    Coupon(
      code: 'FASHION20',
      title: 'EXTRA 20% OFF',
      description: 'Extra 20% off on all regular and sale items above ₹1,999. Max discount ₹600.',
      discountPercentage: 20.0,
      minPurchaseAmount: 1999.0,
      maxDiscountAmount: 600.0,
    ),
  ];

  static final List<Map<String, dynamic>> saleGrids = [
    {
      'title': 'SPORTSWEAR',
      'offer': '30-60% OFF',
      'tagline': 'Nike, Adidas & Puma',
      'color': 0xFF0F2027,
      'image': 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=300&q=80'
    },
    {
      'title': 'ETHNIC WEAR',
      'offer': 'UNDER ₹999',
      'tagline': 'Biba, W & Indie styles',
      'color': 0xFF8A2387,
      'image': 'https://images.unsplash.com/photo-1607345366928-199ea26cfe3e?w=300&q=80'
    },
    {
      'title': 'CASUAL SHIRTS',
      'offer': 'MIN 50% OFF',
      'tagline': 'GAP, Levis, Superdry',
      'color': 0xFF2C3E50,
      'image': 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=300&q=80'
    },
    {
      'title': 'BAGS & MORE',
      'offer': 'UP TO 70% OFF',
      'tagline': 'Lavie, Caprese, Baggit',
      'color': 0xFF1D2671,
      'image': 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=300&q=80'
    },
  ];

  static final List<String> topBrands = [
    'Nike',
    'Adidas',
    'Superdry',
    'Levis',
    'Tommy Hilfiger',
    'GAP',
    'BIBA',
    'Puma',
    'Steve Madden',
    'Armani Exchange'
  ];

  static final List<Product> products = [
    Product(
      id: 'p1',
      brand: 'SUPERDRY',
      title: 'Premium Vintage Denim Jacket',
      description: 'Elevate your off-duty style with this premium classic blue denim jacket from Superdry. Crafted from pure heavyweight cotton denim, it features heavy metal button fastenings, classic flap pockets on the chest, a pointed collar, and sleek contrast topstitching. Pair it with dark wash jeans or chinos for a rugged, double-denim luxury statement.',
      price: 3499.0,
      originalPrice: 6999.0,
      discountPercentage: 50.0,
      category: 'Men',
      images: [
        'https://images.unsplash.com/photo-1617137968427-85924c800a22?w=800&q=80',
        'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?w=800&q=80',
        'https://images.unsplash.com/photo-1516257984-b1b4d707412e?w=800&q=80',
      ],
      sizes: ['S', 'M', 'L', 'XL'],
      rating: 4.6,
      reviewsCount: 384,
      isTrending: true,
    ),
    Product(
      id: 'p2',
      brand: 'GAP',
      title: 'Slim Fit Oxford Plaid Shirt',
      description: 'Make a sharp style statement with this slim-fit plaid shirt from GAP. Engineered in premium woven cotton oxford fabric, it offers unmatched breathability and structured wear. Features a neat button-down collar, full buttoned placket, curved hemline, and adjustable button cuffs. Ideal for both smart-casual and formal Friday styling.',
      price: 1199.0,
      originalPrice: 2999.0,
      discountPercentage: 60.0,
      category: 'Men',
      images: [
        'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=800&q=80',
        'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=800&q=80',
        'https://images.unsplash.com/photo-1598033129183-c4f50c736f10?w=800&q=80',
      ],
      sizes: ['M', 'L', 'XL', 'XXL'],
      rating: 4.2,
      reviewsCount: 512,
      isNew: true,
    ),
    Product(
      id: 'p3',
      brand: 'NIKE',
      title: 'Air Max 90 Premium Sneakers',
      description: 'The Nike Air Max 90 Premium stays true to its OG running roots with a iconic waffle sole, stitched overlays, and classic color-accented TPU plates. The visible Air cushioning unit in the heel cushions every stride, while the premium leather and textile upper delivers a premium aesthetic and supreme support for daily lifestyle wear.',
      price: 7499.0,
      originalPrice: 12499.0,
      discountPercentage: 40.0,
      category: 'Footwear',
      images: [
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&q=80',
        'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?w=800&q=80',
        'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=800&q=80',
      ],
      sizes: ['UK 7', 'UK 8', 'UK 9', 'UK 10'],
      rating: 4.8,
      reviewsCount: 1240,
      isTrending: true,
    ),
    Product(
      id: 'p4',
      brand: 'ARMANI EXCHANGE',
      title: 'Crewneck Signature Premium Tee',
      description: 'A versatile essential for the modern wardrobe, this crewneck t-shirt from Armani Exchange is tailored in soft, breathable premium Pima cotton stretch. Featuring a minimal chest branded logo graphic, short sleeves, and a clean straight hem, it merges high-fashion prestige with comfortable regular wear.',
      price: 1799.0,
      originalPrice: 4499.0,
      discountPercentage: 60.0,
      category: 'Men',
      images: [
        'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=800&q=80',
        'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=800&q=80',
      ],
      sizes: ['S', 'M', 'L', 'XL'],
      rating: 4.5,
      reviewsCount: 198,
      isNew: true,
    ),
    Product(
      id: 'p5',
      brand: 'BIBA',
      title: 'Embellished Floral Anarkali Kurta',
      description: 'Exude traditional elegance in this stunning floral Anarkali kurta set from BIBA. Crafted in fluid, breathable rayon fabric, it showcases a striking hand-embellished round neckline, intricate gold-foil floral motifs throughout, and a sweeping flared hem. Perfect for festive celebrations, family gatherings, or wedding ceremonies.',
      price: 2399.0,
      originalPrice: 5999.0,
      discountPercentage: 60.0,
      category: 'Indie',
      images: [
        'https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?w=800&q=80',
        'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800&q=80',
      ],
      sizes: ['XS', 'S', 'M', 'L', 'XL'],
      rating: 4.4,
      reviewsCount: 230,
      isTrending: true,
    ),
    Product(
      id: 'p6',
      brand: 'ZARA',
      title: 'Satin Elegant Evening Slit Dress',
      description: 'Turn heads at your next luxury soirée with this satin evening gown from Zara. Designed in a lustrous, premium satin drape, it boasts a cowl neckline, a fitted waist, delicate cross-back spaghetti straps, and a dramatic thigh-high side slit. A true definition of minimalist glamour and sophisticated styling.',
      price: 2799.0,
      originalPrice: 6999.0,
      discountPercentage: 60.0,
      category: 'Women',
      images: [
        'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=800&q=80',
        'https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=800&q=80',
        'https://images.unsplash.com/photo-1596783074918-c84cb06531ca?w=800&q=80',
      ],
      sizes: ['S', 'M', 'L'],
      rating: 4.7,
      reviewsCount: 145,
      isNew: true,
    ),
    Product(
      id: 'p7',
      brand: 'STEVE MADDEN',
      title: 'Premium Structured Leather Tote Bag',
      description: 'Make a bold accessory statement with this structured Saffiano leather tote bag from Steve Madden. Designed for the stylish professional, it features a dual zippered compartment, polished gold-tone hardware, a signature metal emblem, and an optional adjustable shoulder strap. Spacious enough to hold a 13" laptop, documents, and essentials.',
      price: 3999.0,
      originalPrice: 9999.0,
      discountPercentage: 60.0,
      category: 'Accessories',
      images: [
        'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=800&q=80',
        'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=800&q=80',
      ],
      sizes: ['OS'],
      rating: 4.6,
      reviewsCount: 88,
      isTrending: true,
    ),
    Product(
      id: 'p8',
      brand: 'PUMA',
      title: 'Ignite Limitless Running Shoes',
      description: 'Power up your daily workout routines with the Puma Ignite Limitless shoes. Engineered with an extremely breathable woven knit bootie upper, midfoot cage overlay for ultimate stability, and premium Ignite foam cushioning midsole that yields outstanding energy return and response with every stride.',
      price: 3199.0,
      originalPrice: 7999.0,
      discountPercentage: 60.0,
      category: 'Footwear',
      images: [
        'https://images.unsplash.com/photo-1508296695146-257a814070b4?w=800&q=80',
        'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=800&q=80',
      ],
      sizes: ['UK 6', 'UK 7', 'UK 8', 'UK 9', 'UK 10'],
      rating: 4.4,
      reviewsCount: 672,
    ),
    Product(
      id: 'p9',
      brand: 'U.S. POLO ASSN.',
      title: 'Kids Contrast Collar Sports Polo',
      description: 'Dress your little champion in classic collegiate style with this cotton pique polo shirt from U.S. Polo Assn. Styled with a contrast ribbed collar, button placket, short sleeves with ribbed bands, and the iconic embroidered double-horseman emblem on the chest. Soft, durable, and highly breathable.',
      price: 699.0,
      originalPrice: 1699.0,
      discountPercentage: 58.0,
      category: 'Kids',
      images: [
        'https://images.unsplash.com/photo-1519457431-44ccd64a579b?w=800&q=80',
        'https://images.unsplash.com/photo-1503919545889-aef636e10ad4?w=800&q=80',
      ],
      sizes: ['5-6 Y', '7-8 Y', '9-10 Y', '11-12 Y'],
      rating: 4.3,
      reviewsCount: 112,
      isNew: true,
    ),
    Product(
      id: 'p10',
      brand: 'ADIDAS',
      title: 'Kids Lite Racer Adapt Sneakers',
      description: 'Perfect for non-stop play and casual wear, these slip-on Adidas kids sneakers feature a sock-like stretch mesh upper for a snug fit. Styled with a bold elastomeric brand band, lightweight Cloudfoam cushioning midsole, and flexible rubber outsole that supports natural movements and maintains maximum grip.',
      price: 1999.0,
      originalPrice: 3999.0,
      discountPercentage: 50.0,
      category: 'Kids',
      images: [
        'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=800&q=80',
        'https://images.unsplash.com/photo-1556906781-9a412961c28c?w=800&q=80',
      ],
      sizes: ['UK 1', 'UK 2', 'UK 3', 'UK 4'],
      rating: 4.5,
      reviewsCount: 189,
    ),
    Product(
      id: 'p11',
      brand: 'FABINDIA',
      title: 'Handcrafted Block-Print Cotton Kurta',
      description: 'Embrace sustainable handmade luxury with this pure cotton long kurta from Fabindia. Showcases timeless hand-block prints using natural vegetable dyes, a classic mandarin collar, side slits, and comfortable full sleeves. Tailored to perfection, it pairs beautifully with white pajamas, linen trousers, or classic denims.',
      price: 1399.0,
      originalPrice: 2799.0,
      discountPercentage: 50.0,
      category: 'Indie',
      images: [
        'https://images.unsplash.com/photo-1607345366928-199ea26cfe3e?w=800&q=80',
        'https://images.unsplash.com/photo-1626306584293-17441cb0609a?w=800&q=80',
      ],
      sizes: ['M', 'L', 'XL', 'XXL'],
      rating: 4.5,
      reviewsCount: 302,
    ),
    Product(
      id: 'p12',
      brand: 'ONLY',
      title: 'Paperbag Waist Linen Skirt',
      description: 'Look effortlessly chic in this midi paperbag waist linen skirt from ONLY. Designed in a premium cotton-linen blend fabric, it includes a matching waist tie belt, side slip pockets, and a button-through front closure. Its airy silhouette guarantees breathable comfort, while adding high-street flare to your sunny day out.',
      price: 999.0,
      originalPrice: 2499.0,
      discountPercentage: 60.0,
      category: 'Women',
      images: [
        'https://images.unsplash.com/photo-1577900232427-18219b9166a0?w=800&q=80',
        'https://images.unsplash.com/photo-1582142306909-195724d33ab0?w=800&q=80',
      ],
      sizes: ['XS', 'S', 'M', 'L'],
      rating: 4.1,
      reviewsCount: 78,
    ),
  ];
}
