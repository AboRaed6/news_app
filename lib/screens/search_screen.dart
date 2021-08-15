import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_api_app/cubit/cubit.dart';
import 'package:news_api_app/cubit/states.dart';
import 'package:news_api_app/widgets/components.dart';

class SearchScreen extends StatelessWidget {
  var searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var list = NewsCubit.get(context).search;
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: defaultFormField(
                    editController: searchController,
                    type: TextInputType.text,
                    validate: (String val) {
                      if (val.isEmpty) {
                        return 'search must be not Empty';
                      }
                    },
                    onChange: (val) {
                      NewsCubit.get(context).getSearch(val);
                    },
                    label: 'Search',
                    prefix: Icons.search),
              ),
              Expanded(child: articleBuilder(list, context, isSearch: true)),
            ],
          ),
        );
      },
    );
  }
}
