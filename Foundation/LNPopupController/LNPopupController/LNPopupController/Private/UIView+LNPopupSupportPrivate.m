//
//  UIView+LNPopupSupportPrivate.m
//  LNPopupController
//
//  Created by Léo Natan on 2020-08-01.
//  Copyright © 2015-2024 Léo Natan. All rights reserved.
//

#import "UIView+LNPopupSupportPrivate.h"
#import "UIViewController+LNPopupSupportPrivate.h"
#import "LNPopupController.h"
#import "_LNPopupSwizzlingUtils.h"
#import "LNPopupBar+Private.h"
#import "_LNPopupUIBarAppearanceProxy.h"
#import "_LNWeakRef.h"
@import ObjectiveC;
#if TARGET_OS_MACCATALYST
@import AppKit;
#endif

static const void* LNPopupAttachedPopupController = &LNPopupAttachedPopupController;
static const void* LNPopupAwaitingViewInWindowHierarchyKey = &LNPopupAwaitingViewInWindowHierarchyKey;
static const void* LNPopupNotifyingKey = &LNPopupNotifyingKey;
static const void* LNPopupTabBarProgressKey = &LNPopupTabBarProgressKey;
static const void* LNPopupBarBackgroundViewForceAnimatedKey = &LNPopupBarBackgroundViewForceAnimatedKey;

#if ! LNPopupControllerEnforceStrictClean
//groupName
static NSString* _gN = @"Z3JvdXBOYW1l";
//_UINavigationBarVisualProvider
static NSString* _UINBVP = @"X1VJTmF2aWdhdGlvbkJhclZpc3VhbFByb3ZpZGVy";
//_UINavigationBarVisualProviderLegacyIOS
static NSString* _UINBVPLI = @"X1VJTmF2aWdhdGlvbkJhclZpc3VhbFByb3ZpZGVyTGVnYWN5SU9T";
//_UINavigationBarVisualProviderModernIOS
static NSString* _UINBVPMI = @"X1VJTmF2aWdhdGlvbkJhclZpc3VhbFByb3ZpZGVyTW9kZXJuSU9T";
//updateBackgroundGroupName
static NSString* _uBGN = @"dXBkYXRlQmFja2dyb3VuZEdyb3VwTmFtZQ==";
//_viewControllerForAncestor
static NSString* _vCFA = @"X3ZpZXdDb250cm9sbGVyRm9yQW5jZXN0b3I=";
//_didMoveFromWindow:toWindow:
static NSString* _dMFWtW = @"X2RpZE1vdmVGcm9tV2luZG93OnRvV2luZG93Og==";
//_backdropViewLayerGroupName
static NSString* _bVLGN = @"X2JhY2tkcm9wVmlld0xheWVyR3JvdXBOYW1l";
//hostWindow
static NSString* _hW = @"aG9zdFdpbmRvdw==";
//attachedWindow
static NSString* _aW = @"YXR0YWNoZWRXaW5kb3c=";
//currentEvent
static NSString* _cE = @"Y3VycmVudEV2ZW50";
//backgroundTransitionProgress
static NSString* _bTP = @"YmFja2dyb3VuZFRyYW5zaXRpb25Qcm9ncmVzcw==";
//_UIBarBackground
static NSString* _UBB = @"X1VJQmFyQmFja2dyb3VuZA==";
//transitionBackgroundViewsAnimated:
static NSString* _tBVA = @"dHJhbnNpdGlvbkJhY2tncm91bmRWaWV3c0FuaW1hdGVkOg==";
//_backgroundView
static NSString* _bV = @"X2JhY2tncm91bmRWaWV3";
//_registeredScrollToTopViews
static NSString* _rSTTV = @"X3JlZ2lzdGVyZWRTY3JvbGxUb1RvcFZpZXdz";
//_safeAreaInsetsFrozen
static NSString* _sAIF = @"X3NhZmVBcmVhSW5zZXRzRnJvemVu";

#endif

@interface __LNPopupUIViewFrozenInsets : NSObject @end
@implementation __LNPopupUIViewFrozenInsets

+ (void)load
{
	@autoreleasepool 
	{
		const char* encoding = method_getTypeEncoding(class_getInstanceMethod(UIView.class, @selector(needsUpdateConstraints)));
		//_safeAreaInsetsFrozen
		class_addMethod(self, NSSelectorFromString(_LNPopupDecodeBase64String(_sAIF)), imp_implementationWithBlock(^ (id self, SEL _cmd) {
			return YES;
		}), encoding);
	}
}

