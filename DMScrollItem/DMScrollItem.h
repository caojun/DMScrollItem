/**
 The MIT License (MIT)
 
 Copyright (c) 2015 DreamCao
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#import <UIKit/UIKit.h>
#import "DMScrollItemButton.h"

@class DMScrollItem;


#pragma mark -
@protocol DMScrollItemDelegate <NSObject>

@optional
- (void)scrollItem:(DMScrollItem *)scrollItem didSelectIndex:(NSInteger)index;

@end


#pragma mark - DMScrollItem
@interface DMScrollItem : UIView

/**
 *  背景图片
 */
@property (nonatomic, strong) IBInspectable UIImage *backgroundImage;

/**
 *  item 宽度
 */
@property (nonatomic, assign) CGFloat itemWidth;
/**
 *  item title 颜色
 */
@property (nonatomic, strong) UIColor *titleColor;
/**
 *  item title 选中颜色
 */
@property (nonatomic, strong) UIColor *titleSelColor;

/**
 *  item title 显示字体
 */
@property (nonatomic, strong) UIFont *titleFont;
- (void)setTitleColor:(UIColor *)titleColor andTitleSelColor:(UIColor *)titleSelColor;
- (void)setTitleColor:(UIColor *)titleColor andTitleSelColor:(UIColor *)titleSelColor andTitleFont:(UIFont *)titleFont;

/**
 *  底部长方块标识颜色
 */
@property (nonatomic, strong) UIColor *idenColor;

/**
 *  底部长方块宽度
 */
@property (nonatomic, assign) CGFloat idenWidth;
@property (nonatomic, assign) CGFloat idenHeight;
- (void)setIdenColor:(UIColor *)idenColor andIdenWidth:(CGFloat)idenWidth andIdenHeight:(CGFloat)idenHeight;

/**
 *  下面是否显示一条线，默认 YES
 */
@property (nonatomic, assign, getter=isBottomLineHide) BOOL bottomLineHide;

/**
 *  下面显示一条线的高度，默认 1
 */
@property (nonatomic, assign) CGFloat bottomLineHeight;

/**
 *  下面显示一条线的颜色, 默认 black color
 */
@property (nonatomic, strong) UIColor *bottomLineColor;
- (void)setBottomLineHeight:(CGFloat)bottomLineHeight andBottomLineColor:(UIColor *)bottomLineColor;

/**
 *  显示项数量， 默认是4
 */
@property (nonatomic, assign) NSInteger numberItemsOfPerPages;

/**
 *  每一项item 之间间隔宽度
 */
@property (nonatomic, assign) CGFloat itemSpaceWidth;

/**
 *  当前选中的index
 */
@property (nonatomic, assign) NSInteger curSelID;
- (void)setCurSelID:(NSInteger)curSelID isAnimation:(BOOL)isAnimation;

/**
 *  渐变颜色块， default NO
 */
@property (nonatomic, assign, getter=isGraduallyViewHidden) IBInspectable BOOL graduallyViewHidden;
@property (nonatomic, strong) UIColor *graduallyBeginColor;
@property (nonatomic, strong) UIColor *graduallyEndColor;
- (void)setGraduallyBeginColor:(UIColor *)beginColor andEndColor:(UIColor *)endColor;


/**
 *  显示item title字符串数组, 存放字符串
 */
@property (nonatomic, strong) NSArray *titleArray;


@property (nonatomic, weak) IBOutlet id<DMScrollItemDelegate> delegate;


/**
 *  每一页，默认显示项数
 */
+ (NSInteger)defaultNumberItemsOfPerPages;


- (void)setItemIconWithIndex:(NSInteger)index
            andIconDirection:(DMScrollItemIconDirection)direction
                 andIconView:(UIView *)iconView;

- (void)deleteItemIconWithIndex:(NSInteger)index
               andIconDirection:(DMScrollItemIconDirection)direction;


/**
 *  更新当前标识块的X坐标
 *
 *  @param xOffset X坐标偏移
 */
- (void)updateIdentifyViewXOffset:(CGFloat)xOffset;

@end
