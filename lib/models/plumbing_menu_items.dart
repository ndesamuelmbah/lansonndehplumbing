import 'package:lansonndehplumbing/core/utils/views_and_order_types.dart';

class PlumbingMenuItem {
  final int itemId;
  final String itemName;
  final double itemPrice;
  final String stringPrice;
  final String itemImage;

  PlumbingMenuItem({
    required this.itemId,
    required this.itemName,
    required this.itemPrice,
    required this.stringPrice,
    required this.itemImage,
  });

  // Factory method to create a PlumbingMenuItems object from a JSON map
  factory PlumbingMenuItem.fromJson(Map<String, dynamic> json) {
    return PlumbingMenuItem(
      itemId: json['itemId'],
      itemName: json['itemName'],
      itemPrice: json['itemPrice'].toDouble(),
      stringPrice: json['stringPrice'],
      itemImage: json['itemImage'],
    );
  }

  // Method to convert a PlumbingMenuItems object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'itemPrice': itemPrice,
      'itemImage': itemImage,
      'stringPrice': stringPrice
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlumbingMenuItem && other.itemId == itemId;
  }
}

List<PlumbingMenuItem> getMenuItems(OrderType orderType) {
  // Common dishes in Cameroon and Nigeria
  final fixtureItems = [
    {
      "itemId": 0,
      "itemName": "Gate Valve 15mm",
      "stringPrice": "UGX 24,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_gate-valve-15mm-07901.jpg",
      "itemPrice": 24000
    },
    {
      "itemId": 1,
      "itemName": "Gate Valve 22mm",
      "stringPrice": "UGX 25,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_gate-valve-15mm-079011.jpg",
      "itemPrice": 25000
    },
    {
      "itemId": 2,
      "itemName": "Gate Valve 28mm",
      "stringPrice": "UGX 27,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_gate-valve-15mm-079012.jpg",
      "itemPrice": 27000
    },
    {
      "itemId": 3,
      "itemName": "Stopcock 22mm 10002",
      "stringPrice": "UGX 34,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_stopcock-15mm-109011.jpg",
      "itemPrice": 34000
    },
    {
      "itemId": 4,
      "itemName": "Stopcock 15mm 10901",
      "stringPrice": "UGX 30,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_stopcock-15mm-10901.jpg",
      "itemPrice": 30000
    },
    {
      "itemId": 5,
      "itemName": "Stopcock 28mm 11002",
      "stringPrice": "UGX 39,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_stopcock-15mm-109012.jpg",
      "itemPrice": 39000
    },
    {
      "itemId": 6,
      "itemName": "Pump Valve 22mm x 1.1/2 18901",
      "stringPrice": "UGX 25,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_pump-valve-22mm-x-1-1-2-18901-.jpg",
      "itemPrice": 25000
    },
    {
      "itemId": 7,
      "itemName": "Hose Union Bib Tap 1/2\" C/W Double Check Valve 13905",
      "stringPrice": "UGX 30,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_hose-union-bib-tap-1-2-cw-double-check-valve-13905.jpg",
      "itemPrice": 30000
    },
    {
      "itemId": 8,
      "itemName": "Plasson Threaded Female Adaptor 20mm x 1/2in",
      "stringPrice": "UGX 4,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_82.png",
      "itemPrice": 4000
    },
    {
      "itemId": 9,
      "itemName": "Plasson Compression Reducing Coupling 50mm x 25mm",
      "stringPrice": "UGX 4,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_62.png",
      "itemPrice": 4000
    },
    {
      "itemId": 10,
      "itemName": "Isolating Valve Heavy 15mm Chrome Plated 24802",
      "stringPrice": "UGX 7,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_isolating-valve-heavy-15mm-chrome-plated-24802.jpg",
      "itemPrice": 7000
    },
    {
      "itemId": 11,
      "itemName": "Isolating Valve Brass 22mm 24003",
      "stringPrice": "UGX 7,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_isolating-valve-brass-22mm-24003.jpg",
      "itemPrice": 7000
    },
    {
      "itemId": 12,
      "itemName": "Plasson Compression Male Offtake Elbow 20mm x 1/2in",
      "stringPrice": "UGX 10,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_92.png",
      "itemPrice": 10000
    },
    {
      "itemId": 13,
      "itemName": "Plasson Compression Equal Elbow 63mm",
      "stringPrice": "UGX 10,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_102.png",
      "itemPrice": 10000
    },
    {
      "itemId": 14,
      "itemName": "Single Check Valve 15mm 25001",
      "stringPrice": "UGX 7,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_single-check-valve-15mm-25001.jpg",
      "itemPrice": 7000
    },
    {
      "itemId": 15,
      "itemName": "Single Check Valve 28mm 25003",
      "stringPrice": "UGX 8,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_single-check-valve-15mm-250011.jpg",
      "itemPrice": 8000
    },
    {
      "itemId": 16,
      "itemName": "Plasson Compression Equal Tee 50mm",
      "stringPrice": "UGX 13,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_122.png",
      "itemPrice": 13000
    },
    {
      "itemId": 17,
      "itemName": "Plasson Threaded Male Adaptor 25mm x 1/2in",
      "stringPrice": "UGX 4,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_73.png",
      "itemPrice": 4000
    },
    {
      "itemId": 18,
      "itemName": "Bibcock 1/2 Wallplate c/w Tube 13120",
      "stringPrice": "UGX 44,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_bibcock-1-2-wallplate-cw-tube-13120-1.jpg",
      "itemPrice": 44000
    },
    {
      "itemId": 19,
      "itemName": "Drain Plug Type A Bsp 1/2 15901",
      "stringPrice": "UGX 8,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_drain-plug-type-a-bsp-1-2-15901.jpg",
      "itemPrice": 8000
    },
    {
      "itemId": 20,
      "itemName": "Long Pump Extension 1.1/2 20004",
      "stringPrice": "UGX 5,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_-long-pump-extension-1-1-2-20004-.jpg",
      "itemPrice": 5000
    },
    {
      "itemId": 21,
      "itemName": "Intamix Mixing Valve 15mm CP Ref 40015CBA",
      "stringPrice": "UGX 30,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_intamix-mixing-valve-15mm-cp-ref-40015cba.jpg",
      "itemPrice": 30000
    },
    {
      "itemId": 22,
      "itemName": "Plasson Compression Female Offtake Elbow 25mm x 3/4in",
      "stringPrice": "UGX 9,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_112.png",
      "itemPrice": 9000
    },
    {
      "itemId": 23,
      "itemName": "Bent Service Valve 15mm x 1/2 24932",
      "stringPrice": "UGX 10,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_bent-service-valve-15mmx1-2-24932.jpg",
      "itemPrice": 10000
    },
    {
      "itemId": 24,
      "itemName": "Isolating Valve With Handle Chrome Plated 15mm 24011",
      "stringPrice": "UGX 8,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_isolating-valve-with-handle-chrome-plated-15mm-24011.jpg",
      "itemPrice": 8000
    },
    {
      "itemId": 25,
      "itemName": "Lever Handle Ballvalve 22mm c x c 31121",
      "stringPrice": "UGX 25,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_lever-handle-ballvalve-22mmc-x-c-31121.jpg",
      "itemPrice": 25000
    },
    {
      "itemId": 26,
      "itemName": "Lever Handle Ballvalve 1 f x f PN25 31014",
      "stringPrice": "UGX 8,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_lever-handle-ballvalve-1--fxf-pn25-31014.jpg",
      "itemPrice": 8000
    },
    {
      "itemId": 27,
      "itemName": "32mm Pushfit Waste Black Plain Ended Pipe 3m",
      "stringPrice": "UGX 7,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_42.png",
      "itemPrice": 7000
    },
    {
      "itemId": 28,
      "itemName": "OsmaWeld 5Z190G Tee 87.5 degree 40mm Grey",
      "stringPrice": "UGX 8,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_151.png",
      "itemPrice": 8000
    },
    {
      "itemId": 29,
      "itemName": "CRESTANK- CV \u2013 50C/500Ltrs",
      "stringPrice": "UGX 300,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_Crestank-1-12.jpg",
      "itemPrice": 300000
    },
    {
      "itemId": 30,
      "itemName": "Icon 65mm PVC Round 95deg Bend Downpipe",
      "stringPrice": "UGX 21,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_2.jpg",
      "itemPrice": 21000
    },
    {
      "itemId": 31,
      "itemName": "5Z163G Bend 45 degree 40mm Grey",
      "stringPrice": "UGX 6,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_181.png",
      "itemPrice": 6000
    },
    {
      "itemId": 32,
      "itemName": "OsmaWeld 5Z161G Bend 87.5 degree 40mm Grey",
      "stringPrice": "UGX 8,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_171.png",
      "itemPrice": 8000
    },
    {
      "itemId": 33,
      "itemName": "Hose Union Bib Tap 1/2\"",
      "stringPrice": "UGX 27,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_hose-union-bib-tap-1-2-13901.jpg",
      "itemPrice": 27000
    },
    {
      "itemId": 34,
      "itemName": "Automatic Bottle Air Vent 3/8 29020",
      "stringPrice": "UGX 10,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_economy-automatic-bottle-air-vent-3-8-29020.jpg",
      "itemPrice": 10000
    },
    {
      "itemId": 35,
      "itemName": "Short Pump Extension 1.1/2 20003",
      "stringPrice": "UGX 4,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_-short-pump-extension-1-1-2-20003-.jpg",
      "itemPrice": 4000
    },
    {
      "itemId": 36,
      "itemName": "Plastic Float 4.1/2 23200",
      "stringPrice": "UGX 3,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_plastic-float-4-1-2-23200.jpg",
      "itemPrice": 3000
    },
    {
      "itemId": 37,
      "itemName": "3/4 HP Brass Ballvalve Part 1 23008",
      "stringPrice": "UGX 25,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_3-4-hp-brass-ballvalve-part1-23008.jpg",
      "itemPrice": 25000
    },
    {
      "itemId": 38,
      "itemName":
          "Flexible Tap Connector 15mm x 1/2in x 300mm Length HD125A/15W",
      "stringPrice": "UGX 17,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_p1.png",
      "itemPrice": 17000
    },
    {
      "itemId": 39,
      "itemName": "Speedfit PEMSTC2216 Straight Tap Connector 22mmx3/4\"",
      "stringPrice": "UGX 12,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_p2.png",
      "itemPrice": 12000
    },
    {
      "itemId": 40,
      "itemName": "SOLVENT 92.5 DEGREE BEND 40MM 5 PACK",
      "stringPrice": "UGX 19,000",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/thumb_3.jpg",
      "itemPrice": 19000
    }
  ];

  final installationItems = [
    {
      "itemId": 77,
      "itemName": "Portable 19 in. L White Outdoor Sink Hand Wash Basin",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/accessories-493979991231-64_300.jpg",
      "stringPrice": "UGX 215,000",
      "itemPrice": 215000
    },
    {
      "itemId": 78,
      "itemName":
          "12 in. x 16 in. Stainless Steel Hand Sink. Commercial Wall Mount Hand Basin with Gooseneck Faucet. NSF Certified",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/stainless-steel-amgood-wall-mount-sinks-hand-sink-hs-12-64_300.jpg",
      "stringPrice": "UGX 394,000",
      "itemPrice": 394000
    },
    {
      "itemId": 79,
      "itemName":
          "Portable 19 l White Outdoor Sink Hand Wash Basin with Toilet",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/accessories-483508532400-64_300.jpg",
      "stringPrice": "UGX 477,500",
      "itemPrice": 477500
    },
    {
      "itemId": 80,
      "itemName":
          "19.75 in. x 32.75 in. Grey Camping Sink Wash Station Basin with 4.5 Gal. Tank and Soap Dispenser",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/kleankin-camping-utensils-a20-082-64_300.jpg",
      "stringPrice": "UGX 358,000",
      "itemPrice": 358000
    },
    {
      "itemId": 81,
      "itemName":
          "Portable Sink, Outdoor Sink and Hand Washing Station, 19L Water Tank",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/hike-crew-accessories-hcchh7701c-64_300.jpg",
      "stringPrice": "UGX 394,000",
      "itemPrice": 394000
    },
    {
      "itemId": 82,
      "itemName":
          "17 in. Wall Mount Stainless Steel 1 Compartment Commercial Hand Wash Sink",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/stainlesss-steel-commercial-kitchen-sinks-chs17-4gf-64_300.jpg",
      "stringPrice": "UGX 554,000",
      "itemPrice": 554000
    },
    {
      "itemId": 83,
      "itemName":
          "17 in. x 15 in. Stainless Steel Hand Sink. Commercial Wall Mount Hand Basin with Gooseneck Faucet. NSF Certified",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/stainless-steel-amgood-wall-mount-sinks-hand-sink-hs-17-64_300.jpg",
      "stringPrice": "UGX 542,500",
      "itemPrice": 542500
    },
    {
      "itemId": 84,
      "itemName":
          "17 in. Stainless Steel 18-Gauge Wall Mount 1-Compartment Commercial Kitchen Hand Sink with Faucet",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/stainless-steel-gridmann-commercial-kitchen-sinks-rest-sink-hs-gr13-serv1-64_300.jpg",
      "stringPrice": "UGX 589,500",
      "itemPrice": 589500
    },
    {
      "itemId": 85,
      "itemName":
          "Portable 19 l White Outdoor Sink Hand Wash Basin with 24 l Tank",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/accessories-997441222439-64_300.jpg",
      "stringPrice": "UGX 357,000",
      "itemPrice": 357000
    },
    {
      "itemId": 86,
      "itemName":
          "18-Gauge 17 in. Stainless Steel Wall Mount 1-Compartment Commercial Kitchen Hand Sink with Faucet and Sidesplashes",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/stainless-steel-gridmann-commercial-kitchen-sinks-rest-sink-hs-gr14-serv2-64_300.jpg",
      "stringPrice": "UGX 679,000",
      "itemPrice": 679000
    },
    {
      "itemId": 87,
      "itemName":
          "One Manual Hand Washing System, 20 x 18 in. Wall Hung Lavatory with 0.5 GPM, Centerset Faucet, Wrist Handles",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/9ed58732-d6f7-4315-b75a-198f6df26036/svn/white-zurn-wall-mount-sinks-z-l3-m-64_300.jpg",
      "stringPrice": "UGX 1,152,500",
      "itemPrice": 1152500
    },
    {
      "itemId": 88,
      "itemName":
          "12 in. x 16 in. Commercial Stainless Steel Wall Mounted Hand Sink with Side Splash and Gooseneck Faucet. NSF Certified",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/c80340b4-be06-44aa-bbca-ed4c87ca22ec/svn/stainless-steel-amgood-wall-mount-sinks-hand-sink-hs-12ss-64_300.jpg",
      "stringPrice": "UGX 447,500",
      "itemPrice": 447500
    },
    {
      "itemId": 65,
      "itemName": "Darfield 0.5 or 1.0 GPF Urinal in Black Black",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/black-black-kohler-urinals-k-5024-t-7-64_300.jpg",
      "stringPrice": "UGX 1,216,500",
      "itemPrice": 1216500
    },
    {
      "itemId": 66,
      "itemName": "Steward 0.125 GPF High-Efficiency Urinal in White",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/white-kohler-urinals-k-5244-et-0-64_300.jpg",
      "stringPrice": "UGX 1,867,500",
      "itemPrice": 1867500
    },
    {
      "itemId": 67,
      "itemName": "Wash Brook Universal 1.0 GPF Urinal in White",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/white-american-standard-urinals-6515001-020-64_300.jpg",
      "stringPrice": "UGX 1,375,000",
      "itemPrice": 1375000
    },
    {
      "itemId": 68,
      "itemName":
          "59 in. W x 18 in. D x 34 in. H Freestanding Bathroom Vanity in Dark Brown with Double Glossy White Resin Basin Top",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/white-zurn-urinals-z-ur2-s-tm-64_300.jpg",
      "stringPrice": "UGX 2,028,500",
      "itemPrice": 2028500
    },
    {
      "itemId": 69,
      "itemName":
          "Zurn One Battery Powered Sensor Urinal System with 0.125 GPF Flush Valve",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/white-zurn-urinals-z-ur1-s-64_300.jpg",
      "stringPrice": "UGX 2,585,500",
      "itemPrice": 2585500
    },
    {
      "itemId": 70,
      "itemName": "Dexter 1.0 GPF Urinal with Rear Spud in Black Black",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/black-black-kohler-urinals-k-5016-er-7-64_300.jpg",
      "stringPrice": "UGX 929,000",
      "itemPrice": 929000
    },
    {
      "itemId": 71,
      "itemName":
          "One Battery Powered Sensor Urinal System with 0.5 GPF Flush Valve",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/white-zurn-urinals-z-ur2-s-64_300.jpg",
      "stringPrice": "UGX 2,896,000",
      "itemPrice": 2896000
    },
    {
      "itemId": 72,
      "itemName":
          "One Battery Powered Sensor 0.125 GPF Urinal System with Top Mount in White",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/white-zurn-urinals-z-ur1-s-tm-64_300.jpg",
      "stringPrice": "UGX 2,479,000",
      "itemPrice": 2479000
    },
    {
      "itemId": 73,
      "itemName": "Waterless Touch-Free Standard Urinal in White",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/white-sloan-urinals-wes-1000-64_300.jpg",
      "stringPrice": "UGX 2,353,000",
      "itemPrice": 2353000
    },
    {
      "itemId": 74,
      "itemName":
          "Lynbrook 1 GPF Top Spud Urinal with Blowout Flush Action in. White",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/white-american-standard-urinals-6601-012-020-64_300.jpg",
      "stringPrice": "UGX 1,490,500",
      "itemPrice": 1490500
    },
    {
      "itemId": 75,
      "itemName": "Gobi Waterless Urinal in White",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/white-helvex-urinals-wlu-gobi-tds-64_300.jpg",
      "stringPrice": "UGX 2,039,500",
      "itemPrice": 2039500
    },
    {
      "itemId": 76,
      "itemName": "Steward Waterless Urinal in White",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/white-kohler-urinals-k-4918-0-64_300.jpg",
      "stringPrice": "UGX 2,245,500",
      "itemPrice": 2245500
    },
    {
      "itemId": 41,
      "itemName": "Descaler Cleaning Liquid for Pumps",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/052-3.jpg",
      "stringPrice": "UGX 167,500",
      "itemPrice": 167500
    },
    {
      "itemId": 42,
      "itemName": "Membrane",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/si200184-2.jpg",
      "stringPrice": "UGX 152,500",
      "itemPrice": 152500
    },
    {
      "itemId": 43,
      "itemName": "WM266 Replacement Pump for Qwik Jon Model 102",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/014955-4.jpg",
      "stringPrice": " UGX 1,869,500",
      "itemPrice": 1869500
    },
    {
      "itemId": 44,
      "itemName": "SaniPLUS Macerating Pump (White)",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/002-saniflo-3.jpg",
      "stringPrice": " UGX 3,367,000",
      "itemPrice": 3367000
    },
    {
      "itemId": 45,
      "itemName": "Horseshoe Clip (2 Pieces)",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/va100144-4.jpg",
      "stringPrice": " UGX 57,000",
      "itemPrice": 57000
    },
    {
      "itemId": 46,
      "itemName": "Float Switch Assembly for Model 202/203",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/018501-3.jpg",
      "stringPrice": "UGX 386,000",
      "itemPrice": 386000
    },
    {
      "itemId": 47,
      "itemName": "Qwik Jon Premier Grinder Pump & Tank",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/201-0006-1.jpg",
      "stringPrice": " UGX 3,282,500",
      "itemPrice": 3282500
    },
    {
      "itemId": 48,
      "itemName":
          "Extension Pipe - Extension pipe between Toilet and Macerator (White)",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/030-3.jpg",
      "stringPrice": "UGX 182,500",
      "itemPrice": 182500
    },
    {
      "itemId": 49,
      "itemName": "Condensate Neutralizing Kit",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/043-3.jpg",
      "stringPrice": "UGX 359,500",
      "itemPrice": 359500
    },
    {
      "itemId": 50,
      "itemName": "SaniBEST Pro Grinder Pump (White)",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/013-6.jpg",
      "stringPrice": " UGX 4,027,500",
      "itemPrice": 4027500
    },
    {
      "itemId": 51,
      "itemName": "N202 Replacement Pump w/ Discharge Pipe",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/017374-3.jpg",
      "stringPrice": " UGX 3,310,500",
      "itemPrice": 3310500
    },
    {
      "itemId": 52,
      "itemName": "Sanigrind Grinder Pump for Bottom Outlet Toilets (White)",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/014-4.jpg",
      "stringPrice": " UGX 4,161,500",
      "itemPrice": 4161500
    },
    {
      "itemId": 53,
      "itemName":
          "Sanicompact One Piece Toilet w/ Macerator Built into the Base (White)",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/023-2.jpg",
      "stringPrice": " UGX 4,041,000",
      "itemPrice": 4041000
    },
    {
      "itemId": 54,
      "itemName": "Round Membrane Clip",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/bl120624-3.jpg",
      "stringPrice": " UGX 20,000",
      "itemPrice": 20000
    },
    {
      "itemId": 55,
      "itemName": "Discharge Elbow Complete For Sani Plus II Macerating Unit",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/cmbsav-1.jpg",
      "stringPrice": "UGX 239,000",
      "itemPrice": 239000
    },
    {
      "itemId": 56,
      "itemName": "Saniaccess 3 Macerating Pump (White)",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/082-saniflo-5.jpg",
      "stringPrice": " UGX 3,391,500",
      "itemPrice": 3391500
    },
    {
      "itemId": 57,
      "itemName": "Lateral Grill Absorber",
      "itemImage":
          "https://d3501hjdis3g5w.cloudfront.net/html/react/b4053d546f022cf5778b572e2d9f78f0.jpg",
      "stringPrice": " UGX 39,000",
      "itemPrice": 39000
    },
    {
      "itemId": 58,
      "itemName": "Sanialarm-Alarm for the Macerators and Sanivite (White)",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/050-4.jpg",
      "stringPrice": "UGX 237,500",
      "itemPrice": 237500
    },
    {
      "itemId": 59,
      "itemName": "Saniaccess 2 Macerating Pump (White)",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/081-saniflo-4.jpg",
      "stringPrice": " UGX 2,916,000",
      "itemPrice": 2916000
    },
    {
      "itemId": 61,
      "itemName": "Extension Kit for Qwik Jon 202 Ultima Tank",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/10-3050-1.jpg",
      "stringPrice": "UGX 324,000",
      "itemPrice": 324000
    },
    {
      "itemId": 62,
      "itemName":
          "Sanicubic 1 Simplex System, Above the Floor Installation (White)",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/089-2.jpg",
      "stringPrice": " UGX 7,809,500",
      "itemPrice": 7809500
    },
    {
      "itemId": 41,
      "itemName": "Classic Centerset Two Handle Laundry Faucet w/ Hose Thread",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/2131lf-3.jpg",
      "stringPrice": "UGX 196,000",
      "itemPrice": 196000
    },
    {
      "itemId": 42,
      "itemName": "Classic Monitor 13 Series Tub and Shower Trim",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/t13420-3.jpg",
      "stringPrice": "UGX 304,500",
      "itemPrice": 304500
    },
    {
      "itemId": 43,
      "itemName": "Chateau Posi-Temp Tub and Shower Trim (Chrome)",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/tl183-3.jpg",
      "stringPrice": "UGX 164,000",
      "itemPrice": 164000
    },
    {
      "itemId": 44,
      "itemName": "Foundations Monitor 13 Series Shower Only Faucet Trim Kit",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/bt13210-3.jpg",
      "stringPrice": "UGX 177,000",
      "itemPrice": 177000
    },
    {
      "itemId": 45,
      "itemName": "Classic Single Handle Kitchen Faucet with Spray (DST)",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/400-dst-5.jpg",
      "stringPrice": "UGX 401,500",
      "itemPrice": 401500
    },
    {
      "itemId": 46,
      "itemName": "Chateau Posi-Temp Shower Only Trim (Chrome)",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/tl182ep-2.jpg",
      "stringPrice": " UGX 97,000",
      "itemPrice": 97000
    },
    {
      "itemId": 47,
      "itemName":
          "MIX-60-A Below Deck Mechanical Water Mixing Valve for use w/ Optima Plus EBF-615/EBF-650 Faucets",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/3326009-3.jpg",
      "stringPrice": "UGX 134,000",
      "itemPrice": 134000
    },
    {
      "itemId": 48,
      "itemName": "Single Handle Centerset Lav Faucet",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/ftb501-3.jpg",
      "stringPrice": "UGX 205,000",
      "itemPrice": 205000
    },
    {
      "itemId": 49,
      "itemName": "Commercial Two Handle 8\" Wall Mount Service Sink Faucet",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/ftc28t9-4.jpg",
      "stringPrice": "UGX 370,500",
      "itemPrice": 370500
    },
    {
      "itemId": 50,
      "itemName": "Classic Single Handle Kitchen Faucet w/ Spray",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/ftk400-4.jpg",
      "stringPrice": "UGX 301,000",
      "itemPrice": 301000
    },
    {
      "itemId": 51,
      "itemName": "Classic Single Handle Kitchen Faucet",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/ftk100-3.jpg",
      "stringPrice": "UGX 243,000",
      "itemPrice": 243000
    },
    {
      "itemId": 52,
      "itemName": "Classic Single Handle Centerset Lav Faucet (Metal Pop-Up)",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/520-mpu-dst-3.jpg",
      "stringPrice": "UGX 391,500",
      "itemPrice": 391500
    },
    {
      "itemId": 53,
      "itemName": "Foundations Single Handle Centerset Lav Faucet",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/b501lf-4.jpg",
      "stringPrice": "UGX 244,000",
      "itemPrice": 244000
    },
    {
      "itemId": 54,
      "itemName":
          "Innovator QuickTrim Push Pull Trim Kit with Star Retainer Nut and Adapter Bar (Wrought Iron)",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/939290-wi-2.jpg",
      "stringPrice": "UGX 131,500",
      "itemPrice": 131500
    },
    {
      "itemId": 55,
      "itemName":
          "8\" EasyInstall Pre-Rinse Spring-Action Wall Mount Mixing Faucet w/ Add-On Faucet",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/b-0133-adf12-b-1.jpg",
      "stringPrice": " UGX 1,733,000",
      "itemPrice": 1733000
    },
    {
      "itemId": 56,
      "itemName":
          "Two Handle Clamp On Laundry Faucet w/ IPS/Sweat Connections, Threaded Hose Spout, Rough Brass (49-530)",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/g0049530-3.jpg",
      "stringPrice": "UGX 243,000",
      "itemPrice": 243000
    },
    {
      "itemId": 57,
      "itemName": "HWT-00 Instant Hot Water Tank for Hot Water Dispensers",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/44875-4.jpg",
      "stringPrice": " UGX 1,344,000",
      "itemPrice": 1344000
    },
    {
      "itemId": 58,
      "itemName":
          "8\" Wall Mount Double Pantry Mixing Faucet w/ Stream Regulator Outlet, 12\" Swing Nozzle",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/b-0231-3.jpg",
      "stringPrice": "UGX 571,500",
      "itemPrice": 571500
    },
    {
      "itemId": 59,
      "itemName":
          "H-HOT100C-SS Invite HOT100 Instant Hot Water Dispenser System w/ Tank (Chrome)",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/44887-5.jpg",
      "stringPrice": "UGX 745,000",
      "itemPrice": 745000
    },
    {
      "itemId": 60,
      "itemName":
          "Classic Monitor 13 Series Tub and Shower Trim (w/ 6\" Pull-Down Diverter Spout)",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/t13420-pd-3.jpg",
      "stringPrice": "UGX 329,500",
      "itemPrice": 329500
    },
    {
      "itemId": 61,
      "itemName": "Chateau Single Handle Kitchen Faucet w/ Spray (Chrome)",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/7430-3.jpg",
      "stringPrice": "UGX 431,500",
      "itemPrice": 431500
    },
    {
      "itemId": 62,
      "itemName": "Foundations Monitor 13 Series Tub and Shower Trim",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/bt13410-3.jpg",
      "stringPrice": "UGX 250,000",
      "itemPrice": 250000
    },
    {
      "itemId": 63,
      "itemName":
          "Classic Single Handle Kitchen Faucet (Diamond Seal Technology)",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/100-dst-4.jpg",
      "stringPrice": "UGX 345,000",
      "itemPrice": 345000
    },
    {
      "itemId": 64,
      "itemName":
          "8\" Wall Mount Mixing Service Sink Faucet w/ Vacuum Breaker & Built-In Service Stops",
      "itemImage":
          "https://lansonndehplumbing.s3.amazonaws.com/product_images/b-0665-bstr-3.jpg",
      "stringPrice": "UGX 636,500",
      "itemPrice": 636500
    }
  ];
  // Convert restaurant menu items to JSON
  if (orderType == OrderType.fixtures) {
    return fixtureItems.map((json) => PlumbingMenuItem.fromJson(json)).toList();
  }
  return installationItems
      .map((json) => PlumbingMenuItem.fromJson(json))
      .toList();
}
