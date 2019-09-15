import 'package:flutter/material.dart';
import 'dart:async';
import 'package:vtb_hackaton/data/balance.dart';
import 'package:vtb_hackaton/data/transactions.dart';

class TransactionsScreen extends StatefulWidget {
  TransactionsScreen({this.title});

  final String title;

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  int shouldUpdateBalance = 0;
  int shouldUpdateTransactions = 0;
  int refresh = 0;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    getBalance();
    getTransactions();
  }

  Future<void> getBalance() async {
    await Balance.instance.get();
    setState(() {
      shouldUpdateBalance++;
    });
  }

  Future<void> getTransactions() async {
    await Transactions.instance.get();
    setState(() {
      shouldUpdateTransactions++;
    });
  }

  Future<Null> _refresh() async {
    getBalance();
    getTransactions();

    return await Future<Null>.value(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: _buildBalanceAndTransactions(),
      ),
    );
  }

  Widget _buildBalanceAndTransactions() {
    List<Transaction> transactions = Transactions.instance.transactions;

    return RefreshIndicator(
      onRefresh: _refresh,
      child: Column(
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: shouldUpdateBalance == 0
                      ? Center(child: CircularProgressIndicator())
                      : Text(
                          "Баланс: ${Balance.instance.balance} руб.",
                          style: TextStyle(fontSize: 24.0),
                        ),
                ),
              ),
            ),
          ),
          Expanded(
            child: shouldUpdateTransactions == 0 && transactions.length == 0
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (BuildContext content, int index) {
                      Transaction trx = transactions[index];

                      return Container(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Тип: ${trx.txTypeToString()}',
                                      style: TextStyle(fontSize: 16.0)),
                                  Text('Сумма: ${trx.amount} руб.',
                                      style: TextStyle(fontSize: 16.0)),
                                  Text('Описание: ${trx.payload}',
                                      style: TextStyle(fontSize: 16.0)),
                                  Text('Статус: ${trx.statusToString()}',
                                      style: TextStyle(fontSize: 16.0)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
          ),
        ],
      ),
    );
  }
}