//- (BOOL)_safeAreaInsetsFrozen
//{
//	return YES;
//}

@end

@interface UIViewController ()

- (void)_ln_popup_viewDidMoveToWindow;

@end

@implementation NSObject (LNPopupSupportPrivate)

- (LNPopupController *)_ln_attachedPopupController
{
	_LNWeakRef* rv = objc_getAssociatedObject(self, LNPopupAttachedPopupController);
	if(rv != nil && rv.object == nil)
	{
		[self _ln_setAttachedPopupController:nil];
	}
	return rv.object;
}

-(void)_ln_setAttachedPopupController:(LNPopupController *)attachedPopupController
{
	id objToSet = nil;
	if(attachedPopupController != nil)
	{
		objToSet = [_LNWeakRef refWithObject:attachedPopupController];
	}
	objc_setAssociatedObject(self, LNPopupAttachedPopupController, objToSet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	
	if([self isKindOfClass:UITabBar.class])
	{
		[[(UITabBar*)self selectedItem] _ln_setAttachedPopupController:attachedPopupController];
	}
}

@end

@implementation UIView (LNPopupSupportPrivate)

+ (void)load
{
	@autoreleasepool 
	{
#if ! LNPopupControllerEnforceStrictClean
		//updateBackgroundGroupName
		SEL updateBackgroundGroupNameSEL = NSSelectorFromString(_LNPopupDecodeBase64String(_uBGN));
		
		id (^trampoline)(void (*)(id, SEL)) = ^ id (void (*orig)(id, SEL)){
			return ^ (id _self) {
				orig(_self, updateBackgroundGroupNameSEL);
				
				static NSString* key = nil;
				static dispatch_once_t onceToken;
				dispatch_once(&onceToken, ^{
					//groupName
					key = _LNPopupDecodeBase64String(_gN);
				});
				
				id backgroundView = [_self valueForKey:@"backgroundView"];
				
				NSString* groupName = [backgroundView valueForKey:key];
				if([groupName hasSuffix:@"🤡"] == NO)
				{
					[backgroundView setValue:[NSString stringWithFormat:@"%@🤡", groupName] forKey:key];
				}
			};
		};
		
		{
			//_UINavigationBarVisualProvider
			Class cls = NSClassFromString(_LNPopupDecodeBase64String(_UINBVP));
			Method m = class_getInstanceMethod(cls, updateBackgroundGroupNameSEL);
			void (*orig)(id, SEL) = (void*)method_getImplementation(m);
			method_setImplementation(m, imp_implementationWithBlock(trampoline(orig)));
		}
		
		{
			//_UINavigationBarVisualProviderLegacyIOS
			Class cls = NSClassFromString(_LNPopupDecodeBase64String(_UINBVPLI));
			Method m = class_getInstanceMethod(cls, updateBackgroundGroupNameSEL);
			void (*orig)(id, SEL) = (void*)method_getImplementation(m);
			method_setImplementation(m, imp_implementationWithBlock(trampoline(orig)));
		}
		
		{
			//_UINavigationBarVisualProviderModernIOS
			Class cls = NSClassFromString(_LNPopupDecodeBase64String(_UINBVPMI));
			Method m = class_getInstanceMethod(cls, updateBackgroundGroupNameSEL);
			void (*orig)(id, SEL) = (void*)method_getImplementation(m);
			method_setImplementation(m, imp_implementationWithBlock(trampoline(orig)));
		}
		
		//_didMoveFromWindow:toWindow:
		NSString* sel = _LNPopupDecodeBase64String(_dMFWtW);
		LNSwizzleMethod(self,
						NSSelectorFromString(sel),
						@selector(_ln__dMFW:tW:));
#else
		LNSwizzleMethod(self,
						@selector(didMoveToWindow),
						@selector(_ln_didMoveToWindow));
#endif
	}
}

- (void)_ln_triggerBarAppearanceRefreshIfNeededTriggeringLayout:(BOOL)layout
{
	//Do nothing on UIView.
}

- (BOOL)_ln_scrollEdgeAppearanceRequiresFadeForPopupBar:(LNPopupBar*)popupBar
{
	return NO;
}

#if ! LNPopupControllerEnforceStrictClean
//_didMoveFromWindow:toWindow:
- (void)_ln__dMFW:(UIWindow*)fromWindow tW:(UIWindow*)toWindow
{
	[self _ln__dMFW:fromWindow tW:toWindow];
	
	if([self.nextResponder isKindOfClass:UIViewController.class] && [self.nextResponder respondsToSelector:@selector(_ln_popup_viewDidMoveToWindow)])
	{
		[(id)self.nextResponder _ln_popup_viewDidMoveToWindow];
	}
	
	[self _ln_notify];
}
#else
- (void)_ln_didMoveToWindow
{
	[self _ln_didMoveToWindow];
	
	[self _ln_notify];
}
#endif

LNAlwaysInline
static void _LNNotify(UIView* self, NSMutableArray<LNInWindowBlock>* waiting)
{
	if(waiting.count == 0)
	{
		[self _ln_setNotifying:NO];
		return;
	}
	
	LNInWindowBlock block = waiting.firstObject;
	[waiting removeObjectAtIndex:0];
	block(^ {
		_LNNotify(self, waiting);
	});
}

- (void)_ln_setNotifying:(BOOL)notifying
{
	objc_setAssociatedObject(self, LNPopupNotifyingKey, @(notifying), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)_ln_isNotifying
{
	return [objc_getAssociatedObject(self, LNPopupNotifyingKey) boolValue];
}

- (void)_ln_notify
{
	NSMutableArray<LNInWindowBlock>* waiting = objc_getAssociatedObject(self, LNPopupAwaitingViewInWindowHierarchyKey);
	
	if(waiting.count == 0)
	{
		return;
	}
	
	[self _ln_setNotifying:YES];
	
	_LNNotify(self, waiting);
}

- (void)_ln_letMeKnowWhenViewInWindowHierarchy:(LNInWindowBlock)block
{
	NSMutableArray<LNInWindowBlock>* waiting = objc_getAssociatedObject(self, LNPopupAwaitingViewInWindowHierarchyKey);
	if(waiting == nil)
	{
		waiting = [NSMutableArray new];
		objc_setAssociatedObject(self, LNPopupAwaitingViewInWindowHierarchyKey, waiting, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	
	[waiting addObject:block];
	
	if(self.window != nil && self._ln_isNotifying == NO)
	{
		[self _ln_notify];
	}
}

- (void)_ln_forgetAboutIt
{
	NSMutableArray<LNInWindowBlock>* waiting = objc_getAssociatedObject(self, LNPopupAwaitingViewInWindowHierarchyKey);
	[waiting removeAllObjects];
}

- (NSString*)_ln_effectGroupingIdentifierIfAvailable
{
#if ! LNPopupControllerEnforceStrictClean
	static NSString* key = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		key = _LNPopupDecodeBase64String(_bVLGN);
	});
	
	if([self respondsToSelector:NSSelectorFromString(key)])
	{
		return [self valueForKey:key];
	}
	else
	{
#endif
		return nil;
#if ! LNPopupControllerEnforceStrictClean
	}
#endif
}

- (void)_ln_freezeInsets
{
	LNDynamicallySubclass(self, __LNPopupUIViewFrozenInsets.class);
}

@end

#if ! LNPopupControllerEnforceStrictClean
@interface UIWindow (ScrollToTopFix) @end
@implementation UIWindow (ScrollToTopFix)

+ (void)load
{
	@autoreleasepool
	{
		//_registeredScrollToTopViews
		NSString* selName = _LNPopupDecodeBase64String(_rSTTV);
		LNSwizzleMethod(self,
						NSSelectorFromString(selName),
						@selector(_ln_rSTTV));
	}
}

//_registeredScrollToTopViews
- (NSArray*)_ln_rSTTV
{
	NSArray* rv = [self _ln_rSTTV];
	NSMutableArray* popupRV = [NSMutableArray new];
	
	//_viewControllerForAncestor
	static NSString* vCFA = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		vCFA = _LNPopupDecodeBase64String(_vCFA);
	});
	
	for(UIView* scrollToTopCandidate in rv)
	{
		UIViewController* vc = [scrollToTopCandidate valueForKey:vCFA];
		
		if(vc == nil)
		{
			continue;
		}
		
		BOOL fromPopup = vc._isContainedInOpenPopupController;
		if(fromPopup)
		{
			[popupRV addObject:scrollToTopCandidate];
		}
	}
	
	if(popupRV.count > 0)
	{
		return popupRV;
	}
	
	return rv;
}

