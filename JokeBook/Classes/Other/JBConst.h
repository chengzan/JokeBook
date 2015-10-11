#import <Foundation/Foundation.h>

#ifdef DEBUG
#define JBLog(format,...) NSLog(@"[%s][%s][%d]" format, __FILE__, __func__, __LINE__, ##__VA_ARGS__)
#else
#define JBLog(...)
#endif

#define JBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define JBGlobalBg JBColor(230, 230, 230)
// 随机色
#define JBRandomColor JBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define JBNotificationCenter [NSNotificationCenter defaultCenter]
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScrollCount 6 // 滚动视图的个数
#define CellMargin 15 // cell子视图之间的间隙
#define UserIconHeight 36 // 用户头像的高度
#define BottomHeight 80 // 底部的高度（包含统计栏和按钮栏）
#define LoadCount 15 // 每次加载糗事的个数
#define TitleScrollWidth 56 // 导航栏顶部titleView的宽度，高度为宽度的一半
#define TopViewHeight 56 // 顶部文字视图的高度
#define NavgationHeight 64 // 导航栏的高度

#define ButtonContentMargin 10 // 按钮内文字与图片的间隙
#define ButtonSpaceMargin 10 // 按钮内容左右的间隙
#define ButtonIconWidth 12 // 按钮内图片的宽度

#define CommentCellContentMaxWidth (ScreenWidth-100)
#define CommentCellTopHeight 46

typedef enum {
    ScrollDirectionTypeUnknow=0,
    ScrollDirectionTypeUp,
    ScrollDirectionTypeDown
}ScrollDirectionType;

// 通知监听
extern NSString * const JBButtonDidSelectNotification;
extern NSString * const JBSelectButtonKey;

extern NSString * const JBTitleDidSelectNotification;
extern NSString * const JBSelectTitleKey;

extern NSString * const JBTableViewScrollNotification;
extern NSString * const JBTableViewScrollKey;

extern NSString * const JBTabBarItemDidSelectNotification;

extern NSString * const JBTableViewScrollDirectionKey;

extern NSString * const JBLoadNewJokesNotification;
extern NSString * const JBLoadNewJokesKey;

// 评论cell里头像被点击的通知
extern NSString * const JBCommentCellIconClickedNotification;
extern NSString * const JBCommentCellIconKey;

// 评论cell里头像被点击的通知
extern NSString * const JBShowReplyViewNotification;
extern NSString * const JBShowReplyViewKey;

// 糗事cell里头像被点击的通知
extern NSString * const JBJokeCellIconClickedNotification;
extern NSString * const JBJokeCellIconKey;

// 糗事comment cell里回复按钮被点击的通知
extern NSString * const JBJokeReplyViewReplyClickedNotification;
extern NSString * const JBJokeReplyViewReplyKey;


// 专享http前缀
extern NSString * const JBSuggestPrefix;
// 最新http前缀
extern NSString * const JBLatestPrefix;
// 精华http前缀
extern NSString * const JBDayPrefix;
// 纯图http前缀
extern NSString * const JBimgrankPrefix;
// 纯文http前缀
extern NSString * const JBtextPrefix;
// 视频http前缀
extern NSString * const JBvideoPrefix;
// 点击用户的糗事
extern NSString *const JBUserArticles;

// 点击cell跳转到评论界面
extern NSString *const JBJokesArticleComment;

extern NSString *const avtNew;
extern NSString *const picturesNew;

// 点击用户头像
extern NSString *const JBUserDetailURL;

/**
 *  糗事百科接口
 *
 专享
 http://m2.qiushibaike.com/article/list/suggest?count=30&page=1
 最新
 http://m2.qiushibaike.com/article/list/latest?count=30&page=1
 精华
 http://m2.qiushibaike.com/article/list/day?count=30&page=1
 纯图
 http://m2.qiushibaike.com/article/list/imgrank?count=30&page=1
 纯文
 http://m2.qiushibaike.com/article/list/text?count=30&page=1
 视频
 http://m2.qiushibaike.com/article/list/video?count=30&page=1
 
 点击每一行的跳转 count最大不能超过100
http://m2.qiushibaike.com/article/112722093/comments?article=1&count=100&page=1
 
 评论
 http://m2.qiushibaike.com/article/112645320/comment/create
 Method:POST
 Content-Type:application/json
 
 Headers:
 {
 "content": "\u7acb\u767d\uff0c\u4e0d\u4f24\u624b\u3002",
 "err": 0,
 "id": 334720955,
 "anonymous": false,
 "user": {
 "last_visited_at": 1438960094,
 "created_at": 1438960094,
 "last_device": "ios_7.1.2",
 "email": "",
 "state": "active",
 "role": "n",
 "login": "shanzy",
 "id": 30048802,
 "icon": ""
 }
 }
 
 TA的糗事
 http://m2.qiushibaike.com/user/24773072/articles?count=30&page=1
 
 点击用户头像
 http://nearby.qiushibaike.com/user/27663950/detail?
 
 点击用户头像 无封面
 http://nearby.qiushibaike.com/user/30183355/detail?AdID=14410136022773556AEEF1
 点击用户头像 有封面
 http://nearby.qiushibaike.com/user/16340941/detail?AdID=14410136395539556AEEF1
 
 这是我的用户id
 http://nearby.qiushibaike.com/user/30048802/detail?AdID=14410137892897556AEEF1
 
 发表内容接口
 http://m2.qiushibaike.com/article/create
 
 Headers:
 {
 "article": {
 "picture_content_type": "NULL",
 "votes": {
 "down": 0,
 "up": 0
 },
 "anonymous": 1,
 "created_at": 1441013913,
 "published_at": 0,
 "content": "\u4e00\u5929\u5b9e\u5728\u662f\u8fc7\u5f97\u98de\u5feb",
 "state": "pending",
 "tag": "",
 "comments_count": 0,
 "user": {
 "login": "shanzy",
 "id": 30048802,
 "avatar": ""
 },
 "image": null,
 "allow_comment": true,
 "id": 112649948
 },
 "err": 0
 }
 
 Content-Type:text/html;charset=UTF-8
 Method:POST
 */