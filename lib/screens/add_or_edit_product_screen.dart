// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

import '../providers/product_model.dart';

class AddOrEditProduct extends StatefulWidget {
  static const String routeName = '/add_edit_products';
  const AddOrEditProduct({Key? key}) : super(key: key);

  @override
  State<AddOrEditProduct> createState() => _AddOrEditProductState();
}

class _AddOrEditProductState extends State<AddOrEditProduct> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  late String _title;
  late double _price;
  late String _description;
  bool _isFavorite = false;
  late Product _editedProduct;
  bool _addnew = false;
  bool _isInit = true;
  bool _isloading = false;
  late String _appBarTitle;

  bool _checkUrl(String url) {
    var urlPattern =
        r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
    return new RegExp(urlPattern, caseSensitive: false).hasMatch(url);
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      String productId = ModalRoute.of(context)!.settings.arguments as String;
      if (productId != 'NewProduct') {
        _appBarTitle = 'Edit Product';
        _editedProduct = Provider.of<Products>(context).findById(productId);
        _imageUrlController.text = _editedProduct.imageUrl;
        _isFavorite = _editedProduct.isFavorite;
      } else {
        _addnew = true;
        _appBarTitle = 'Add Product';
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    bool isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isloading = true;
    });
    if (!_addnew) {
      try {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct);
      } catch (error) {
        print(error);
      }
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error occurred!'),
                  content:
                      Text('something went wrong, please try again later!'),
                  actions: [
                    TextButton(
                        child: Text(
                          'Close',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        })
                  ],
                ));
      }
    }
    setState(() {
      _isloading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm();
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _addnew ? '' : _editedProduct.title,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please enter a Title!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: ((value) {
                        _title = value!;
                      }),
                    ),
                    TextFormField(
                      initialValue:
                          _addnew ? '' : _editedProduct.price.toString(),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please enter a Price!';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a number';
                        }
                        if (double.parse(value) < 0 ||
                            double.parse(value) >= 10000000000) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: ((value) {
                        _price = double.parse(value!);
                      }),
                    ),
                    TextFormField(
                      initialValue: _addnew ? '' : _editedProduct.description,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please enter Description, at least 20 Characters!';
                        }

                        if (value.length < 20) {
                          return 'you need more ${20 - value.length} Characters :)';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: ((value) {
                        _description = value!;
                      }),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 20, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Center(
                                  child: Text(
                                    'Enter Image URL!',
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.fill,
                                  ),
                                  //fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (!_checkUrl(value!)) {
                                return 'please enter a valid URl!';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Image URL',
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _addnew
                                    ? DateTime.now().toString()
                                    : _editedProduct.id,
                                title: _title,
                                price: _price,
                                description: _description,
                                imageUrl: value!,
                                isFavorite: _isFavorite,
                              );
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
