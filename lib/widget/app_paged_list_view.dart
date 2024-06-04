import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class AppPagedListView<PageKeyType, ItemType> extends StatelessWidget {
  final PagingController<PageKeyType, ItemType> pagingController;
  final Widget Function(BuildContext, ItemType, int) itemBuilder;

  const AppPagedListView({
    super.key,
    required this.pagingController,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return PagedListView<PageKeyType, ItemType>(
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate<ItemType>(
        itemBuilder: itemBuilder,
        firstPageErrorIndicatorBuilder: (context) =>
            _FirstPageExceptionIndicator(
          title: S.of(context).pagingErrorHint,
          message: S.of(context).pagingErrorMessage,
          onTryAgain: pagingController.retryLastFailedRequest,
        ),
        noItemsFoundIndicatorBuilder: (context) =>
            const EmptyView(padding: EdgeInsets.only(top: 100)),
        firstPageProgressIndicatorBuilder: (context) => const LottieIndicator(),
        newPageProgressIndicatorBuilder: (context) => const Padding(
            padding: EdgeInsets.only(top: 16, bottom: 16),
            child: Center(child: LottieIndicator())),
        noMoreItemsIndicatorBuilder: (context) => Center(
            child:
                Image.asset(Assets.commonIcEmptyBox, height: 150, width: 150)),
        newPageErrorIndicatorBuilder: (context) => InkWell(
          onTap: pagingController.retryLastFailedRequest,
          child: Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(S.of(context).pagingRetryHint,
                    textAlign: TextAlign.center),
                const SizedBox(height: 4),
                const Icon(Icons.refresh, size: 16)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FirstPageExceptionIndicator extends StatelessWidget {
  const _FirstPageExceptionIndicator({
    required this.title,
    this.message,
    this.onTryAgain,
  });

  final String title;
  final String? message;
  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) {
    final message = this.message;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Column(
          children: [
            Text(title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge),
            if (message != null) const SizedBox(height: 16),
            if (message != null) Text(message, textAlign: TextAlign.center),
            if (onTryAgain != null) const SizedBox(height: 48),
            if (onTryAgain != null)
              SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onTryAgain,
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: Text(S.of(context).tryAgain),
                  )),
          ],
        ),
      ),
    );
  }
}
