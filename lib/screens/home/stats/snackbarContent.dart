/* showSnackBar(
      GlobalKey<ScaffoldState> _key, int status, int saleId, currentIndex) {
    _key.currentState.showSnackBar(SnackBar(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
      duration: Duration(seconds: 30),
      backgroundColor: textSameModeColor,
      content: Container(
        height: status == 2
            ? _salesToShow[currentIndex]['validator'] == null ||
                    _salesToShow[currentIndex]['validator']['id'] != user.id
                ? myHeight(context) * 2.5 / 15
                : myHeight(context) * 3.5 / 15
            : myHeight(context) * 4 / 15,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: greyColor,
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              height: 7.0,
              width: 50.0,
            ),
            SizedBox(
              height: 15.0,
            ),
            status != 0
                ? Container(
                    height: 0.0,
                  )
                : InkWell(
                    onTap: () {
                      _scaffoldKey.currentState.hideCurrentSnackBar();
                      _currentIndex = 0;
                      _changeSaleStatus(1, saleId);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            AmazingIcon.account_circle_line,
                            size: 15.0,
                            color: gradient1,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              'Servir commande',
                              style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  color: textInverseModeColor),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
            status != 1
                ? Container(
                    height: 0.0,
                  )
                : InkWell(
                    onTap: () {
                      _scaffoldKey.currentState.hideCurrentSnackBar();
                      _currentIndex = 0;
                      _changeSaleStatus(2, saleId);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            AmazingIcon.shopping_cart_line,
                            size: 15.0,
                            color: gradient1,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              'Payer commande',
                              style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  color: textInverseModeColor),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
            _salesToShow[currentIndex]['validator'] == null
                ? Container(height: 0.0)
                : InkWell(
                    onTap: () {
                      _scaffoldKey.currentState.hideCurrentSnackBar();
                      showBill(
                          _salesToShow[currentIndex]['customer'],
                          _sites[currentIndex],
                          _salesToShow[currentIndex],
                          _salesToShow[currentIndex]['initiator'],
                          validator: _salesToShow[currentIndex]['validator']);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            AmazingIcon.repeat_2_line,
                            size: 15.0,
                            color: gradient1,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              'Voir la facture',
                              style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  color: textInverseModeColor),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
            userRole['slug'] == 'server' ||
                    _salesToShow[currentIndex]['validator'] != null
                ? Container(
                    height: 0.0,
                  )
                : InkWell(
                    onTap: () {
                      _scaffoldKey.currentState.hideCurrentSnackBar();
                      _currentIndex = 0;
                      _validateSale(saleId);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            AmazingIcon.repeat_2_line,
                            size: 15.0,
                            color: gradient1,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              'Valider Commande',
                              style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  color: textInverseModeColor),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
            _salesToShow[currentIndex]['validator'] == null ||
                    _salesToShow[currentIndex]['validator']['id'] != user.id
                ? Container(
                    height: 0.0,
                  )
                : InkWell(
                    onTap: () {
                      _scaffoldKey.currentState.hideCurrentSnackBar();
                      _currentIndex = 0;
                      _invalidateSale(saleId);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            AmazingIcon.account_circle_line,
                            size: 15.0,
                            color: gradient1,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              'Invalider commande',
                              style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  color: textInverseModeColor),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
            status == 2
                ? Container(
                    height: 0.0,
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          AmazingIcon.edit_2_line,
                          size: 15.0,
                          color: gradient1,
                        ),
                        InkWell(
                          onTap: () async {
                            _scaffoldKey.currentState.hideCurrentSnackBar();
                            if (sitesToShow == null) {
                              setState(() {
                                _isLoading = true;
                              });
                              await fetchProductsOfSnack().then((value) {
                                setState(() {
                                  _isLoading = false;
                                });
                                sitesToShow = _fieldValues(value);
                                updateSales(
                                    _salesToShow[currentIndex],
                                    user.isAdmin == 1
                                        ? sitesToShow
                                        : checkSiteProduct(
                                            sitesToShow,
                                            _salesToShow[currentIndex]
                                                ['site_id']),
                                    _salesToShow[currentIndex]['products']);
                              });
                            } else {
                              updateSales(
                                  _salesToShow[currentIndex],
                                  user.isAdmin == 1
                                      ? sitesToShow
                                      : checkSiteProduct(
                                          sitesToShow,
                                          _salesToShow[currentIndex]
                                              ['site_id']),
                                  _salesToShow[currentIndex]['products']);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              'Modifier',
                              style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  color: textInverseModeColor),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
            InkWell(
              onTap: () {
                _scaffoldKey.currentState.hideCurrentSnackBar();
                /* 
                _deleteSite(index); */
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      AmazingIcon.delete_bin_6_line,
                      size: 15.0,
                      color: redColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Supprimer',
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: textInverseModeColor),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
 */