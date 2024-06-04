import 'package:ank_app/entity/news_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsItem extends StatelessWidget {
  const NewsItem(this.item, {super.key, required this.type});

  final NewsEntity item;
  final NewsType type;

  @override
  Widget build(BuildContext context) {
    final havePic = item.articlePic?.isNotEmpty == true;
    final haveContent = item.content?.isNotEmpty == true;
    final contentLines = havePic ? 2 : 3;
    final date = DateTime.fromMillisecondsSinceEpoch(item.ts ?? 0);
    final now = DateTime.now();
    late String dateStr;
    if (now.difference(date).inMinutes <= 1) {
      dateStr = '刚刚';
    } else if (now.difference(date).inMinutes <= 60) {
      dateStr = '${now.difference(date).inMinutes}分钟前';
    } else if (now.difference(date).inHours <= 24) {
      dateStr = '${now.difference(date).inHours}小时前';
    } else if (now.difference(date).inDays <= 7) {
      dateStr = '${now.difference(date).inDays}天前';
    } else {
      dateStr = DateFormat('yyyy-MM-dd').format(date);
    }
    Widget titleAndContent = Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.title ?? '',
                style: Styles.tsBody_16m(context),
                maxLines: 2,
              ),
              if (!havePic && haveContent)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                      (item.content ?? '').replaceAll(RegExp('<.*?>'), ''),
                      style: Styles.tsSub_14(context),
                      maxLines: contentLines),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 9),
                child: Row(
                  children: [
                    if (item.sourceWebPic?.isNotEmpty == true)
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: ImageUtil.networkImage(
                          item.sourceWebPic ?? '',
                          width: 15,
                          height: 15,
                        ),
                      ),
                    Expanded(
                      child: Text(
                        item.sourceWeb ?? '',
                        style: Styles.tsSub_12(context),
                      ),
                    ),
                    Text(
                      dateStr,
                      style: Styles.tsSub_12(context),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        if (havePic)
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: ImageUtil.networkImage(item.articlePic!,
                    width: 95, height: 70, fit: BoxFit.cover)),
          ),
      ],
    );
    if (havePic) titleAndContent = IntrinsicHeight(child: titleAndContent);
    return InkWell(
      onTap: () => AppNav.toNewsDetail(id: item.id!, type: type),
      child: Container(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
        child: titleAndContent,
      ),
    );
  }
}
