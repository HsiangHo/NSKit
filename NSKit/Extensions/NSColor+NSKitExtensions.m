//
//  NSColor+NSKitExtensions.m
//  NSKit
//
//  Created by Patrick Chamelo on 6/24/13.
//  Copyright (c) 2015 Patrick Chamelo. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "NSColor+NSKitExtensions.h"

@implementation NSColor (NSKitExtensions)

#pragma mark - Class Methods

+ (NSColor *)nskit_randomColor
{
    CGFloat red =  (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random() / (CGFloat)RAND_MAX;
    return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:1.0];
}

+ (NSColor *)nskit_colorFromHexRGB:(NSString *)colorString
{
	NSColor *result;
	unsigned int colorCode = 0;
	unsigned char redByte, greenByte, blueByte;
	if (colorString){
		NSScanner *scanner = [NSScanner scannerWithString:colorString];
		(void) [scanner scanHexInt:&colorCode];
	}
    
	redByte		= (unsigned char) (colorCode >> 16);
	greenByte	= (unsigned char) (colorCode >> 8);
	blueByte	= (unsigned char) (colorCode);
	result = [NSColor colorWithCalibratedRed:(float)redByte	/ 0xff
                                       green:(float)greenByte/ 0xff
                                        blue:(float)blueByte	/ 0xff
                                       alpha:1.0];
	return result;
}

+ (NSString *)nskit_hexCodeWithColor:(NSColor *)color
{
    CGFloat r, g, b;
    [NSColor nskit_adjustRed:&r green:&g blue:&b color:color];
    return [NSString stringWithFormat:@"%0.2X%0.2X%0.2X",
            (int)(r * 255),
            (int)(g * 255),
            (int)(b * 255)];
}

+ (NSString *)nskit_RGBWithColor:(NSColor *)color
{
    CGFloat r, g, b;
    [NSColor nskit_adjustRed:&r green:&g blue:&b color:color];
    return [NSString stringWithFormat:@"%.0f, %.0f, %.0f",
            (r * 255),
            (g * 255),
            (b * 255)];
}

+ (void)nskit_adjustRed:(CGFloat *)red
                  green:(CGFloat *)green
                   blue:(CGFloat *)blue
                  color:(NSColor *)color
{
    NSString *colorSpaceName = [color colorSpaceName];
    if (([colorSpaceName isEqualToString:NSCalibratedWhiteColorSpace] ||
         [colorSpaceName isEqualToString:NSDeviceWhiteColorSpace]) &&
         [color respondsToSelector:@selector(whiteComponent)]){
        *red = [color whiteComponent];
        *green = [color whiteComponent];
        *blue = [color whiteComponent];
    } else if (([colorSpaceName isEqualToString:NSCalibratedRGBColorSpace] ||
                [colorSpaceName isEqualToString:NSDeviceRGBColorSpace]) &&
                [color respondsToSelector:@selector(redComponent)]) {
        *red = [color redComponent];
        *green = [color greenComponent];
        *blue = [color blueComponent];
    } else {
        NSColor *rgbColor = [color colorUsingColorSpaceName:NSDeviceRGBColorSpace];
        *red = [rgbColor redComponent];
        *green = [rgbColor greenComponent];
        *blue = [rgbColor blueComponent];
    }
}

#pragma mark - Object Methods

- (CGColorRef)nskit_CGColor
{
    if ([self respondsToSelector:@selector(CGColor)]) {
        return self.CGColor;
    }
    NSColorSpace *colorSpace = [NSColorSpace genericRGBColorSpace];
    NSColor *color = [self colorUsingColorSpace:colorSpace];
    NSInteger count = [color numberOfComponents];
    CGFloat components[count];
    [color getComponents:components];
    CGColorSpaceRef colorSpaceRef = colorSpace.CGColorSpace;
    CGColorRef result = CGColorCreate(colorSpaceRef, components);
    // TODO: This is leaking :(
    return (CGColorRef)result;
}

@end
