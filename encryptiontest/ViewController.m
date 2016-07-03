//
//  ViewController.m
//  encryptiontest
//
//  Created by Charlie Fish on 6/27/16.
//  Copyright © 2016 Charlie Fish. All rights reserved.
//

#import "ViewController.h"
#import "RSA.h"
#import "NSData+Base64.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
//	[self generateKeyPairPlease];
	

	
//	NSData *pubkeydata = [self getPublicKeyBits];
	
	
//	NSString *key = [self formatKey:pubkeydata];
	
	NSString *pubkey = @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDLuwt30JLYFvKcFOUdjPuDRdqv\nSnDb5TSdA/w0ND/GwLExpT66DeRz9+6//G//Y0y3c/yWT14k/ab1vID4U6W3vOgr\nafC0RyuIgH8ooCTNQpU+LtIoZ6qCejnux7VZ5lwWeT/9DQjWOtf6TopeRdzmOX09\nwa7c5xGGUsmi29QxDQIDAQAB\n-----END PUBLIC KEY-----";
	
	NSString *key = @"-----BEGIN PUBLIC KEY-----\nMIGJAoGBAN0NAbrTv6iT17tVJUYJORsoU3UsLR2rfVYWIWYtWlf2HmUCzX0B+Z2s\no3FCJWONZ7JMUa86OVJKCpV/792WdCm/PRzQrJ4Q5oB9yMHs9jxVyvEgTBZcgZoW\np4g9VFNdwvzAo7Aj8fVAcGPe8JMGeRyWhXoRoVdNtCMVOfXYXSulAgMBAAE=\n-----END PUBLIC KEY-----";
	

	//Doesn't work
	NSString *ret = [RSA encryptString:@"test" publicKey:key];
	NSLog(@"encrypted: %@", ret);
	
	
	NSString *ret2 = [RSA encryptString:@"test" publicKey:pubkey];
	NSLog(@"encrypted: %@", ret2);
	
	
	//Doesn't work
	NSString *ret3 = [RSA decryptString:ret2 publicKey:pubkey];
	NSLog(@"decrypted: %@", ret3);


}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}



static const UInt8 publicKeyIdentifier[] = "test";
static const UInt8 privateKeyIdentifier[] = "test";
// 1


- (void)generateKeyPairPlease
{
	OSStatus status = noErr;
	NSMutableDictionary *privateKeyAttr = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *publicKeyAttr = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *keyPairAttr = [[NSMutableDictionary alloc] init];
	// 2
	
	publicTag = [NSData dataWithBytes:publicKeyIdentifier
										length:strlen((const char *)publicKeyIdentifier)];
	privateTag = [NSData dataWithBytes:privateKeyIdentifier
										 length:strlen((const char *)privateKeyIdentifier)];
	// 3
	
	SecKeyRef publicKey = NULL;
	SecKeyRef privateKey = NULL;                                // 4
	
	[keyPairAttr setObject:(id)kSecAttrKeyTypeRSA
					forKey:(id)kSecAttrKeyType]; // 5
	[keyPairAttr setObject:[NSNumber numberWithInt:1024]
					forKey:(id)kSecAttrKeySizeInBits]; // 6
	
	[privateKeyAttr setObject:[NSNumber numberWithBool:YES]
					   forKey:(id)kSecAttrIsPermanent]; // 7
	[privateKeyAttr setObject:privateTag
					   forKey:(id)kSecAttrApplicationTag]; // 8
	
	[publicKeyAttr setObject:[NSNumber numberWithBool:YES]
					  forKey:(id)kSecAttrIsPermanent]; // 9
	[publicKeyAttr setObject:publicTag
					  forKey:(id)kSecAttrApplicationTag]; // 10
	
	[keyPairAttr setObject:privateKeyAttr
					forKey:(id)kSecPrivateKeyAttrs]; // 11
	[keyPairAttr setObject:publicKeyAttr
					forKey:(id)kSecPublicKeyAttrs]; // 12
	
	status = SecKeyGeneratePair((CFDictionaryRef)keyPairAttr,
								&publicKey, &privateKey); // 13
	//    error handling...
	
}


- (NSData *)getPublicKeyBits {
	OSStatus sanityCheck = noErr;
	NSData * publicKeyBits = nil;
	
	NSMutableDictionary * queryPublicKey = [[NSMutableDictionary alloc] init];
	
	// Set the public key query dictionary.
	[queryPublicKey setObject:(id)kSecClassKey forKey:(id)kSecClass];
	[queryPublicKey setObject:publicTag forKey:(id)kSecAttrApplicationTag];
	[queryPublicKey setObject:(id)kSecAttrKeyTypeRSA forKey:(id)kSecAttrKeyType];
	[queryPublicKey setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecReturnData];
	
	// Get the key bits.
	sanityCheck = SecItemCopyMatching((CFDictionaryRef)queryPublicKey, (void *)&publicKeyBits);
	
	if (sanityCheck != noErr)
	{
		publicKeyBits = nil;
	}
	
	return publicKeyBits;
}



- (NSString *)formatKey:(NSData*)originalString {
	
	NSString *before = @"-----BEGIN PUBLIC KEY-----\n";
	NSString *after = @"\n-----END PUBLIC KEY-----";
	NSString *key = [originalString base64EncodedString];


	
	NSMutableString *resultString = [NSMutableString string];
	
	
//	for(int i = 0; i<[key length]/64; i++)
//	{
//		NSUInteger fromIndex = i * 64;
//		NSUInteger len = [key length] - fromIndex;
//		if (len > 64) {
//			len = 64;
//		}
//		
//		[resultString appendFormat:@"%@\n",[key substringWithRange:NSMakeRange(fromIndex, len)]];
//	}
	
	[resultString appendFormat:@"%@\n",[key substringWithRange:NSMakeRange(0, 64)]];
	[resultString appendFormat:@"%@\n",[key substringWithRange:NSMakeRange(64, 64)]];
	[resultString appendFormat:@"%@\n",[key substringWithRange:NSMakeRange(128, 64)]];

	
	resultString = [NSString stringWithFormat:@"%@%@%@",before,resultString,after];
	
	return resultString;
}




@end
