//
//  GLTexture.h
//  glimageprocess
//
//  Created by li yajie on 5/2/13.
//  Copyright (c) 2013 com.coamee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLTexture : NSObject

@property(nonatomic,retain) NSString *textureFileName;

@property(nonatomic,readonly) CGFloat width;

@property(nonatomic,readonly) CGFloat height;
/**
 * init the texture
 */
-(id) initTexture:(NSString*) fileName;

/**
 * use the texture
 */
-(void) useTexture;
@end
