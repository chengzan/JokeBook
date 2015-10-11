#import <Foundation/Foundation.h>

// 通知
// 按钮选中的通知
NSString * const JBButtonDidSelectNotification = @"JBButtonDidSelectNotification";
NSString * const JBSelectButtonKey=@"JBSelectButtonKey";
// table滚动的通知
NSString * const JBTableViewScrollNotification = @"JBTableViewScrollNotification";
NSString * const JBTableViewScrollKey=@"JBTableViewScrollKey";
// 标题改变的通知
NSString * const JBTitleDidSelectNotification=@"JBTitleDidSelectNotification";
NSString * const JBSelectTitleKey=@"JBSelectTitleKey";
// scroll滚动的方向key
NSString * const JBTableViewScrollDirectionKey=@"JBTableViewScrollDirectionKey";

// 第一个tabBar被点击的通知
NSString * const JBTabBarItemDidSelectNotification=@"JBTabBarItemDidSelectNotification";

// 加载更多糗事的通知
NSString * const JBLoadNewJokesNotification=@"JBLoadNewJokesNotification";
NSString * const JBLoadNewJokesKey=@"JBLoadNewJokesKey";

// 评论cell里头像被点击的通知
NSString * const JBCommentCellIconClickedNotification=@"JBCommentCellIconClickedNotification";
NSString * const JBCommentCellIconKey=@"JBCommentCellIconKey";

// 糗事cell里头像被点击的通知
NSString * const JBJokeCellIconClickedNotification=@"JBJokeCellIconClickedNotification";
NSString * const JBJokeCellIconKey=@"JBJokeCellIconKey";

// 评论cell里头像被点击的通知
NSString * const JBShowReplyViewNotification=@"JBShowReplyViewNotification";
NSString * const JBShowReplyViewKey=@"JBShowReplyViewKey";

// 糗事comment cell里回复按钮被点击的通知
NSString * const JBJokeReplyViewReplyClickedNotification=@"JBJokeReplyViewReplyClickedNotification";
NSString * const JBJokeReplyViewReplyKey=@"JBJokeReplyViewReplyKey";

// 专享http前缀
NSString * const JBSuggestPrefix=@"http://m2.qiushibaike.com/article/list/suggest?";
// 最新http前缀
NSString * const JBLatestPrefix=@"http://m2.qiushibaike.com/article/list/latest?";
// 精华http前缀
NSString * const JBDayPrefix=@"http://m2.qiushibaike.com/article/list/day?";
// 纯图http前缀
NSString * const JBimgrankPrefix=@"http://m2.qiushibaike.com/article/list/imgrank?";
// 纯文http前缀
NSString * const JBtextPrefix=@"http://m2.qiushibaike.com/article/list/text?";
// 视频http前缀
NSString * const JBvideoPrefix=@"http://m2.qiushibaike.com/article/list/video?";

NSString *const avtNew=@"http://pic.qiushibaike.com/system/avtnew/%@/%@/medium/%@";
NSString *const picturesNew=@"http://pic.qiushibaike.com/system/pictures/%@/%@/medium/%@";

// 点击用户头像
NSString *const JBUserDetailURL=@"http://nearby.qiushibaike.com/user/%@/detail?";

// 点击用户的糗事
NSString *const JBUserArticles=@"http://m2.qiushibaike.com/user/%@/articles?";

// 点击cell跳转到评论界面
NSString *const JBJokesArticleComment=@"http://m2.qiushibaike.com/article/%@/comments?article=1&";