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

#import "DMScrollItem.h"
#import "DMGraduallyView.h"


#if DEBUG
#   define DMScrollItemLog(...)  NSLog(__VA_ARGS__)
#else
#   define DMScrollItemLog(...)
#endif

static const CGFloat kDefaultNumberItemsOfPerPages = 4;
/**
 *  小长方块标识高度
 */
static const CGFloat kIdenViewHeight = 2;

static const int kButtonTagBeginID = 100;

@interface DMScrollItem () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *m_idenView;

@property (nonatomic, weak) DMScrollItemButton *m_itemBtnSelected;
@property (nonatomic, strong) NSMutableArray *m_itemBtnArray;
@property (nonatomic, assign) CGFloat m_idenSpaceWidth;


@property (nonatomic, strong) UIScrollView *m_scrollView;
@property (nonatomic, strong) DMGraduallyView *m_leftGraduallyView;
@property (nonatomic, strong) DMGraduallyView *m_rightGraduallyView;

@end



static UIColor *scrollItemDumpColor(UIColor *color)
{
    UIColor *newColor = nil;
    
    CGFloat r=0, g=0, b=0, alpha=0;
    if ([color getRed:&r green:&g blue:&b alpha:&alpha])
    {
        newColor = [UIColor colorWithRed:r green:g blue:b alpha:alpha];
    }
    
    return newColor;
}

#pragma mark -
@implementation DMScrollItem

@synthesize idenWidth = _idenWidth;
@synthesize itemWidth = _itemWidth;
@synthesize titleColor = _titleColor;
@synthesize titleSelColor = _titleSelColor;
@synthesize titleFont = _titleFont;
@synthesize idenColor = _idenColor;
@synthesize bottomLineHeight = _bottomLineHeight;
@synthesize bottomLineColor = _bottomLineColor;
@synthesize graduallyBeginColor = _graduallyBeginColor;
@synthesize graduallyEndColor = _graduallyEndColor;
@synthesize numberItemsOfPerPages = _numberItemsOfPerPages;
@synthesize idenHeight = _idenHeight;

#pragma mark - Life Cycle

- (void)dealloc
{
    DMScrollItemLog(@"%@ dealloc", [self class]);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self defaultSetting];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self defaultSetting];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self graduallyViewAdd];
    [self idenViewAdd];
    [self scrollViewAdd];
    
    [self scrollViewAdjustFrame];
    [self idenViewAdjustFrame];
    [self itemButtonArrayAdjustFrame];
    [self graduallyViewAdjustFrame];
}

- (void)defaultSetting
{
    self.bottomLineHide = YES;
    [self scrollViewCreate];
    [self idenViewCreate];
    [self graduallyViewCreate];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    if (!self.isBottomLineHide)
    {
        CGFloat y = rect.size.height - self.m_idenView.frame.size.height / 2;
        CGContextMoveToPoint(ref, 0, y);
        
        CGContextSetStrokeColorWithColor(ref, self.bottomLineColor.CGColor);
        CGContextSetLineWidth(ref, self.bottomLineHeight);
        CGContextAddLineToPoint(ref, rect.size.width, y);
        
        CGContextStrokePath(ref);//开始画线
    }
}

#pragma mark - Sub Views
#pragma mark graduallyView
- (void)graduallyViewAdd
{
    if (![self.subviews containsObject:self.m_leftGraduallyView])
    {
        [self addSubview:self.m_leftGraduallyView];
    }
    
    if (![self.subviews containsObject:self.m_rightGraduallyView])
    {
        [self addSubview:self.m_rightGraduallyView];
    }
}

- (void)graduallyViewCreate
{
    if (nil == self.m_leftGraduallyView)
    {
        DMGraduallyView *leftView = [[DMGraduallyView alloc] initWithDirection:DMGraduallyLeft];
        self.m_leftGraduallyView = leftView;
        leftView.beginColor = scrollItemDumpColor(self.graduallyBeginColor);
        leftView.endColor = scrollItemDumpColor(self.graduallyEndColor);
    }
    
    if (nil == self.m_rightGraduallyView)
    {
        DMGraduallyView *rightView = [[DMGraduallyView alloc] initWithDirection:DMGraduallyRight];
        self.m_rightGraduallyView = rightView;
        
        rightView.beginColor = scrollItemDumpColor(self.graduallyBeginColor);
        rightView.endColor = scrollItemDumpColor(self.graduallyEndColor);
    }
}

