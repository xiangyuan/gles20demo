//
//  ViewController.m
//  glimageprocess
//
//  Created by li yajie on 5/2/13.
//  Copyright (c) 2013 com.coamee. All rights reserved.
//

#import "ViewController.h"
#import "GLView.h"
#import "GLProgram.h"
#import "GLTexture.h"
#import "GLTexture.h"

@interface ViewController ()

@end



//const float vertexes[] = {
//    0.5,-0.5,0,
//    0.5,0.5,0,
//    -0.5,0.5,0,
//    -0.5,-0.5,0
//};
const float vertexes[] = {
    0,0.,0,
    1,0,0,
    0,1.0,0,
    1,1,0
};

//dot index
const GLubyte indices[] = {
    0,1,2,
    2,3,1
};

const float texturecoords[] = {
    0.0,0.75,
    0.75,0.75,
    0.0,0.0,
    0.75,0.0
};


@implementation ViewController
{
    GLView *glView;
    GLuint vboIndex[3];//0 positions 1 the indices
    GLProgram *glProgram;
    GLTexture *texture;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    glView = [[GLView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    glView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
       [self.view addSubview:glView];
    [glView release];
    [self setupVBOS];
    [self setup];
//    [self setupDisplayLink];
    [self render];
}

-(void) setup {
    if (glProgram == nil) {
        glProgram = [GLProgram initWithVertexShader:@"vertext.vsh" withFragmentShader:@"fragment.fsh"];
    }
    if (texture == nil) {
        texture = [[GLTexture alloc]initTexture:@"wheel.png"];
    }
}

-(void) setupVBOS {
    glGenBuffers(3, vboIndex);
    glBindBuffer(GL_ARRAY_BUFFER, vboIndex[0]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexes), vertexes, GL_STATIC_DRAW);
    
  
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vboIndex[1]);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
//    glBindBuffer(GL_ARRAY_BUFFER, vboIndex[2]);
//    glBufferData(GL_ARRAY_BUFFER, sizeof(texturecoords), texturecoords, GL_STATIC_DRAW);
}

-(void) render{
//    glBindFramebuffer(GL_FRAMEBUFFER, glView.frameBuffer);
   
    glColorMask(GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);
    glDepthMask(GL_TRUE);
    glClearColor(0.8, 0.6, 0.8, 1.0);
    glClear(GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
    GLenum __error = glGetError();
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);// perfomance important
//    glFrontFace(GL_CCW);
    glViewport(0, 0, self.view.frame.size.width, self.view.frame.size.height);//must be filled
    kmGLMatrixMode(KM_GL_PROJECTION);
    kmGLLoadIdentity();
    // clip the world space
    kmMat4 orthoMatrix;
    kmMat4OrthographicProjection(&orthoMatrix, 0, self.view.frame.size.width / self.view.contentScaleFactor, 0, self.view.frame.size.height / self.view.contentScaleFactor, -1024, 1024);
    kmGLMultMatrix(&orthoMatrix);
    kmGLMatrixMode(KM_GL_MODELVIEW);
    kmGLLoadIdentity();
    
    glBindBuffer(GL_ARRAY_BUFFER, vboIndex[0]);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vboIndex[1]);
//    glBindBuffer(GL_ARRAY_BUFFER, vboIndex[2]);
   
    
    [glProgram useProgram];
    GLuint a_position = [glProgram attribute:@"a_position"];
    GLuint texture_coord = [glProgram attribute:@"a_texCoord"];

//    GLuint u_projection = [glProgram uniform:@"u_pMatrix"];
//    GLuint u_modelView = [glProgram uniform:@"u_mvMatrix"];
    GLuint u_sample = [glProgram uniform:@"s_texture"];
    
     glUniform1i(u_sample, 0);
    GLuint u_color = [glProgram uniform:@"u_multiplyColor"];
    
    glUniform4f(u_color, 0.0, 0.4, 1.0,0.5);
    
    // 2. set glsl data
//    NSLog(@"%ld %ld",sizeof(float),sizeof(GLubyte));
       
    glEnableVertexAttribArray(a_position);
    glEnableVertexAttribArray(texture_coord);
   
   
  
    glVertexAttribPointer(a_position, 3, GL_FLOAT, GL_FALSE, 0, 0);
    glVertexAttribPointer(texture_coord, 2, GL_FLOAT, GL_FALSE, sizeof(texturecoords),0);
//    glVertexAttribPointer(texture_coord, 2, GL_FLOAT, GL_FALSE, 0, 0);
    //6.texure handler
//    glVertexAttribPointer(texture_coord, 2, GL_FLOAT, GL_FALSE, vboIndex[1], 0);
    
    [texture useTexture];
    __error = glGetError();
    if(__error) printf("texture_coord error 0x%04X in %s %d\n", __error, __FUNCTION__, __LINE__);
   
    glDrawElements(GL_TRIANGLES, sizeof(indices)/sizeof(indices[0]), GL_UNSIGNED_BYTE, 0);
     __error = glGetError();
    if(__error) printf("OpenGL error 0x%04X in %s %d\n", __error, __FUNCTION__, __LINE__);
    [[EAGLContext currentContext] presentRenderbuffer:GL_RENDERBUFFER];
}

// Add new method before init
- (void)setupDisplayLink {
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    glDeleteBuffers(3, vboIndex);
    [glProgram release];
    [glView release];
    [texture release];
    [super dealloc];
}
@end
