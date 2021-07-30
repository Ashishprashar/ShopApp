import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  // final String title;
  static const routeName = "/edit-product-screen";

  // EditProductScreen(this.title);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocuseNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageUrlNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editorproduct =
      Product(id: "", title: "", description: "", price: 0, imageUrl: "");
  var init = true;
  var _isLoading = false;
  var _initValues = {
    'title': '',
    'description': "",
    "price": "",
    "imageUrl": "",
  };
  @override
  void initState() {
    _imageUrlNode.addListener(_updateImageUrl);
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (init) {
      final id = ModalRoute.of(context)!.settings.arguments;
      print(id);
      if (id != "") {
        try {
          _editorproduct = Provider.of<Products>(context, listen: false)
              .findById(id as String);
        } catch (E) {
          print(id);
        }
        _initValues = {
          'title': _editorproduct.title,
          'description': _editorproduct.description,
          "price":
              _editorproduct.price == 0 ? "" : _editorproduct.price.toString(),
        };
        _imageUrlController.text = _editorproduct.imageUrl;
      }
    }
    init = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _imageUrlNode.removeListener(_updateImageUrl);
    _descriptionNode.dispose();
    _priceFocuseNode.dispose();
    _imageUrlController.dispose();
    _imageUrlNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    print("working");
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editorproduct.id != "") {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editorproduct.id, _editorproduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      // ignore: await_only_futures
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editorproduct);
      } catch (error) {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text("error ocuured"),
                content: Text("Somthing went Wrong"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: Text("go back"))
                ],
              );
            });
      } finally {
        setState(() {
          _isLoading = false;
          Navigator.of(context).pop();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final title=args.
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new Products"),
        actions: [
          IconButton(
              onPressed: () {
                _saveForm();
                print("hello");
              },
              icon: Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(
                        labelText: "Title",
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "please Provide value";
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_priceFocuseNode);
                      },
                      onSaved: (val) {
                        _editorproduct = Product(
                            id: _editorproduct.id,
                            title: val as String,
                            description: _editorproduct.description,
                            price: _editorproduct.price,
                            imageUrl: _editorproduct.imageUrl);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(
                        labelText: "Price",
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocuseNode,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_descriptionNode);
                      },
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "please Provide value";
                        }
                        if (double.tryParse(val) == null) {
                          return "should be a numric value";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _editorproduct = Product(
                            id: _editorproduct.id,
                            title: _editorproduct.title,
                            description: _editorproduct.description,
                            price: double.parse(val!),
                            isFavorite: _editorproduct.isFavorite,
                            imageUrl: _editorproduct.imageUrl);
                      },
                    ),

                    // height: 100,
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(
                        labelText: "Description",
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "please Provide value";
                        }

                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionNode,
                      onSaved: (val) {
                        _editorproduct = Product(
                            id: _editorproduct.id,
                            title: _editorproduct.title,
                            isFavorite: _editorproduct.isFavorite,
                            description: val as String,
                            price: _editorproduct.price,
                            imageUrl: _editorproduct.imageUrl);
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 20),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: _imageUrlController.text.isEmpty
                              ? Text("Enter the image Url ")
                              : FittedBox(
                                  child:
                                      Image.network(_imageUrlController.text),
                                  fit: BoxFit.fill,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            // initialValue: _initValues['imageUrl'],
                            decoration: InputDecoration(
                              labelText: "Image Url",
                            ),
                            controller: _imageUrlController,
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,

                            focusNode: _imageUrlNode,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "please Provide value";
                              }
                              if (!val.startsWith("https://")) {
                                return "please Provide value";
                              }

                              return null;
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (val) {
                              _editorproduct = Product(
                                  id: _editorproduct.id,
                                  isFavorite: _editorproduct.isFavorite,
                                  title: _editorproduct.title,
                                  description: _editorproduct.description,
                                  price: _editorproduct.price,
                                  imageUrl: val as String);
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
