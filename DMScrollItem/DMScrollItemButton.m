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

#import "DMScrollItemButton.h"

#if DEBUG
#   define DMScrollItemLog(...)  NSLog(__VA_ARGS__)
#else
#   define DMScrollItemLog(...)
#endif

static const CGFloat kDMSIBIconViewAdjustHeight = 6.0f;

@interface DMScrollItemButton ()

@property (nonatomic, strong) NSMutableArray *m_iconViewArray;

@end

@implementation DMScrollItemButton

+ (id)buttonWithType:(UIButtonType)buttonType
{
    return [super buttonWithType:UIButtonTypeCustom];
}

- (void)dealloc
{
    DMScrollItemLog(@"%@ dealloc", [self class]);
}

- (NSMutableArray *)m_iconViewArray
{
    if (nil == _m_iconViewArray)
    {
        _m_iconViewArray = [NSMutableArray array];
        
        for (int i=0; i<DMScrollItemIconDirectionNum; i++)
        {
            [_m_iconViewArray addObject:[NSNull null]];
        }
    }
    
    return _m_iconViewArray;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self iconViewAdjustFrame];
}


- (CGSize)stringCalcTextDisplaySizeWithString:(NSString *)string width:(CGFloat)width font:(UIFont *)font
{
    CGSize size = CGSizeZero;
    
    CGSize temp = CGSizeMake(width, 2000);
    NSStringDrawingOptions opt = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *dic = @{NSFontAttributeName: font};
    
    size = [string boundingRectWithSize:temp options:opt attributes:dic context:nil].size;
    
    return size;
}

- (CGSize)titleStringSize
{
    NSString *title = [self titleForState:UIControlStateNormal];
    UIFont *font = self.titleLabel.font;
    
    return [self stringCalcTextDisplaySizeWithString:title width:self.frame.size.width font:font];
}

- (void)iconViewAdjustFrame
{
    CGFloat iconViewX = 0;
    CGFloat iconViewY = 0;
    CGSize iconViewSize = CGSizeZero;
    CGSize titleSize = [self titleStringSize];
    CGFloat titleX = (self.frame.size.width - titleSize.width) * 0.5;
    CGFloat titleY = (self.frame.size.height - titleSize.height) * 0.5;
    
    for (int i=0; i<self.m_iconViewArray.count; i++)
    {
        id obj = self.m_iconViewArray[i];
        if (![obj isKindOfClass:[NSNull class]])
        {
            UIView *iconView = obj;
            
            iconViewSize = iconView.frame.size;
            
            switch (i)
            {
                case DMScrollItemIconDirectionLeftTop:
                    iconViewX = titleX - iconViewSize.width;
                    iconViewY = titleY - iconViewSize.height + kDMSIBIconViewAdjustHeight;
                    break;
                    
                case DMScrollItemIconDirectionLeftBottom:
                    iconViewX = titleX - iconViewSize.width;
                    iconViewY = titleY + titleSize.height - kDMSIBIconViewAdjustHeight;
                    break;
                    
                case DMScrollItemIconDirectionRightTop:
                    iconViewX = titleX + titleSize.width;
                    iconViewY = titleY - iconViewSize.height + kDMSIBIconViewAdjustHeight;
                    break;
                    
                case DMScrollItemIconDirectionRightBottom:
                    iconViewX = titleX + titleSize.width;
                    iconViewY = titleY + titleSize.height - kDMSIBIconViewAdjustHeight;
                    break;
            }
            
            iconView.frame = (CGRect){iconViewX, iconViewY, iconViewSize};
        }
    }
}

- (void)deleteItemIconWithDirection:(DMScrollItemIconDirection)direction
{
    if (direction < DMScrollItemIconDirectionNum)
    {
        id obj = self.m_iconViewArray[direction];
        
        if (![obj isKindOfClass:[NSNull class]])
        {
            [obj removeFromSuperview];
            
            [self.m_iconViewArray replaceObjectAtIndex:direction withObject:[NSNull null]];
            
            [self setNeedsLayout];
        }
    }
}

- (void)setIconViewWithDirection:(DMScrollItemIconDirection)direction
                     andIconView:(UIView *)iconView
{
    if (direction < DMScrollItemIconDirectionNum
        && nil != iconView)
    {
        [self addSubview:iconView];
        
        id obj = self.m_iconViewArray[direction];
        [self.m_iconViewArray replaceObjectAtIndex:direction withObject:iconView];
        
        if (![obj isKindOfClass:[NSNull class]])
        {
            [obj removeFromSuperview];
        }
        
        [self setNeedsLayout];
    }
}

@end
