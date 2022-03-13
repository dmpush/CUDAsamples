#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include<unistd.h>
#include <math.h>
#include <SDL/SDL.h>
#include <SDL/SDL_keyboard.h>
#include <ctime>
int fractal(short *, float,float, float,float, float,float);

int main(int argc, char *argv[])
{
    short *img=new short[1024*1024];
    atexit(SDL_Quit);
    if(SDL_Init(SDL_INIT_VIDEO)<0)
	{
		printf("Cant init video\n");
		return -1;
	}
    SDL_Surface *scr;
    scr=SDL_SetVideoMode(1024,1024,32, SDL_HWSURFACE|SDL_DOUBLEBUF ); //|SDL_NOFRAME |SDL_RESIZABLE
    if(scr==NULL)
	{
		printf("Cant set videomode 320x256x32\n");
		return -2;
	}
    uint32_t *bufp=((uint32_t*)scr->pixels);

    bool quit=false;
    float dx=1;//000;
    float dy=1;//000;
    double t=0;
    while(!quit) {
	std::clock_t start=std::clock();
	fractal(img, 0,0, dx,dy, -0.74543, 0.11301);
//	fractal(img, 0,0, dx,dy, 0.75395*cos(2.0*M_PI*t)*log(1.0+t),0.75395*sin(2.0*M_PI*t)*log(1.0+t));
	std::clock_t stop=std::clock();
	printf("et=%f\n", (double)(stop-start)/(double)CLOCKS_PER_SEC);
	for(size_t k=0; k<1024*1024; k++)
		{
			uint16_t c=img[k];///65536;
			c=(uint8_t)(c>>8);
			uint32_t color=SDL_MapRGB(scr->format, c,c,c );
			bufp[k]=color;
		}

	SDL_Flip(scr);
	dx*=0.99;
	dy*=0.99;
//	dx*=1.01;
//	dy*=1.01;
	// обработка нажатий клавиатуры
	SDL_Event event;
	while(SDL_PollEvent(&event)) {
		if(event.type==SDL_KEYDOWN)
			switch(event.key.keysym.sym) {
				case SDLK_ESCAPE:
					quit=true;
					break;

				default:
				break;
			};
	};
	t+=+1e-4;
    }
    return 0;
}

