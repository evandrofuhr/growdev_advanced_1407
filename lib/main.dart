import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
      home: TodoList(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _list = List<String>.generate(1000, (index) => 'Item $index');

  List<Widget> _children = [
    Container(
      height: 80,
      width: 120,
      color: Colors.teal,
      child: Text('item 1'),
    ),
    Container(
      width: 80,
      color: Colors.red,
      child: Text('item 2'),
    ),
    Container(
      width: 80,
      color: Colors.green,
      child: Text('item 3'),
    ),
    Container(
      width: 120,
      color: Colors.blue,
      child: Text('item 4'),
    ),
    Container(
      width: 120,
      color: Colors.orange,
      child: Text('item 5'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) {
          return ListTile(
            enabled: index % 2 == 0,
            selected: index % 5 == 0,
            contentPadding: EdgeInsets.all(8),
            trailing: Icon(Icons.mail),
            isThreeLine: true,
            onLongPress: () => print('onLongPress'),
            onTap: () => print('onTab'),
            // dense: true,
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://www.gravatar.com/avatar/$index?d=robohash'),
            ),
            title: Text('Titulo do item $index'),
            subtitle: Text(
              'Gravatar images may be requested just like a normal image, using an IMG tag. To get an image specific to a user, you must first calculate their email hash.',
              maxLines: 2,
            ),
          );
        },
      ),
    );
  }

  // ListTile

  ListView _construtorSeparated() {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      itemCount: _list.length,
      itemBuilder: (context, index) {
        var _item = _list[index];

        return Container(
          height: 60,
          color: Colors.primaries
              .elementAt(Random.secure().nextInt(Colors.primaries.length)),
          child: Center(child: Text(_item)),
        );
      },
    );
  }

  ListView _construtorBuilder() {
    return ListView.builder(
      itemCount: _list.length,
      itemBuilder: (context, index) {
        var _item = _list[index];

        return Container(
          height: 60,
          color: Colors.primaries
              .elementAt(Random.secure().nextInt(Colors.primaries.length)),
          child: Center(child: Text(_item)),
        );
      },
    );
  }

  ListView _construtorPadrao() {
    return ListView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      children: _children,
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<String> _todoItens = <String>[];
  List<String> _doneItens = <String>[];
  final _controller = TextEditingController();
  final _focus = FocusNode();
  bool isLoading = false;
  bool isCompletingTask = false;
  bool isReopenTask = false;

  void _add() {
    setState(() => isLoading = true);
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        if (_controller.text?.isNotEmpty ?? false) {
          _todoItens.add(_controller.text);
          _controller.clear();
          _focus.requestFocus();
        }
        isLoading = false;
      });
    });
  }

  void _completeTask(int index) {
    setState(() => isCompletingTask = true);
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _doneItens.add(_todoItens[index]);
        _todoItens.removeAt(index);
        isCompletingTask = false;
      });
    });
  }

  void _reOpenTask(int index) {
    setState(() => isReopenTask = true);
    Future.delayed(
        Duration(
          milliseconds: 300,
        ), () {
      setState(() {
        _todoItens.add(_doneItens[index]);
        _doneItens.removeAt(index);
        isReopenTask = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Todo',
                    ),
                    focusNode: _focus,
                    onSubmitted: (_) => _add(),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _add,
                ),
              ],
            ),
            isLoading ? LinearProgressIndicator() : Container(),
            SizedBox(
              height: 8,
            ),
            Text(
              'Todo',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.start,
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _todoItens.length,
                itemBuilder: (context, index) => ListTile(
                  enabled: !isCompletingTask,
                  leading: Icon(Icons.close),
                  dense: true,
                  title: Text(_todoItens[index]),
                  onTap: () => _completeTask(index),
                ),
              ),
            ),
            isCompletingTask ? LinearProgressIndicator() : Container(),
            SizedBox(
              height: 8,
            ),
            Text(
              'Done',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.start,
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _doneItens.length,
                itemBuilder: (context, index) => ListTile(
                  enabled: !isReopenTask,
                  leading: Icon(Icons.check),
                  dense: true,
                  title: Text(_doneItens[index]),
                  onLongPress: () => _reOpenTask(index),
                ),
              ),
            ),
            isReopenTask ? LinearProgressIndicator() : Container(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }
}
