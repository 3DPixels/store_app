import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:store_app/MobileCatSearch.dart';
import 'package:store_app/ProductDetails.dart';
import 'package:store_app/SearchPages/LaptopCatSearch.dart';

class autoSearchCompelete extends StatefulWidget {
  @override
  _autoSearchCompeleteState createState() => _autoSearchCompeleteState();
}

class _autoSearchCompeleteState extends State<autoSearchCompelete> {
  final database = FirebaseFirestore.instance;
  String searchString = '';
  String ddSearchCategory;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 110),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                TextField(
                  textAlignVertical: TextAlignVertical.center,
                  textCapitalization: TextCapitalization.none,
                  autofocus: false,
                  style: TextStyle(fontSize: 16),
                  cursorColor: Colors.blue[900],
                  onChanged: (val) {
                    setState(() {
                      searchString = val.toLowerCase().trim();
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white70,
                    prefixIcon: IconButton(
                      color: Colors.black,
                      icon: Icon(Icons.arrow_back),
                      iconSize: 20.0,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    contentPadding: EdgeInsets.only(left: 25.0),
                    hintText: 'Search By Name',
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 30,
                  margin: EdgeInsets.only(left: 5, right: 5),
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(20)),
                  child: DropdownButton<String>(
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w600),
                    items: [
                      DropdownMenuItem<String>(
                        child: Text('Laptops'),
                        value: 'laptops',
                      ),
                      DropdownMenuItem<String>(
                        child: Text('Mobiles'),
                        value: 'mobiles',
                      ),
                      DropdownMenuItem<String>(
                        child: Text('Home Appliances'),
                        value: 'home',
                      ),
                    ],
                    onChanged: (String value) {
                      setState(() {
                        if (value == 'laptops') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => laptopCatSearch()));
                        } else if (value == 'mobiles') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => mobileCatSearch()));
                        } else {}
                      });
                    },
                    hint: Text('Choose Category'),
                    value: ddSearchCategory,
                  ),
                ),
              ],
            ),
          ),
          centerTitle: false,
          backgroundColor: Color(0xFF731800),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 10),
                Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collectionGroup('Products')
                      .where('searchIndex', arrayContains: searchString)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      default:
                        final products = snapshot.data.docs;
                        var productview;
                        List<SingleProduct> productsview = [];
                        for (var product in products) {
                          final productname = product.data()['Product Name'];
                          final productprice = product.data()['Price'];
                          final productimg = product.data()['imgURL'];
                          final producttype = product.data()['type'];
                          final productdesc = product.data()['Description'];
                          final productbrand = product.data()['Brand Name'];
                          final productquantity = product.data()['Quantity'];
                          final productseller = product.data()['Seller Email'];
                          final productdiscount = product.data()['Discount'];
                          final productdiscountpercent =
                              product.data()['Discount percent'];
                          final productnewprice = product.data()['New price'];
                          final rate1star = product.data()['1 star rate'];
                          final rate2star = product.data()['2 star rate'];
                          final rate3star = product.data()['3 star rate'];
                          final rate4star = product.data()['4 star rate'];
                          final rate5star = product.data()['5 star rate'];
                          final productrating = product.data()['Rating'];
                          final productid = product.id;
                          //now stuff that's specific for every product type
                          if (producttype == 'Mobiles') {
                            final productStorage = product.data()['Storage'];
                            final productbattery = product.data()['Battery'];
                            final productmemory = product.data()['Memory'];
                            final productcamera = product.data()['Camera'];
                            final productos = product.data()['OS'];
                            productview = SingleProduct.mobile(
                              productName: productname,
                              productPrice: productprice,
                              productNewPrice: productnewprice,
                              productDiscountFlag: productdiscount,
                              productDiscountPercent: productdiscountpercent,
                              productImg: productimg,
                              productType: producttype,
                              productDesc: productdesc,
                              productBrand: productbrand,
                              productQuantity: productquantity,
                              productSeller: productseller,
                              productID: productid,
                              productRating: productrating,
                              productOS: productos,
                              productMemory: productmemory,
                              productCamera: productcamera,
                              productStorage: productStorage,
                              productBattery: productbattery,
                              rate1star: rate1star,
                              rate2star: rate2star,
                              rate3star: rate3star,
                              rate4star: rate4star,
                              rate5star: rate5star,
                            );
                          } else if (producttype == 'Laptops') {
                            final productStorage = product.data()['Storage'];
                            final productbattery = product.data()['Battery'];
                            final productmemory = product.data()['Memory'];
                            final productcpu = product.data()['CPU'];
                            final productgpu = product.data()['GPU'];
                            final productos = product.data()['OS'];
                            productview = SingleProduct.laptop(
                              productName: productname,
                              productPrice: productprice,
                              productNewPrice: productnewprice,
                              productDiscountFlag: productdiscount,
                              productDiscountPercent: productdiscountpercent,
                              productImg: productimg,
                              productType: producttype,
                              productDesc: productdesc,
                              productBrand: productbrand,
                              productQuantity: productquantity,
                              productSeller: productseller,
                              productID: productid,
                              rate1star: rate1star,
                              rate2star: rate2star,
                              rate3star: rate3star,
                              rate4star: rate4star,
                              rate5star: rate5star,
                              productRating: productrating,
                              productOS: productos,
                              productMemory: productmemory,
                              productCPU: productcpu,
                              productGPU: productgpu,
                              productStorage: productStorage,
                              productBattery: productbattery,
                            );
                          } else {
                            productview = SingleProduct(
                              productName: productname,
                              productPrice: productprice,
                              productNewPrice: productnewprice,
                              productDiscountFlag: productdiscount,
                              productDiscountPercent: productdiscountpercent,
                              productImg: productimg,
                              productType: producttype,
                              productDesc: productdesc,
                              productBrand: productbrand,
                              productQuantity: productquantity,
                              productSeller: productseller,
                              productID: productid,
                              rate1star: rate1star,
                              rate2star: rate2star,
                              rate3star: rate3star,
                              rate4star: rate4star,
                              rate5star: rate5star,
                              productRating: productrating,
                            );
                          }
                          productsview.add(productview);
                        }
                        return ListView(
                          children: productsview,
                        );
                    }
                  },
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SingleProduct extends StatefulWidget {
  final String productName;
  final double productPrice;
  final String productNewPrice;
  final String productDiscountFlag;
  final String productDiscountPercent;
  final String productImg;
  final String productType;
  final String productID;
  final String productDesc;
  final String productBrand;
  final String productQuantity;
  final String productSeller;
  final String productRating;
  final int rate1star;
  final int rate2star;
  final int rate3star;
  final int rate4star;
  final int rate5star;
  //mobile/laptop stuff
  int productStorage;
  String productBattery;
  String productMemory;
  String productCamera;
  String productOS;
  //laptop stuff
  String productCPU;
  String productGPU;

  SingleProduct(
      {this.productName,
      this.productPrice,
      this.productNewPrice,
      this.productDiscountFlag,
      this.productDiscountPercent,
      this.productImg,
      this.productID,
      this.productType,
      this.productDesc,
      this.productBrand,
      this.productQuantity,
      this.productSeller,
      this.productRating,
      this.rate1star,
      this.rate2star,
      this.rate3star,
      this.rate4star,
      this.rate5star});

  SingleProduct.mobile(
      {this.productName,
      this.productPrice,
      this.productNewPrice,
      this.productDiscountFlag,
      this.productDiscountPercent,
      this.productImg,
      this.productID,
      this.productType,
      this.productDesc,
      this.productBrand,
      this.productQuantity,
      this.productSeller,
      this.productRating,
      this.productStorage,
      this.productOS,
      this.productBattery,
      this.productCamera,
      this.productMemory,
      this.rate1star,
      this.rate2star,
      this.rate3star,
      this.rate4star,
      this.rate5star});

  SingleProduct.laptop(
      {this.productName,
      this.productPrice,
      this.productNewPrice,
      this.productDiscountFlag,
      this.productDiscountPercent,
      this.productImg,
      this.productID,
      this.productType,
      this.productDesc,
      this.productBrand,
      this.productQuantity,
      this.productSeller,
      this.productRating,
      this.productStorage,
      this.productOS,
      this.productBattery,
      this.productCPU,
      this.productGPU,
      this.productMemory,
      this.rate1star,
      this.rate2star,
      this.rate3star,
      this.rate4star,
      this.rate5star});

  @override
  _SingleProductState createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool isPressed = false;
  bool cartIsPressed = false;

  Future addToCart() async {
    if (customer.firstName == "temp") {
      Fluttertoast.showToast(msg: "You need to sign in first");
    } else {
      print('first check if product already in cart');

      await _firestore
          .collection('Customers')
          .doc(_auth.currentUser.uid)
          .collection('cart')
          .doc(widget.productID)
          .get()
          .then((DocumentSnapshot snapshot) async {
        if (snapshot.exists) {
          print('product already in cart');
          Fluttertoast.showToast(msg: "Product already in cart");
        } else {
          print('insert product id in cart');
          await _firestore
              .collection('Customers')
              .doc(_auth.currentUser.uid)
              .collection('cart')
              .doc(widget.productID)
              .set({
            'ProductID': widget.productID,
            'CustomerID': _auth.currentUser.uid,
            'Product Quantity': 1,
            'Product Name': widget.productName,
            'Price': widget.productPrice,
            'New price': widget.productNewPrice,
            'Discount': widget.productDiscountFlag,
            'Discount percent': widget.productDiscountPercent,
            'type': widget.productType,
            'ChangeFlag': 'false',
            'imgURL': widget.productImg
          });
          double price;
          if (widget.productDiscountFlag == 'false')
            price = widget.productPrice;
          else
            price = double.parse(widget.productNewPrice);
          await _firestore
              .collection('Customers')
              .doc(_auth.currentUser.uid)
              .update({'Total': FieldValue.increment(price)});
          setState(() {
            cartIsPressed = true;
          });
          print('Product added to cart');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          if (widget.productType == 'Mobiles') {
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (context) => ProductDetails.Mobile(
                  // passing the values via constructor
                  product_detail_name: widget.productName,
                  product_detail_price: widget.productPrice,
                  product_detail_newPrice: widget.productNewPrice,
                  product_discount_flag: widget.productDiscountFlag,
                  product_discount_percent: widget.productDiscountPercent,
                  product_detail_picture: widget.productImg,
                  product_detail_desc: widget.productDesc,
                  product_detail_brand: widget.productBrand,
                  product_detail_quantity: widget.productQuantity,
                  product_detail_seller: widget.productSeller,
                  rate1star: widget.rate1star,
                  rate2star: widget.rate2star,
                  rate3star: widget.rate3star,
                  rate4star: widget.rate4star,
                  rate5star: widget.rate5star,
                  product_detail_rating: widget.productRating,
                  product_detail_type: widget.productType,
                  product_detail_id: widget.productID,
                  mobile_storage: widget.productStorage,
                  mobile_battery: widget.productBattery,
                  mobile_camera: widget.productCamera,
                  mobile_memory: widget.productMemory,
                  mobile_os: widget.productOS,
                ),
              ),
            );
          } else if (widget.productType == 'Laptops') {
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (context) => ProductDetails.Laptop(
                  // passing the values via constructor
                  product_detail_name: widget.productName,
                  product_detail_price: widget.productPrice,
                  product_detail_newPrice: widget.productNewPrice,
                  product_discount_flag: widget.productDiscountFlag,
                  product_discount_percent: widget.productDiscountPercent,
                  product_detail_picture: widget.productImg,
                  product_detail_desc: widget.productDesc,
                  product_detail_brand: widget.productBrand,
                  product_detail_quantity: widget.productQuantity,
                  product_detail_seller: widget.productSeller,
                  rate1star: widget.rate1star,
                  rate2star: widget.rate2star,
                  rate3star: widget.rate3star,
                  rate4star: widget.rate4star,
                  rate5star: widget.rate5star,
                  product_detail_rating: widget.productRating,
                  product_detail_type: widget.productType,
                  product_detail_id: widget.productID,
                  mobile_storage: widget.productStorage,
                  mobile_battery: widget.productBattery,
                  CPU: widget.productCPU,
                  GPU: widget.productGPU,
                  mobile_memory: widget.productMemory,
                  mobile_os: widget.productOS,
                ),
              ),
            );
          } else {
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (context) => ProductDetails(
                  // passing the values via constructor
                  product_detail_name: widget.productName,
                  product_detail_price: widget.productPrice,
                  product_detail_newPrice: widget.productNewPrice,
                  product_discount_flag: widget.productDiscountFlag,
                  product_discount_percent: widget.productDiscountPercent,
                  product_detail_picture: widget.productImg,
                  product_detail_desc: widget.productDesc,
                  product_detail_brand: widget.productBrand,
                  product_detail_quantity: widget.productQuantity,
                  product_detail_seller: widget.productSeller,
                  rate1star: widget.rate1star,
                  rate2star: widget.rate2star,
                  rate3star: widget.rate3star,
                  rate4star: widget.rate4star,
                  rate5star: widget.rate5star,
                  product_detail_rating: widget.productRating,
                  product_detail_type: widget.productType,
                  product_detail_id: widget.productID,
                ),
              ),
            );
          }
        },
        child: ListTile(
          //    ======= the leading image section =======
          leading: FadeInImage.assetNetwork(
            placeholder: 'images/PlaceHolder.gif',
            image: (widget.productImg == null)
                ? "https://firebasestorage.googleapis.com/v0/b/store-cc25c.appspot.com/o/uploads%2FPlaceHolder.gif?alt=media&token=89558fba-e8b6-4b99-bcb7-67bf1412a83a"
                : widget.productImg,
            height: 80,
            width: 80,
          ),
          title: Text(widget.productName),
          subtitle: Column(
            children: <Widget>[
              //  ======= this for price section ======
              Container(
                alignment: Alignment.topLeft,
                child: (widget.productDiscountFlag == 'false')
                    ? Text(
                        "${widget.productPrice} EGP",
                        style: TextStyle(color: Colors.red),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${widget.productPrice}",
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${widget.productNewPrice} EGP",
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RatingBarIndicator(
                    rating: double.parse(widget.productRating),
                    itemSize: 20.0,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                  ),
                  Text(
                    '${widget.productRating}',
                    style: TextStyle(height: 1.5),
                  ),
                  Spacer(),
                  IconButton(
                      icon: (isPressed)
                          ? Icon(Icons.favorite)
                          : Icon(Icons.favorite_outline),
                      tooltip: 'Add to favorites',
                      color: Colors.red,
                      onPressed: () {
                        setState(() {
                          if (isPressed)
                            isPressed = false;
                          else
                            isPressed = true;
                        });
                      }),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    icon: (cartIsPressed)
                        ? Icon(Icons.download_done_rounded)
                        : Icon(Icons.add_shopping_cart_outlined),
                    tooltip: 'Add to cart',
                    color: Colors.black,
                    onPressed: cartIsPressed ? null : () => addToCart(),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
