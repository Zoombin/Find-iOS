//
//  FDThemeCell.m
//  find
//
//  Created by zhangbin on 9/6/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDThemeCell.h"
#import "FDThemeItemView.h"

#define kAutoScrollTimeInterval 4.0

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
		//self.backgroundColor = [UIColor randomColor];
		
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
		itemView.theme = items[i];
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
	
	if ([_attributes[kThemeCellAttributeKeyHasSeparateLine] boolValue]) {
		UIView *line = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, 0, self.bounds.size.width, 1)];
		line.backgroundColor = [UIColor fdSeparateLineColor];
		[self addSubview:line];
		
		UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, CGRectGetHeight(_scrollView.bounds) - 1, self.bounds.size.width, 1)];
		bottomLine.backgroundColor = [UIColor fdSeparateLineColor];
		[self addSubview:bottomLine];
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

+ (NSDictionary *)attributesOfSlideStyle
{
	static NSDictionary *attributesOfSlideStyle;
	if (!attributesOfSlideStyle) {
		NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
		CGRect rect = CGRectMake(0, 0, 320, 130);
		attributes[kThemeCellAttributeKeyBounds] = NSStringFromCGRect(rect);
		attributes[kThemeCellAttributeKeyItemWidth] = @(320);
		attributes[kThemeCellAttributeKeyPagingEnabled] = @(YES);
		attributes[kThemeCellAttributeKeyAutoScrollEnabled] = @(YES);
		attributesOfSlideStyle = [NSDictionary dictionaryWithDictionary:attributes];
	}
	return attributesOfSlideStyle;
}

+ (NSDictionary *)attributesOfIconStyle
{
	static NSDictionary *attributesOfIconStyle;
	if (!attributesOfIconStyle) {
		NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
		CGRect rect = CGRectMake(0, 0, 320, 130);
		attributes[kThemeCellAttributeKeyBounds] = NSStringFromCGRect(rect);
		attributes[kThemeCellAttributeKeyItemWidth] = @(95);
		attributes[kThemeCellAttributeKeyShowsHorizontalScrollIndicator] = @(NO);
		attributes[kThemeCellAttributeKeyHeaderTitle] = @"热门城市";//TODO: should implement here
		attributesOfIconStyle = [NSDictionary dictionaryWithDictionary:attributes];
	}
	return attributesOfIconStyle;
}

+ (NSDictionary *)attributesOfBrandStyle
{
	static NSDictionary *attributesOfBrandStyle;
	if (!attributesOfBrandStyle) {
		NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
		CGRect rect = CGRectMake(0, 0, 320, 110);
		attributes[kThemeCellAttributeKeyBounds] = NSStringFromCGRect(rect);
		attributes[kThemeCellAttributeKeyItemWidth] = @(180);
		attributes[kThemeCellAttributeKeyShowsHorizontalScrollIndicator] = @(NO);
		attributes[kThemeCellAttributeKeyHasSeparateLine] = @(YES);
		attributesOfBrandStyle = [NSDictionary dictionaryWithDictionary:attributes];
	}
	return attributesOfBrandStyle;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	CGFloat pageWidth = scrollView.frame.size.width;
	currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}



@end