- (void)graduallyViewAdjustFrame
{
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = self.itemWidth/2;
    CGFloat h = self.frame.size.height;
    if (nil != self.m_leftGraduallyView)
    {
        self.m_leftGraduallyView.frame = (CGRect){x, y, w, h};
    }
    
    if (nil != self.m_rightGraduallyView)
    {
        x = self.m_scrollView.frame.size.width - w;
        self.m_rightGraduallyView.frame = (CGRect){x, y, w, h};
    }
}

#pragma mark idenView
- (void)idenViewAdd
{
    if (![self.m_scrollView.subviews containsObject:self.m_idenView])
    {
        [self.m_scrollView addSubview:self.m_idenView];
    }
}

- (void)idenViewCreate
{
    if (nil == self.m_idenView)
    {
        UIView *view = [[UIView alloc] init];
        self.m_idenView = view;
        view.hidden = YES;
        
        view.backgroundColor = self.idenColor;
    }
}

- (void)idenViewAdjustFrame
{
    if (nil != self.m_idenView)
    {
        self.m_idenView.hidden = NO;
        
        if (self.curSelID >= 0)
        {
            CGFloat tempw = (self.itemWidth + self.itemSpaceWidth);
            CGFloat w = self.idenWidth;
            CGFloat h = self.idenHeight;
            CGFloat x = self.itemSpaceWidth + self.curSelID * tempw + self.m_idenSpaceWidth;
            CGFloat y = self.bounds.size.height - h;
            
            CGRect frame = {x, y, w, h};
            self.m_idenView.frame = frame;
            
            [self.m_idenView.superview bringSubviewToFront:self.m_idenView];
            
            [self scrollViewAdjustToMiddle];
        }
        else
        {
            self.m_idenView.frame = CGRectZero;
        }
    }
}

#pragma mark - scrollView
- (void)scrollViewAdjustToMiddle
{
    CGFloat x = self.m_idenView.frame.origin.x;
    CGFloat halfWidth = self.bounds.size.width / 2;
    
    if (x > halfWidth)
    {
        CGFloat itemHalfW = self.itemWidth / 2;
        if (x + itemHalfW + halfWidth > self.m_scrollView.contentSize.width)
        {
            x = self.m_scrollView.contentSize.width - self.bounds.size.width;
        }
        else
        {
            x -= halfWidth - itemHalfW;
        }
    }
    else
    {
        x = 0;
    }
    
    [self.m_scrollView setContentOffset:(CGPoint){x, 0} animated:YES];
}

- (void)scrollViewAdd
{
    if (![self.subviews containsObject:self.m_scrollView])
    {
        [self addSubview:self.m_scrollView];
    }
}

- (void)scrollViewCreate
{
    if (nil == self.m_scrollView)
    {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.delegate = self;
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.bounces = NO;

        self.m_scrollView = scrollView;
        
        scrollView.hidden = YES;
    }
}

- (void)scrollViewAdjustFrame
{
    if (nil != self.m_scrollView)
    {
        self.m_scrollView.hidden = NO;
        
        self.m_scrollView.frame = self.bounds;
    }
}

#pragma mark - Event
/**
 *  更新当前标识块的X坐标
 *
 *  @param xOffset X坐标偏移
 */
- (void)updateIdentifyViewXOffset:(CGFloat)xOffset
{
    if (self.curSelID >= 0)
    {
        CGFloat tempw = (self.itemWidth + self.itemSpaceWidth);
        CGFloat x = self.itemSpaceWidth + self.curSelID * tempw + self.m_idenSpaceWidth;
        
        CGRect frame = self.m_idenView.frame;
        frame.origin.x = x + xOffset;
        self.m_idenView.frame = frame;
        
        [self scrollViewAdjustToMiddle];
    }
}

