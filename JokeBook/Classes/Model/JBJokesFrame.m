//
//  JBJokesFrame.m
//  JokeBook
//
//  Created by shanzy on 15/9/3.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import "JBJokesFrame.h"
#import "JBConst.h"
#import "JBJokes.h"
#import "NSString+Extension.h"
#import "JBImageSize.h"

@implementation JBJokesFrame

- (void)setJokes:(JBJokes *)jokes
{
    _jokes=jokes;
    //JBLog(@"jokes=%@",jokes);
    
    CGFloat cellHeight=0,contentTextHeight=0;
    
    CGFloat contentWidth=ScreenWidth-2*CellMargin;
    contentTextHeight=[jokes.content sizeWithFont:[UIFont systemFontOfSize:16] maxW:contentWidth].height;
    
    self.textHeight=contentTextHeight;
    cellHeight += CellMargin+UserIconHeight+CellMargin;
    if (contentTextHeight) {
      cellHeight += contentTextHeight+CellMargin;
    }
    
    self.imageHeight=0;
    
    if (jokes.loop.length) {
        NSNumber *widthNumber=jokes.pic_size[0];
        NSNumber *heightNumber=jokes.pic_size[1];
        CGFloat width=[widthNumber floatValue];
        CGFloat height=[heightNumber floatValue];
        self.imageHeight=height/width*contentWidth;
        self.imageHeight=height;
        cellHeight += self.imageHeight+CellMargin;
    }
    
    if (jokes.image.length) {
        JBImageSize *size=jokes.image_size;
        NSNumber *widthNumber=size.m[0];
        NSNumber *heightNumber=size.m[1];
        CGFloat width=[widthNumber floatValue];
        CGFloat height=[heightNumber floatValue];
        self.imageHeight=height/width*contentWidth;
        self.imageHeight=height;
        cellHeight += self.imageHeight+CellMargin;
    }
    
    cellHeight += BottomHeight;
    self.cellHeight=cellHeight;
}



@end