@end

#endif

#if TARGET_OS_MACCATALYST
	
@implementation UIWindow (MacCatalystSupport)

- (UIEvent*)_ln_currentEvent
{
#if LNPopupControllerEnforceStrictClean
	return nil;
#else
	//hostWindow
	static NSString* hW;
	//attachedWindow
	static NSString* aW;
	//currentEvent
	static NSString* cE;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		hW = _LNPopupDecodeBase64String(_hW);
		aW = _LNPopupDecodeBase64String(_aW);
		cE = _LNPopupDecodeBase64String(_cE);
	});
	
	//Obtain the actual NSWindow object
	id hostingWindow = [self valueForKey:hW];
	if([NSStringFromClass([hostingWindow class]) hasSuffix:@"Proxy"])
	{
		//On Big Sur, the hosting window is abstracted behind a proxy object, but we need the actual NSWindow
		hostingWindow = [hostingWindow valueForKey:aW];
	}
	//Obtain the current NSEvent
	return [hostingWindow valueForKey:cE];
#endif
}

@end


#endif

LNAlwaysInline
BOOL _LNBottomBarIsInPopupPresentation(NSObject* self)
{
	LNPopupController* attachedController = self.attachedPopupController;
	return attachedController != nil && attachedController.popupControllerTargetState >= LNPopupPresentationStateBarPresented;
}

