import 'package:apilocalstorage/backendlogic/Apilogic.dart';
import 'package:apilocalstorage/backendlogic/Database.dart';
import 'package:flutter/material.dart';

class Homeview extends StatefulWidget {
  const Homeview({super.key});

  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Api to local Storage'),
        centerTitle: true,
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.get_app_rounded),
              onPressed: () async {
                await loadApiData();
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await deleteData();
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : showyourdata(),
    );
  }

  loadApiData() async {
    setState(() {
      isLoading = true;
    });

    var apiget = EmpApiProvider();
    await apiget.getdata();

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  deleteData() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAlldata();

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });
  }

  showyourdata() {
    return FutureBuilder(
      future: DBProvider.db.getAlldata(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(
              color: Colors.black12,
            ),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Text(
                  "${snapshot.data[index].id}",
                  style: const TextStyle(fontSize: 20.0),
                ),
                title: Text("Title: ${snapshot.data[index].title}"),
                subtitle: Text('Body: ${snapshot.data[index].body}'),
              );
            },
          );
        }
      },
    );
  }
}
