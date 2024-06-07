import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullFurnitureCard extends StatelessWidget {
  final TextEditingController fansController;
  final TextEditingController geyserController;
  final TextEditingController tvController;
  final TextEditingController diningTableController;
  final TextEditingController sofaSetController;
  final TextEditingController interComController;
  final TextEditingController ovenController;
  final TextEditingController wFilterController;
  final TextEditingController wardrobesController;
  final TextEditingController dWasherController;
  final TextEditingController wachineController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  FullFurnitureCard({
    Key? key,
    required this.fansController,
    required this.geyserController,
    required this.tvController,
    required this.diningTableController,
    required this.sofaSetController,
    required this.interComController,
    required this.ovenController,
    required this.wFilterController,
    required this.wardrobesController,
    required this.dWasherController,
    required this.wachineController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Address of Property',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                TextFormField(
                  controller: fansController,
                  decoration: InputDecoration(labelText: 'Village name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Fans Count';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: geyserController,
                  decoration: InputDecoration(labelText: 'Colony name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Geyser Count';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: tvController,
                  decoration: InputDecoration(labelText: 'Tmc name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter TVs Count';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: diningTableController,
                  decoration: InputDecoration(labelText: 'City name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Dining Table';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: sofaSetController,
                  decoration: InputDecoration(labelText: 'District name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter District name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: interComController,
                  decoration: InputDecoration(labelText: 'State name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter State name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: ovenController,
                  decoration: InputDecoration(labelText: 'Pin code'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Pin code';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: wFilterController,
                  decoration: InputDecoration(labelText: 'Pin code'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Pin code';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: wardrobesController,
                  decoration: InputDecoration(labelText: 'Pin code'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Pin code';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: dWasherController,
                  decoration: InputDecoration(labelText: 'Pin code'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Pin code';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: wachineController,
                  decoration: InputDecoration(labelText: 'Pin code'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Pin code';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
