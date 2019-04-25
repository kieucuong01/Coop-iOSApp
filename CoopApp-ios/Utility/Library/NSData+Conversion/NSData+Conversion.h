//
//  NSData+Conversion.h
//  rider
//
//  Created by LOC on 10/30/18.
//  Copyright © 2018 Minerva. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (NSData_Conversion)

#pragma mark - String Conversion
- (NSString *)hexadecimalString;

#pragma mark -
#pragma mark Zlib Compression routines
/*! Returns a data object containing a Zlib decompressed copy of the receivers contents.
 * \returns A data object containing a Zlib decompressed copy of the receivers contents.
 */
- (NSData *) zlibInflate;
/*! Returns a data object containing a Zlib compressed copy of the receivers contents.
 * \returns A data object containing a Zlib compressed copy of the receivers contents.
 */
- (NSData *) zlibDeflate;

#pragma mark -
#pragma mark Gzip Compression routines
/*! Returns a data object containing a Gzip decompressed copy of the receivers contents.
 * \returns A data object containing a Gzip decompressed copy of the receivers contents.
 */
- (NSData *) gzipInflate;
/*! Returns a data object containing a Gzip compressed copy of the receivers contents.
 * \returns A data object containing a Gzip compressed copy of the receivers contents.
 */
- (NSData *) gzipDeflate;

@end


@interface NSString (NSStringHexToBytes)
-(NSData*) hexToBytes ;
@end
NS_ASSUME_NONNULL_END
