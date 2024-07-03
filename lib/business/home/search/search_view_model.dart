import 'package:fun_joke/app_providers/api_provider.dart';
import 'package:fun_joke/business/home/search/serach_state.dart';
import 'package:fun_joke/common/paging_widget/page_data_widget.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'search_view_model.g.dart';

@riverpod
class SearchVM extends _$SearchVM with PageLogic {

  @override
  SearchState build() {
    getHotKey();
    getSearchHistory();
    return const SearchState();
  }

  void searchJokes(String keyword) async {
    _onSearchStart(keyword);
    final api = await ref.read(apiProvider);
    sendRefreshPagingRequest(()=> api.searchJoke(keyword, page), (data) {
      state = state.copyWith(keyword: keyword, jokes: data);
    }, failCallback: () {}, emptyCallback: () {});
  }

  void _onSearchStart(String keyword) {
    if (keyword.isNotEmpty) {
      saveSearchHistory(keyword);
      state = state.copyWith(keyword: keyword, jokes: [], showJokes: true);
    }
  }

  void getHotKey() async {
    final api = await ref.read(apiProvider);
    var res = await api.getHotKey();
    List<String> hotKeys = [];
    if (res.isSuccess) {
      hotKeys = res.data!;
    }
    state = state.copyWith(hotKey: hotKeys);
  }

  void getSearchHistory() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var history = sharedPreferences.getStringList('search_history') ?? [];
    state = state.copyWith(history: history);
  }

  void saveSearchHistory(String keyword) async {
    var oldHistory = state.history.toList();
    if (oldHistory.contains(keyword)) {
      oldHistory.remove(keyword);
    }
    oldHistory.insert(0, keyword);
    if (oldHistory.length > 10) {
      oldHistory = oldHistory.sublist(0, 10);
    }
    state = state.copyWith(history: oldHistory);
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList('search_history', oldHistory);
  }

  void clearSearchHistory() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('search_history');
    state = state.copyWith(history: []);
  }
}