- (void)itemButtonSelectedHandle:(DMScrollItemButton *)btn isAdjustIdenView:(BOOL)isAdjustIdenView isAnimations:(BOOL)isAnimations
{
    self.m_itemBtnSelected.selected = NO;
    btn.selected = YES;
    self.m_itemBtnSelected = btn;
    
    if (isAdjustIdenView)
    {
        if (isAnimations)
        {
            [UIView animateWithDuration:0.1 animations:^{
                [self idenViewAdjustFrame];
            }];
        }
        else
        {
            [self idenViewAdjustFrame];
        }
    }
}

- (void)itemButtonClick:(DMScrollItemButton *)btn
{
    if (!btn.isSelected)
    {
        [self itemButtonClick:btn isAdjustIdenView:YES isAnimations:YES];
    }
}

- (void)itemButtonClick:(DMScrollItemButton *)btn isAdjustIdenView:(BOOL)isAdjustIdenView isAnimations:(BOOL)isAnimations
{
    //此处必须使用 _curSelID, 如果使用self.curSelID则会出现开始的时候闪一下的问题。
    _curSelID = btn.tag - kButtonTagBeginID;
    
    [self itemButtonSelectedHandle:btn isAdjustIdenView:isAdjustIdenView isAnimations:isAnimations];
    
    if ([self.delegate respondsToSelector:@selector(scrollItem:didSelectIndex:)])
    {
        [self.delegate scrollItem:self didSelectIndex:self.curSelID];
    }
}

#pragma mark - getter / setter
+ (NSInteger)defaultNumberItemsOfPerPages
{
    return kDefaultNumberItemsOfPerPages;
}

- (NSMutableArray *)m_itemBtnArray
{
    if (nil == _m_itemBtnArray)
    {
        _m_itemBtnArray = [NSMutableArray array];
    }
    
    return _m_itemBtnArray;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    if (_backgroundImage != backgroundImage)
    {
        _backgroundImage = backgroundImage;
        
        self.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    }
}

- (CGFloat)itemWidth
{
    if (_itemWidth < 0.0001)
    {
        _itemWidth = (CGFloat)self.bounds.size.width / self.numberItemsOfPerPages;
    }
    
    return _itemWidth;
}

- (void)setItemWidth:(CGFloat)itemWidth
{
    _itemWidth = itemWidth;
    
    [self setNeedsDisplay];
}

- (UIColor *)titleColor
{
    if (nil == _titleColor)
    {
        _titleColor = [UIColor blackColor];
    }
    
    return _titleColor;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    
    [self itemButtonRefresh];
}

- (UIColor *)titleSelColor
{
    if (nil == _titleSelColor)
    {
        _titleSelColor = [UIColor blueColor];
    }
    
    return _titleSelColor;
}

- (void)setTitleSelColor:(UIColor *)titleSelColor
{
    _titleSelColor = titleSelColor;
    
    [self itemButtonRefresh];
}

