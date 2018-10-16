

#import <Foundation/Foundation.h>

@interface NSData (BYXHash)
/**
 *  @brief  md5 NSData
 */
@property (readonly) NSData *byx_md5Data;
/**
 *  @brief  sha1Data NSData
 */
@property (readonly) NSData *byx_sha1Data;
/**
 *  @brief  sha256Data NSData
 */
@property (readonly) NSData *byx_sha256Data;
/**
 *  @brief  sha512Data NSData
 */
@property (readonly) NSData *byx_sha512Data;

/**
 *  @brief  md5 NSData
 *
 *  @param key 密钥
 *
 *  @return 结果
 */
- (NSData *)byx_hmacMD5DataWithKey:(NSData *)key;
/**
 *  @brief  sha1Data NSData
 *
 *  @param key 密钥
 *
 *  @return 结果
 */
- (NSData *)byx_hmacSHA1DataWithKey:(NSData *)key;
/**
 *  @brief  sha256Data NSData
 *
 *  @param key 密钥
 *
 *  @return 结果
 */
- (NSData *)byx_hmacSHA256DataWithKey:(NSData *)key;
/**
 *  @brief  sha512Data NSData
 *
 *  @param key 密钥
 *
 *  @return 结果
 */
- (NSData *)byx_hmacSHA512DataWithKey:(NSData *)key;
@end