LNAlwaysInline
LNPopupBar* _LNPopupBarForBottomBarIfInPopupPresentation(NSObject* self)
{
	LNPopupController* attachedController = self.attachedPopupController;
	if(attachedController != nil && attachedController.popupControllerTargetState >= LNPopupPresentationStateBarPresented)
	{
		return attachedController.popupBar;
	}
	
	return nil;
}

LNAlwaysInline
id _LNPopupReturnScrollEdgeAppearanceOrStandardAppearance(id self, SEL standardAppearanceSelector, SEL scrollEdgeAppearanceSelector)
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	if(_LNBottomBarIsInPopupPresentation(self))
	{
		return [self performSelector:standardAppearanceSelector];
	}
	else
	{
		return [self performSelector:scrollEdgeAppearanceSelector];
	}
#pragma clang diagnostic pop
}

static BOOL __ln_scrollEdgeAppearanceRequiresFadeForPopupBar(id bottomBar, LNPopupBar* popupBar)
{
	//backgroundTransitionProgress
	static NSString* bTP = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		bTP = _LNPopupDecodeBase64String(_bTP);
	});
	
	BOOL isAtScrollEdge = [[bottomBar valueForKey:bTP] doubleValue] > 0;
	
	if(isAtScrollEdge == NO)
	{
		return NO;
	}
	
	UIBarAppearance* scrollEdgeAppearance = [bottomBar _lnpopup_scrollEdgeAppearance];
	
	return scrollEdgeAppearance.backgroundEffect == nil && scrollEdgeAppearance.backgroundColor == nil && scrollEdgeAppearance.backgroundImage == nil;
}

@interface UIToolbar (ScrollEdgeSupport) @end
@implementation UIToolbar (ScrollEdgeSupport)

+ (void)load
{
	@autoreleasepool
	{
		if(@available(iOS 15.0, *))
		{
			LNSwizzleMethod(self, @selector(layoutSubviews), @selector(_ln_layoutSubviews));
#if ! LNPopupControllerEnforceStrictClean
			LNSwizzleMethod(self, @selector(standardAppearance), @selector(_lnpopup_standardAppearance));
			LNSwizzleMethod(self, @selector(compactAppearance), @selector(_lnpopup_compactAppearance));
#endif
			LNSwizzleMethod(self, @selector(setStandardAppearance:), @selector(_lnpopup_setStandardAppearance:));
			LNSwizzleMethod(self, @selector(setCompactAppearance:), @selector(_lnpopup_setCompactAppearance:));
			LNSwizzleMethod(self, @selector(scrollEdgeAppearance), @selector(_lnpopup_scrollEdgeAppearance));
			LNSwizzleMethod(self, @selector(compactScrollEdgeAppearance), @selector(_lnpopup_compactScrollEdgeAppearance));
		}
	}
}

