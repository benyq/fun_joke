import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fun_joke/business/common/joke_item.dart';
import 'package:fun_joke/business/home/search/search_view_model.dart';
import 'package:fun_joke/models/joke_detail_model.dart';
import 'package:fun_joke/utils/widget_util.dart';

const _backgroundColors = [Colors.blueAccent, Colors.purple, Colors.teal];

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  late TextEditingController _searchController;
  late SearchVM _searchVM;

  @override
  void initState() {
    super.initState();
    _searchVM = ref.read(searchVMProvider.notifier);
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var showJokes =
        ref.watch(searchVMProvider.select((value) => value.showJokes));
    var searchHotkey =
        ref.watch(searchVMProvider.select((value) => value.hotKey));
    var searchHistory =
        ref.watch(searchVMProvider.select((value) => value.history));
    var searchJokes =
        ref.watch(searchVMProvider.select((value) => value.jokes));
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          10.hSize,
          Row(
            children: [
              10.wSize,
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    textAlign: TextAlign.left,
                    // 设置文本的水平对齐方式
                    textAlignVertical: TextAlignVertical.center,
                    // 设置文本的垂直对齐方式
                    decoration: const InputDecoration(
                      hintText: '请输入搜索内容',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) {
                      _searchJokes(value);
                    },
                  ),
                ),
              ),
              10.wSize,
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  '取消',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              10.wSize,
            ],
          ),
          10.hSize,
          Expanded(
            child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: showJokes
                ? _searchResultWidget(searchJokes)
                : _searchWidget(searchHotkey, searchHistory),
          ))
        ],
      ),
    );
  }

  Widget _searchWidget(List<String> hotKey, List<String> history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '热搜',
          style: TextStyle(fontSize: 18),
        ),
        10.hSize,
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 10.w,
          children: hotKey
              .map((e) => GestureDetector(
                  onTap: () {
                    _searchJokes(e);
                  },
                  child: _hotKeyItem(e)))
              .toList(),
        ),
        10.hSize,
        Row(
          children: [
            const Text(
              '搜索历史',
              style: TextStyle(fontSize: 18),
            ),
            const Spacer(),
            GestureDetector(
              onTap: history.isEmpty
                  ? null
                  : () {
                      _searchVM.clearSearchHistory();
                    },
              child: Opacity(
                  opacity: history.isNotEmpty ? 1 : 0.5,
                  child: const Icon(Icons.delete_forever)),
            ),
          ],
        ),
        10.hSize,
        Expanded(
            child: ListView.separated(
                separatorBuilder: (context, index) {
                  return 10.hSize;
                },
                itemCount: history.length,
                itemBuilder: (context, index) {
                  var keyword = history[index];
                  return GestureDetector(
                      onTap: () {
                        _searchJokes(keyword);
                      },
                      child: _searchHistoryItem(keyword));
                }))
      ],
    );
  }

  Widget _hotKeyItem(String key) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: _backgroundColors[key.hashCode % _backgroundColors.length],
      ),
      child: Text(
        key,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _searchHistoryItem(String key) {
    return Text(key);
  }

  Widget _searchResultWidget(List<JokeDetailModel> jokes) {
    return ListView.separated(
        separatorBuilder: (context, index) {
          return Container(
            height: 10.w,
            color: Colors.grey.withOpacity(0.2),
          );
        },
        itemCount: jokes.length,
        itemBuilder: (context, index) {
          final joke = jokes[index];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.w),
            child: JokeItemWidget(
              key: ValueKey(joke.joke.jokesId),
              joke: joke,
              likeAction: () {},
              disLikeAction: () {},
              commentAction: () {
              },
              shareAction: () {},
            ),
          );
        });
  }

  void _searchJokes(String keyword) {
    _searchController.text = keyword;
    _searchVM.searchJokes(keyword);
  }
}
