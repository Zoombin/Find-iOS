//
//  FDThemeCell.m
//  find
//
//  Created by zhangbin on 9/6/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDThemeCell.h"
#import "FDThemeItemView.h"

NSString *kThemeCellAttributeKeyBounds = @"kThemeCellAttributeKeyBounds";
NSString *kThemeCellAttributeKeyItemWidth = @"kThemeCellAttributeKeyItemWidth";
NSString *kThemeCellAttributeKeyPagingEnabled = @"kThemeCellAttributeKeyPagingEnabled";
NSString *kThemeCellAttributeKeyShowsHorizontalScrollIndicator = @"kThemeCellAttributeKeyShowsHorizontalScrollIndicator";
NSString *kThemeCellAttributeKeyAutoScrollEnabled = @"kThemeCellAttributeKeyAutoScrollEnabled";
NSString *kThemeCellAttributeKeyHeaderTitle = @"kThemeCellAttributeKeyHeaderTitle";
NSString *kThemeCellAttributeKeyHasSeparateLine = @"kThemeCellAttributeKeyHasSeparateLine";

#define kAutoScrollTimeInterval 4.0

@interface FDThemeCell () <UIScrollViewDelegate, FDThemeItemViewDelegate>

@property (readwrite) NSUInteger currentPage;
@property (readwrite) NSUInteger numberOfPages;
@property (readwrite) BOOL autoScroll;

@end

@implementation FDThemeCell

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

- (void)setThemeSection:(FDThemeSection *)themeSection
{
	if (_themeSection == themeSection) return;
	_themeSection = themeSection;
	
	CGFloat itemWidth = [_attributes[kThemeCellAttributeKeyItemWidth] floatValue];
	for (int i = 0; i < _themeSection.themes.count; i++) {
		FDThemeItemView *itemView = [[FDThemeItemView alloc] initWithFrame:CGRectMake(itemWidth * i, 0, itemWidth, _scrollView.frame.size.height)];
		itemView.theme = _themeSection.themes[i];
		itemView.delegate = self;
		[_scrollView addSubview:itemView];
	}
	
	_scrollView.contentOffset = CGPointMake(0, 0);
	_scrollView.contentSize = CGSizeMake(itemWidth * _themeSection.themes.count, self.frame.size.height);

	_currentPage = 0;
	_numberOfPages = _themeSection.themes.count;
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
		_autoScroll = YES;
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
	if (!_autoScroll) return;
	_currentPage++;
	if (_currentPage >= _numberOfPages) {
		[_scrollView setContentOffset:CGPointZero animated:NO];
		_currentPage = 0;
	} else {
		[_scrollView setContentOffset:CGPointMake(_currentPage * _scrollView.frame.size.width, 0) animated:YES];
	}
	[self performSelector:@selector(scrollToNext) withObject:nil afterDelay:3];
}

- (void)prepareForReuse
{
	;//do nothing, no reuse themecell for remember scroll position
//	[super prepareForReuse];
//	_themeSection = nil;
//	_attributes = nil;
//	for (UIView *subView in _scrollView.subviews) {
//		[subView removeFromSuperview];
//	}
//	_autoScroll = NO;
//	_scrollView.showsHorizontalScrollIndicator = YES;
//	_scrollView.contentOffset = CGPointMake(0, 0);
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

+ (NSDictionary *)attributesOfStyle:(NSString *)themeStyle
{
	if ([themeStyle isEqualToString:kThemeStyleIdentifierSlide]) {
		return [self attributesOfSlideStyle];
	} else if ([themeStyle isEqualToString:kThemeStyleIdentifierIcon]) {
		return [self attributesOfIconStyle];
	} else if ([themeStyle isEqualToString:kThemeStyleIdentifierBrand]) {
		return [self attributesOfBrandStyle];
	}
	return nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	CGFloat pageWidth = scrollView.frame.size.width;
	_currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

#pragma mark - FDThemeItemViewDelegate

- (void)didSelectTheme:(FDTheme *)theme
{
	[_delegate didSelectTheme:theme inThemeSection:_themeSection];
}



@end