- (void)_ln_layoutSubviews
{
	[self _ln_layoutSubviews];
	
	[self._ln_attachedPopupController _configurePopupBarFromBottomBarModifyingGroupingIdentifier:NO];
}

- (void)_ln_triggerBarAppearanceRefreshIfNeededTriggeringLayout:(BOOL)layout
{
	if(@available(iOS 15.0, *))
	{
		self.scrollEdgeAppearance = self._lnpopup_scrollEdgeAppearance;
		self.compactScrollEdgeAppearance = self._lnpopup_compactScrollEdgeAppearance;
		if(layout)
		{
			[self setNeedsLayout];
			[self layoutIfNeeded];
		}
	}
}

- (BOOL)_ln_scrollEdgeAppearanceRequiresFadeForPopupBar:(LNPopupBar*)popupBar
{
	return __ln_scrollEdgeAppearanceRequiresFadeForPopupBar(self, popupBar);
}

- (UIToolbarAppearance *)_lnpopup_scrollEdgeAppearance
{
	return _LNPopupReturnScrollEdgeAppearanceOrStandardAppearance(self, @selector(standardAppearance), @selector(_lnpopup_scrollEdgeAppearance));
}

- (UIToolbarAppearance *)_lnpopup_compactScrollEdgeAppearance
{
	return _LNPopupReturnScrollEdgeAppearanceOrStandardAppearance(self, @selector(standardAppearance), @selector(_lnpopup_compactScrollEdgeAppearance));
}

#if ! LNPopupControllerEnforceStrictClean
- (UIToolbarAppearance*)_lnpopup_standardAppearance
{
	__weak __typeof(self) weakSelf = self;
	
	UIToolbarAppearance* rv = self._lnpopup_standardAppearance;
	
	if(rv == nil)
	{
		return rv;
	}
	
	return (id)[[_LNPopupUIBarAppearanceProxy alloc] initWithProxiedObject:rv shadowColorHandler:^BOOL{
		LNPopupBar* popupBar = _LNPopupBarForBottomBarIfInPopupPresentation(weakSelf);
		return popupBar != nil && popupBar.effectiveBarStyle == LNPopupBarStyleFloating;
	}];
}

- (UIToolbarAppearance*)_lnpopup_compactAppearance
{
	__weak __typeof(self) weakSelf = self;
	
	UIToolbarAppearance* rv = self._lnpopup_compactAppearance;
	
	if(rv == nil)
	{
		return rv;
	}
	
	return (id)[[_LNPopupUIBarAppearanceProxy alloc] initWithProxiedObject:rv shadowColorHandler:^BOOL{
		LNPopupBar* popupBar = _LNPopupBarForBottomBarIfInPopupPresentation(weakSelf);
		return popupBar != nil && popupBar.effectiveBarStyle == LNPopupBarStyleFloating;
	}];
}
#endif

- (void)_lnpopup_setStandardAppearance:(UIToolbarAppearance *)standardAppearance
{
	[self _lnpopup_setStandardAppearance:standardAppearance];
	
	[self _ln_triggerBarAppearanceRefreshIfNeededTriggeringLayout:YES];
}

- (void)_lnpopup_setCompactAppearance:(UIToolbarAppearance *)compactAppearance
{
	[self _lnpopup_setCompactAppearance:compactAppearance];
	
	[self _ln_triggerBarAppearanceRefreshIfNeededTriggeringLayout:YES];
}

@end

@interface UITabBarItem (ScrollEdgeSupport) @end
@implementation UITabBarItem (ScrollEdgeSupport)

+ (void)load
{
	@autoreleasepool
	{
		if(@available(iOS 15.0, *))
		{
#if ! LNPopupControllerEnforceStrictClean
			LNSwizzleMethod(self, @selector(standardAppearance), @selector(_lnpopup_standardAppearance));
#endif
			LNSwizzleMethod(self, @selector(setStandardAppearance:), @selector(_lnpopup_setStandardAppearance:));
			LNSwizzleMethod(self, @selector(scrollEdgeAppearance), @selector(_lnpopup_scrollEdgeAppearance));
		}
	}
}

- (void)_ln_triggerBarAppearanceRefreshIfNeededTriggeringLayout:(BOOL)layout
{
	if(@available(iOS 15.0, *))
	{
		self.scrollEdgeAppearance = self._lnpopup_scrollEdgeAppearance;
	}
}

