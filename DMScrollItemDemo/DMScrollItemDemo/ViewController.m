//
//  ViewController.m
//  DMScrollItemDemo
//
//  Created by Dream on 15/6/21.
//  Copyright (c) 2015年 GoSing. All rights reserved.
//

#import "ViewController.h"
#import "DMScrollItem.h"

@interface ViewController () <UIScrollViewDelegate, DMScrollItemDelegate>
@property (weak, nonatomic) IBOutlet DMScrollItem *m_scrollItem;
@property (nonatomic, weak) UIScrollView *m_scrollView;
@property (nonatomic, strong) NSArray *m_topTitleArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    self.m_topTitleArray = @[@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k"];
    self.m_scrollItem.titleArray = self.m_topTitleArray;
    self.m_scrollItem.bottomLineHide = NO;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"99+";
    label.font = [UIFont systemFontOfSize:12];
    label.backgroundColor = [UIColor orangeColor];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 4;
    [label sizeToFit];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.m_scrollItem setItemIconWithIndex:0 andIconDirection:DMScrollItemIconDirectionLeftTop andIconView:label];
    
    [self scrollViewCreate];
}

- (void)scrollViewCreate
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    if (nil == self.m_scrollView)
    {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 90, width, height-90)];
        scrollView.delegate = self;
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        
        [self.view addSubview:scrollView];
        self.m_scrollView = scrollView;
        
        for (int i=0; i<self.m_topTitleArray.count; i++)
        {
            CGFloat x = i * width;
            CGFloat y = 0;
            CGFloat w = width;
            CGFloat h = height - y;
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
            
            [scrollView addSubview:view];
            
            CGFloat red = arc4random() % 100 / 100.0;
            CGFloat blue = arc4random() % 100 / 100.0;
            CGFloat green = arc4random() % 100 / 100.0;
            
            view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
        }
        
        scrollView.contentSize = CGSizeMake(self.m_topTitleArray.count * width, 0);
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat startX = self.m_scrollItem.curSelID * self.m_scrollView.frame.size.width;
    CGFloat xOffset = self.m_scrollView.contentOffset.x - startX;
    CGFloat width = self.m_scrollItem.itemWidth;
    CGFloat temp = xOffset * width / self.m_scrollView.frame.size.width;
    
    [self.m_scrollItem updateIdentifyViewXOffset:temp];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if (scrollView == self.m_scrollView)
    {
        int selID = self.m_scrollView.contentOffset.x / self.m_scrollView.frame.size.width;
        [self.m_scrollItem setCurSelID:selID isAnimation:NO];
    }
}


#pragma mark - DMScrollItemDelegate
- (void)scrollItem:(DMScrollItem *)scrollItem didSelectIndex:(NSInteger)index
{
    [self.m_scrollView setContentOffset:CGPointMake(index * self.m_scrollView.bounds.size.width, 0) animated:YES];
}


@end