-(UIFont *)titleFont
{
    if (nil == _titleFont)
    {
        _titleFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    
    return _titleFont;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    
    [self itemButtonRefresh];
}

- (void)setTitleColor:(UIColor *)titleColor andTitleSelColor:(UIColor *)titleSelColor
{
    _titleColor = titleColor;
    _titleSelColor = titleSelColor;
    
    [self itemButtonRefresh];
}

- (void)setTitleColor:(UIColor *)titleColor andTitleSelColor:(UIColor *)titleSelColor andTitleFont:(UIFont *)titleFont
{
    _titleColor = titleColor;
    _titleSelColor = titleSelColor;
    _titleFont = titleFont;
    
    [self itemButtonRefresh];
}

- (UIColor *)idenColor
{
    if (nil == _idenColor)
    {
        _idenColor = [UIColor blackColor];
    }
    
    return _idenColor;
}

- (void)setIdenColor:(UIColor *)idenColor
{
    if (_idenColor != idenColor)
    {
        _idenColor = idenColor;
        
        self.m_idenView.backgroundColor = idenColor;
    }
}

- (CGFloat)idenWidth
{
    if (_idenWidth < 0.0001)
    {
        _idenWidth = self.itemWidth;
    }
    
    return _idenWidth;
}

- (CGFloat)m_idenSpaceWidth
{
    _m_idenSpaceWidth = (self.itemWidth - self.idenWidth) * 0.5;
    
    return _m_idenSpaceWidth;
}

- (void)setIdenWidth:(CGFloat)idenWidth
{
    _idenWidth = idenWidth;
    
    [self setNeedsLayout];
}

- (CGFloat)idenHeight
{
    if (_idenHeight < 0.001)
    {
        _idenHeight = kIdenViewHeight;
    }
    
    return _idenHeight;
}

- (void)setIdenHeight:(CGFloat)idenHeight
{
    _idenHeight = idenHeight;
    
    [self setNeedsLayout];
}

- (void)setIdenColor:(UIColor *)idenColor andIdenWidth:(CGFloat)idenWidth andIdenHeight:(CGFloat)idenHeight
{
    _idenColor = idenColor;
    _idenWidth = idenWidth;
    _idenHeight = idenHeight;
    
    self.m_idenView.backgroundColor = idenColor;
    [self setNeedsLayout];
}

- (void)setBottomLineHide:(BOOL)bottomLineHide
{
    _bottomLineHide = bottomLineHide;
    
    [self setNeedsDisplay];
}

- (CGFloat)bottomLineHeight
{
    if (0 == _bottomLineHeight)
    {
        _bottomLineHeight = 1;
    }
    
    return _bottomLineHeight;
}

- (void)setBottomLineHeight:(CGFloat)bottomLineHeight
{
    _bottomLineHeight = bottomLineHeight;
    
    [self setNeedsDisplay];
}

- (UIColor *)bottomLineColor
{
    if (nil == _bottomLineColor)
    {
        _bottomLineColor = [UIColor blackColor];
    }
    
    return _bottomLineColor;
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor
{
    _bottomLineColor = bottomLineColor;
    
    [self setNeedsDisplay];
}

- (void)setBottomLineHeight:(CGFloat)bottomLineHeight andBottomLineColor:(UIColor *)bottomLineColor
{
    _bottomLineHeight = bottomLineHeight;
    _bottomLineColor = bottomLineColor;
    
    [self setNeedsDisplay];
}

- (NSInteger)numberItemsOfPerPages
{
    if (0 == _numberItemsOfPerPages)
    {
        _numberItemsOfPerPages = [[self class] defaultNumberItemsOfPerPages];
    }
    
    return _numberItemsOfPerPages;
}


- (void)setCurSelID:(NSInteger)curSelID
{
    [self setCurSelID:curSelID isAnimation:YES];
}

- (void)setCurSelID:(NSInteger)curSelID isAnimation:(BOOL)isAnimation
{
    _curSelID = curSelID;
    
    if (curSelID >= 0 && curSelID < self.m_itemBtnArray.count)
    {
        [self itemButtonSelectedHandle:self.m_itemBtnArray[curSelID] isAdjustIdenView:YES isAnimations:isAnimation];
    }
}

- (void)setItemSpaceWidth:(CGFloat)itemSpaceWidth
{
    _itemSpaceWidth = itemSpaceWidth;
    
    [self setNeedsLayout];
}

- (void)itemButtonArrayRemove
{
    for (DMScrollItemButton *btn in self.m_itemBtnArray)
    {
        [btn removeFromSuperview];
    }
}

- (void)itemButtonArrayCreate
{
    //先删除旧的
    [self itemButtonArrayRemove];
    
    for (int i=0; i<self.titleArray.count; i++)
    {
        NSString *title = self.titleArray[i];
        DMScrollItemButton *btn = [self itemButtonCreateWithTitle:title];
        btn.tag = kButtonTagBeginID + i;
        [self.m_scrollView addSubview:btn];
        [self.m_itemBtnArray addObject:btn];
    }
    
    [self itemButtonRefresh];
}

- (void)itemButtonArrayAdjustFrame
{
    CGFloat x = self.itemSpaceWidth;
    CGFloat y = 0;
    CGFloat w = self.itemWidth;
    CGFloat h = self.bounds.size.height;
    CGFloat contentWidth = 0;
    DMScrollItemButton *btn = nil;
    CGFloat temp = 0;
    
    for (int i=0; i<self.m_itemBtnArray.count; i++)
    {
        temp = w + self.itemSpaceWidth;
        btn = self.m_itemBtnArray[i];
        x = self.itemSpaceWidth + i * temp;
        btn.frame = (CGRect){x, y, w, h};
        contentWidth = x + temp;
    }

    self.m_scrollView.contentSize = (CGSize){contentWidth, h};
}

- (DMScrollItemButton *)itemButtonCreateWithTitle:(NSString *)title
{
    DMScrollItemButton *btn = [[DMScrollItemButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor clearColor];
    
    return btn;
}

- (void)itemButtonRefresh
{
    for (DMScrollItemButton *btn in self.m_itemBtnArray)
    {
        btn.titleLabel.font = self.titleFont;
        [btn setTitleColor:self.titleColor forState:UIControlStateNormal];
        [btn setTitleColor:self.titleSelColor forState:UIControlStateHighlighted];
        [btn setTitleColor:self.titleSelColor forState:UIControlStateSelected];
        
        [btn setNeedsLayout];
    }
}

- (void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    
    [self itemButtonArrayCreate];
    
    [self itemButtonClick:[self.m_itemBtnArray firstObject] isAdjustIdenView:NO isAnimations:NO];
}

- (void)deleteItemIconWithIndex:(NSInteger)index
               andIconDirection:(DMScrollItemIconDirection)direction
{
    if (index < self.m_itemBtnArray.count
        && direction < DMScrollItemIconDirectionNum)
    {
        DMScrollItemButton *btn = self.m_itemBtnArray[index];
        
        [btn deleteItemIconWithDirection:direction];
    }
}


- (void)setItemIconWithIndex:(NSInteger)index
            andIconDirection:(DMScrollItemIconDirection)direction
                 andIconView:(UIView *)iconView
{
    if (index < self.m_itemBtnArray.count
        && direction < DMScrollItemIconDirectionNum
        && nil != iconView)
    {
        DMScrollItemButton *btn = self.m_itemBtnArray[index];
        
        [btn setIconViewWithDirection:direction andIconView:iconView];
    }
}

- (void)setGraduallyViewHidden:(BOOL)graduallyViewHidden
{
    _graduallyViewHidden = graduallyViewHidden;
    
    self.m_leftGraduallyView.hidden  = graduallyViewHidden;
    self.m_rightGraduallyView.hidden = graduallyViewHidden;
}

- (UIColor *)graduallyBeginColor
{
    if (nil == _graduallyBeginColor)
    {
        _graduallyBeginColor = [UIColor colorWithWhite:0.2 alpha:0.1];
    }
    
    return _graduallyBeginColor;
}

- (void)setGraduallyBeginColor:(UIColor *)graduallyBeginColor
{
    UIColor *color = graduallyBeginColor;
    
    if (nil != color)
    {
        CGFloat r=0, g=0, b=0, alpha=0;
        if ([graduallyBeginColor getRed:&r green:&g blue:&b alpha:&alpha])
        {
            color = [UIColor colorWithRed:r green:g blue:b alpha:alpha];
        }
    }

    _graduallyBeginColor = color;
    
    self.m_leftGraduallyView.beginColor = color;
    self.m_rightGraduallyView.beginColor = color;
}

- (UIColor *)graduallyEndColor
{
    if (nil == _graduallyEndColor)
    {
        _graduallyEndColor = [UIColor colorWithWhite:0.0 alpha:0];
    }
    
    return _graduallyEndColor;
}

-(void)setGraduallyEndColor:(UIColor *)graduallyEndColor
{
    UIColor *color = graduallyEndColor;
    
    if (nil != color)
    {
        CGFloat r=0, g=0, b=0, alpha=0;
        if ([graduallyEndColor getRed:&r green:&g blue:&b alpha:&alpha])
        {
            color = [UIColor colorWithRed:r green:g blue:b alpha:alpha];
        }
    }
    
    _graduallyEndColor = color;
    
    self.m_leftGraduallyView.endColor = color;
    self.m_rightGraduallyView.endColor = color;
}

- (void)setGraduallyBeginColor:(UIColor *)beginColor andEndColor:(UIColor *)endColor
{
    _graduallyBeginColor = beginColor;
    _graduallyEndColor = endColor;
    
    self.graduallyBeginColor = beginColor;
    self.graduallyEndColor = endColor;
}

@end
