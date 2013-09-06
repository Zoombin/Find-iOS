//
//  FDThemeCell.m
//  find
//
//  Created by zhangbin on 9/6/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDThemeCell.h"
#import "FDThemeItemView.h"

#define kAutoScrollTimeInterval 3.0

@interface FDThemeCell () <UIScrollViewDelegate>

@end

@implementation FDThemeCell
{
	NSUInteger currentPage;
	NSUInteger numberOfPages;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
		_scrollView = [[UIScrollView alloc] init];
		_scrollView.backgroundColor = [UIColor clearColor];
		_scrollView.delegate = self;
		[self addSubview:_scrollView];
    }
    return self;
}

- (void)setItems:(NSArray *)items
{
	if (_items == items) return;
	_items = items;
	
	CGFloat itemWidth = [_attributes[kThemeCellAttributeKeyItemWidth] floatValue];
	for (int i = 0; i < items.count; i++) {
		FDThemeItemView *itemView = [[FDThemeItemView alloc] initWithFrame:CGRectMake(itemWidth * i, 0, itemWidth, _scrollView.frame.size.height)];
		[_scrollView addSubview:itemView];
	}
	
	_scrollView.contentSize = CGSizeMake(itemWidth * items.count, self.frame.size.height);
	
	currentPage = 0;
	numberOfPages = items.count;
}

- (void)setAttributes:(NSDictionary *)attributes
{
	if (_attributes == attributes) return;
	_attributes = attributes;
	if (_attributes[kThemeCellAttributeKeyBounds]) {
		_scrollView.frame = CGRectFromString(_attributes[kThemeCellAttributeKeyBounds]);
	}
	
	if (_attributes[kThemeCellAttributeKeyPagingEnabled]) {
		_scrollView.pagingEnabled = [attributes[kThemeCellAttributeKeyPagingEnabled] boolValue];
	}
		
	if (_attributes[kThemeCellAttributeKeyShowsHorizontalScrollIndicator]) {
		_scrollView.showsHorizontalScrollIndicator = [attributes[kThemeCellAttributeKeyShowsHorizontalScrollIndicator] boolValue];
	}
	
	if (_attributes[kThemeCellAttributeKeyAutoScrollEnabled]) {
		[self performSelector:@selector(scrollToNext) withObject:nil afterDelay:kAutoScrollTimeInterval];
	}

	
}

- (void)scrollToNext
{
	currentPage++;
	if (currentPage >= numberOfPages) {
		[_scrollView setContentOffset:CGPointZero animated:NO];
		currentPage = 0;
	} else {
		[_scrollView setContentOffset:CGPointMake(currentPage * _scrollView.frame.size.width, 0) animated:YES];
	}
	[self performSelector:@selector(scrollToNext) withObject:nil afterDelay:3];
}

static NSDictionary *attributesOfSlideADStyle;
+ (NSDictionary *)attributesOfSlideADStyle
{
	if (!attributesOfSlideADStyle) {
		NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
		CGRect rect = CGRectMake(0, 0, 320, 130);
		attributes[kThemeCellAttributeKeyBounds] = NSStringFromCGRect(rect);
		attributes[kThemeCellAttributeKeyItemWidth] = @(320);
		attributes[kThemeCellAttributeKeyPagingEnabled] = @(YES);
		attributes[kThemeCellAttributeKeyAutoScrollEnabled] = @(YES);
		attributesOfSlideADStyle = [NSDictionary dictionaryWithDictionary:attributes];
	}
	return attributesOfSlideADStyle;
}

static NSDictionary *attributesOfIconStyle;
+ (NSDictionary *)attributesOfIconStyle
{
	if (!attributesOfIconStyle) {
		NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
		CGRect rect = CGRectMake(0, 0, 320, 150);
		attributes[kThemeCellAttributeKeyBounds] = NSStringFromCGRect(rect);
		attributes[kThemeCellAttributeKeyItemWidth] = @(95);
		attributes[kThemeCellAttributeKeyShowsHorizontalScrollIndicator] = @(NO);
		attributes[kThemeCellAttributeKeyHeaderTitle] = @"hello";
		attributesOfIconStyle = [NSDictionary dictionaryWithDictionary:attributes];
	}
	return attributesOfIconStyle;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	CGFloat pageWidth = scrollView.frame.size.width;
	currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