- (BOOL)_ln_scrollEdgeAppearanceRequiresFadeForPopupBar:(LNPopupBar*)popupBar
{
	return __ln_scrollEdgeAppearanceRequiresFadeForPopupBar(self, popupBar);
}

- (UITabBarAppearance *)_lnpopup_scrollEdgeAppearance
{
	return _LNPopupReturnScrollEdgeAppearanceOrStandardAppearance(self, @selector(standardAppearance), @selector(_lnpopup_scrollEdgeAppearance));
}

#if ! LNPopupControllerEnforceStrictClean
- (UITabBarAppearance *)_lnpopup_standardAppearance
{
	__weak __typeof(self) weakSelf = self;
	
	UITabBarAppearance* rv = self._lnpopup_standardAppearance;
	
	if(rv == nil)
	{
		return rv;
	}
	
	return (id)[[_LNPopupUIBarAppearanceProxy alloc] initWithProxiedObject:rv shadowColorHandler:^BOOL{
		LNPopupBar* popupBar = _LNPopupBarForBottomBarIfInPopupPresentation(weakSelf);
		return popupBar != nil && popupBar.effectiveBarStyle == LNPopupBarStyleFloating;
	}];
}
#endif

- (void)_lnpopup_setStandardAppearance:(UITabBarAppearance *)standardAppearance
{
	[self _lnpopup_setStandardAppearance:standardAppearance];
	
	[self _ln_triggerBarAppearanceRefreshIfNeededTriggeringLayout:YES];
}

@end

static const void* LNPopupIgnoringLayoutDuringTransition = &LNPopupIgnoringLayoutDuringTransition;

@interface UITabBar (ScrollEdgeSupport) @end
@implementation UITabBar (ScrollEdgeSupport)

- (BOOL)_ignoringLayoutDuringTransition
{
	return [objc_getAssociatedObject(self, LNPopupIgnoringLayoutDuringTransition) boolValue];
}

- (void)_setIgnoringLayoutDuringTransition:(BOOL)ignoringLayoutDuringTransition
{
	objc_setAssociatedObject(self, LNPopupIgnoringLayoutDuringTransition, @(ignoringLayoutDuringTransition), OBJC_ASSOCIATION_RETAIN);
}

+ (void)load
{
	@autoreleasepool
	{
		LNSwizzleMethod(self, @selector(setFrame:), @selector(_ln_setFrame:));
		LNSwizzleMethod(self, @selector(layoutSubviews), @selector(_ln_layoutSubviews));
		LNSwizzleMethod(self, @selector(setSelectedItem:), @selector(_ln_setSelectedItem:));
		
		if(@available(iOS 15.0, *))
		{
#if ! LNPopupControllerEnforceStrictClean
			LNSwizzleMethod(self, @selector(standardAppearance), @selector(_lnpopup_standardAppearance));
#endif
			LNSwizzleMethod(self, @selector(setStandardAppearance:), @selector(_lnpopup_setStandardAppearance:));
			LNSwizzleMethod(self, @selector(scrollEdgeAppearance), @selector(_lnpopup_scrollEdgeAppearance));
		}
		
#if ! LNPopupControllerEnforceStrictClean
		if(@available(iOS 17.0, *))
		{
			Class cls = NSClassFromString(_LNPopupDecodeBase64String(_UBB));
			SEL sel = NSSelectorFromString(_LNPopupDecodeBase64String(_tBVA));
			Method m = class_getInstanceMethod(cls, sel);
			void (*orig)(id, SEL, BOOL) = (void*)method_getImplementation(m);
			method_setImplementation(m, imp_implementationWithBlock(^(id _self, BOOL animated) {
				if([objc_getAssociatedObject(_self, LNPopupBarBackgroundViewForceAnimatedKey) boolValue] == YES)
				{
					animated = YES;
				}
				
				orig(_self, sel, animated);
			}));
		}
#endif
	}
}

- (void)_ln_setFrame:(CGRect)frame
{
	if(self._ignoringLayoutDuringTransition == NO)
	{
		[self _ln_setFrame:frame];
	}
}

- (void)_ln_layoutSubviews
{
	[self _ln_layoutSubviews];
	
	[self._ln_attachedPopupController _configurePopupBarFromBottomBarModifyingGroupingIdentifier:NO];
}

