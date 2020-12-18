import 'package:flutter/material.dart';
import 'package:nbaplayers/models/team.dart';
import 'package:nbaplayers/services/nba_api.dart';
import 'package:nbaplayers/utils/styles.dart';
import 'package:nbaplayers/utils/widgets.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Teams teams = new Teams();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.white,
          pinned: true,
          elevation: 0,
          expandedHeight: 100,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add_circle),
              onPressed: () {},
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(left: 20),
            title: Text("NBA Team", style: titleStyle),
          ),
        ),
        SliverFillRemaining(
            child: FutureBuilder<Teams>(
                future: NbaAPI.getAllPlayers(teams),
                builder: (context, snapshots) {
                  if (snapshots.hasError) return Text("Error Occurred");
                  switch (snapshots.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      if (!snapshots.hasData ||
                          snapshots.data == null ||
                          snapshots.data.isEmpty()) {
                        return Center(
                          child: Text(
                            "No data",
                          ),
                        );
                      } else {
                        return NbaData(snapshots.data);
                      }
                  }
                })),
      ])),
    );
  }
}

class NbaData extends StatefulWidget {
  final Teams teams;
  NbaData(this.teams);
  @override
  _NbaDataState createState() => _NbaDataState(this.teams);
}

class _NbaDataState extends State<NbaData> {
  Teams teams;
  _NbaDataState(this.teams);
  ScrollController _scrollController = new ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _getMoreData() async {
    if (!teams.isLoading) {
      setState(() {
        teams.isLoading = true;
      });

      NbaAPI.getAllPlayers(teams).then((onValue) {
        setState(() {
          teams.isLoading = false;
          teams = onValue;
        });
      });
    }
  }

  @override
  void initState() {
    this._getMoreData();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        setState(() {
          _getMoreData();
        });
      }
      if (_scrollController.offset <=
              _scrollController.position.minScrollExtent &&
          !_scrollController.position.outOfRange) {
        setState(() {});
      }
    });
  }

  Widget _buildProgressIndicator(bool isLoading) {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(backgroundColor: Colors.grey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildList();
  }

  Widget _buildList() {
    return ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: teams.listOfTeams.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == teams.listOfTeams.length) {
            return _buildProgressIndicator(teams.isLoading);
          } else {
            return Container(
                child: buildCard(context, teams.listOfTeams[index]));
          }
        });
  }
}
