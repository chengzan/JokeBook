//
//  JBCommentsFrame.m
//  JokeBook
//
//  Created by shanzy on 15/9/7.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import "JBCommentsFrame.h"
#import "JBComments.h"
#import "NSString+Extension.h"
#import "JBConst.h"

@implementation JBCommentsFrame

- (void)setComments:(JBComments *)comments
{
    _comments=comments;
    
    UIFont *font=[UIFont systemFontOfSize:16];

    CGSize size=[comments.content sizeWithFont:font maxW:CommentCellContentMaxWidth];
    self.contentHeight=size.height;
    self.contentWidth=size.width;
    
    //JBLog(@"comments.content=%@,contentHeight=%f",comments.content,self.contentHeight);
    
    self.cellHeight=CommentCellTopHeight+self.contentHeight+ButtonContentMargin;
}

@end
