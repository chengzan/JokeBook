//
//  JBComments.m
//  JokeBook
//
//  Created by shanzy on 15/9/7.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import "JBComments.h"
#import "MJExtension.h"
#import "JBSpecial.h"
#import "JBTextPart.h"
#import "RegexKitLite.h"
#import <UIKit/UIKit.h>

@implementation JBComments
- (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}

- (void)setContent:(NSString *)content
{
    _content=content;
    self.attributedContent = [self attributedCcontentWithContent:content];
}

/**
 *  普通文字 --> 属性文字
 *
 *  @param text 普通文字
 *
 *  @return 属性文字
 */
- (NSAttributedString *)attributedCcontentWithContent:(NSString *)text
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    
    // 楼层的规则
    NSString *floorPattern = @"\\d{1,3}+楼";
    NSString *pattern = [NSString stringWithFormat:@"%@", floorPattern];
    
    // 遍历所有的特殊字符串
    NSMutableArray *parts = [NSMutableArray array];
    [text enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        
        JBTextPart *part = [[JBTextPart alloc] init];
        part.special = YES;
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        [parts addObject:part];
    }];
    // 遍历所有的非特殊字符
    [text enumerateStringsSeparatedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        
        JBTextPart *part = [[JBTextPart alloc] init];
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        [parts addObject:part];
    }];
    
    // 排序
    // 系统是按照从小 -> 大的顺序排列对象
    [parts sortUsingComparator:^NSComparisonResult(JBTextPart *part1, JBTextPart *part2) {
        // NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending
        // 返回NSOrderedSame:两个一样大
        // NSOrderedAscending(升序):part2>part1
        // NSOrderedDescending(降序):part1>part2
        if (part1.range.location > part2.range.location) {
            // part1>part2
            // part1放后面, part2放前面
            return NSOrderedDescending;
        }
        // part1<part2
        // part1放前面, part2放后面
        return NSOrderedAscending;
    }];
    
    UIFont *font = [UIFont systemFontOfSize:16];
    NSMutableArray *specials = [NSMutableArray array];
    // 按顺序拼接每一段文字
    for (JBTextPart *part in parts) {
        // 等会需要拼接的子串
        NSAttributedString *substr = nil;
       if (part.special) { // 非表情的特殊文字
            substr = [[NSAttributedString alloc] initWithString:part.text attributes:@{
                      NSForegroundColorAttributeName : [UIColor orangeColor]}];
            
            // 创建特殊对象
            JBSpecial *s = [[JBSpecial alloc] init];
            s.text = part.text;
            NSUInteger loc = attributedText.length;
            NSUInteger len = part.text.length;
            s.range = NSMakeRange(loc, len);
            [specials addObject:s];
        } else { // 非特殊文字
            substr = [[NSAttributedString alloc] initWithString:part.text];
        }
        [attributedText appendAttributedString:substr];
    }
    
    // 一定要设置字体,保证计算出来的尺寸是正确的
    [attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedText.length)];
    [attributedText addAttribute:@"specials" value:specials range:NSMakeRange(0, 1)];
    
    return attributedText;
}
@end