- (void)_ln_setSelectedItem:(UITabBarItem *)selectedItem
{
	[self _ln_setSelectedItem:selectedItem];
	
	[selectedItem _ln_setAttachedPopupController:self._ln_attachedPopupController];
	[self._ln_attachedPopupController _configurePopupBarFromBottomBarModifyingGroupingIdentifier:NO];
}

- (void)_ln_transitionBackgroundViewsAnimated:(BOOL)arg1
{
	[self _ln_transitionBackgroundViewsAnimated:YES];
}

- (void)_ln_triggerBarAppearanceRefreshIfNeededTriggeringLayout:(BOOL)layout
{
	id backgroundView = nil;
	
	if(@available(iOS 15.0, *))
	{
#if ! LNPopupControllerEnforceStrictClean
		backgroundView = [self valueForKey:_LNPopupDecodeBase64String(_bV)];
		if(backgroundView != nil)
		{
			objc_setAssociatedObject(backgroundView, LNPopupBarBackgroundViewForceAnimatedKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		}
#endif
		
		self.scrollEdgeAppearance = self._lnpopup_scrollEdgeAppearance;
		
		[self.selectedItem _ln_triggerBarAppearanceRefreshIfNeededTriggeringLayout:layout];
	}
	
	if(layout)
	{
		//This triggers a refresh of the bar appearance.
		[self setNeedsLayout];
		[self layoutIfNeeded];
	}
	
	if(@available(iOS 15.0, *))
	{
#if ! LNPopupControllerEnforceStrictClean
		if(backgroundView != nil)
		{
			objc_setAssociatedObject(backgroundView, LNPopupBarBackgroundViewForceAnimatedKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		}
#endif
	}
}

- (BOOL)_ln_scrollEdgeAppearanceRequiresFadeForPopupBar:(LNPopupBar*)popupBar
{
	return __ln_scrollEdgeAppearanceRequiresFadeForPopupBar(self, popupBar);
}

- (UITabBarAppearance *)_lnpopup_scrollEdgeAppearance
{
	return _LNPopupReturnScrollEdgeAppearanceOrStandardAppearance(self, @selector(standardAppearance), @selector(_lnpopup_scrollEdgeAppearance));
}

#if ! LNPopupControllerEnforceStrictClean
- (UITabBarAppearance *)_lnpopup_standardAppearance
{
	__weak __typeof(self) weakSelf = self;
	
	UITabBarAppearance* rv = self._lnpopup_standardAppearance;
	
	if(rv == nil)
	{
		return rv;
	}
	
	return (id)[[_LNPopupUIBarAppearanceProxy alloc] initWithProxiedObject:rv shadowColorHandler:^BOOL{
		LNPopupBar* popupBar = _LNPopupBarForBottomBarIfInPopupPresentation(weakSelf);
		return popupBar != nil && popupBar.effectiveBarStyle == LNPopupBarStyleFloating;
	}];
}
#endif

- (void)_lnpopup_setStandardAppearance:(UITabBarAppearance *)standardAppearance
{
	[self _lnpopup_setStandardAppearance:standardAppearance];
	
	[self _ln_triggerBarAppearanceRefreshIfNeededTriggeringLayout:YES];
}

@end

@implementation UIScrollView (LNPopupSupportPrivate)

- (CGSize)_ln_adjustedContentSize
{
	CGRect rect = (CGRect){0, 0, self.contentSize};
	if([NSStringFromClass(self.class) containsString:@"Queu"] == NO)
	{
		rect = UIEdgeInsetsInsetRect(rect, self.adjustedContentInset);
	}
	return rect.size;
}

- (BOOL)_ln_hasHorizontalContent
{
	CGSize contentSize = self._ln_adjustedContentSize;
	BOOL rv = contentSize.width > self.bounds.size.width;
	
//	NSLog(@"_ln_hasHorizontalContent: %@ contentSize: %@", @(rv), @(contentSize));
	
	return rv;
}

- (BOOL)_ln_hasVerticalContent
{
	CGSize contentSize = self._ln_adjustedContentSize;
	BOOL rv = contentSize.height > self.bounds.size.height;
	
//	NSLog(@"_ln_hasVerticalContent: %@", @(rv));
	
	return rv;
}

@end
