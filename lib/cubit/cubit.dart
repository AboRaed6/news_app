import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_api_app/cubit/states.dart';
import 'package:news_api_app/screens/business_screen.dart';
import 'package:news_api_app/screens/science_screen.dart';
import 'package:news_api_app/screens/settings_screen.dart';
import 'package:news_api_app/screens/sports_screen.dart';
import 'package:news_api_app/shared/cache_helper.dart';

import '../shared/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Business'),
    BottomNavigationBarItem(icon: Icon(Icons.sports), label: 'Sports'),
    BottomNavigationBarItem(icon: Icon(Icons.science), label: 'Science'),
  ];

  List<Widget> screens = [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
  ];
  void changeBottomNavBar(int index) {
    currentIndex = index;
    if (index == 1) {
      getSports();
    }
    if (index == 2) {
      getScience();
    }
    emit(NewsBottomNavState());
  }

  List<dynamic> business = [];
  void getBusiness() {
    emit(NewsGetBusinessLoadingState());
    DioHelper.getData(
      url: 'v2/top-headlines',
      query: {
        'country': 'eg',
        'category': 'business',
        'apiKey': '1ff6f62a3cd740c78420c52322110213'
      },
    ).then((value) {
      // print(value.data['articles'][0]['title']);
      business = value.data['articles'];
      print(business[0]['title']);
      emit(NewsGetBusinessSuccessState());
    }).catchError((err) {
      // print(err.toString());
      emit(NewsGetBusinessErrorState(err.toString()));
    });
  }

  List<dynamic> sports = [];
  void getSports() {
    emit(NewsGetSportsLoadingState());
    if (sports.length == 0) {
      DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country': 'eg',
          'category': 'sports',
          'apiKey': '1ff6f62a3cd740c78420c52322110213'
        },
      ).then((value) {
        // print(value.data['articles'][0]['title']);
        sports = value.data['articles'];
        print(sports[0]['title']);
        emit(NewsGetSportsSuccessState());
      }).catchError((err) {
        // print(err.toString());
        emit(NewsGetSportsErrorState(err.toString()));
      });
    } else {
      emit(NewsGetSportsSuccessState());
    }
  }

  List<dynamic> science = [];
  void getScience() {
    emit(NewsGetScienceLoadingState());
    if (science.length == 0) {
      DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country': 'eg',
          'category': 'science',
          'apiKey': '1ff6f62a3cd740c78420c52322110213'
        },
      ).then((value) {
        // print(value.data['articles'][0]['title']);
        science = value.data['articles'];
        print(science[0]['title']);
        emit(NewsGetScienceSuccessState());
      }).catchError((err) {
        // print(err.toString());
        emit(NewsGetScienceErrorState(err.toString()));
      });
    } else {
      emit(NewsGetScienceSuccessState());
    }
  }

  bool isDark = false;

  void changeAppMode({bool sharedDark}) {
    if (sharedDark != null) {
      isDark = sharedDark;
      emit(NewsChangeModeState());
    } else {
      isDark = !isDark;
      CacheHelper.putData(key: 'isDark', value: isDark).then((value) {
        emit(NewsChangeModeState());
      });
    }
  }

  List<dynamic> search = [];
  void getSearch(String val) {
    emit(NewsGetSearchLoadingState());

    DioHelper.getData(
      url: 'v2/everything',
      query: {'q': '$val', 'apiKey': '1ff6f62a3cd740c78420c52322110213'},
    ).then((value) {
      // print(value.data['articles'][0]['title']);
      search = value.data['articles'];
      print(search[0]['title']);
      emit(NewsGetSearchSuccessState());
    }).catchError((err) {
      // print(err.toString());
      emit(NewsGetSearchErrorState(err.toString()));
    });
  }
}
