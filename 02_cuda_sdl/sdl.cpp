#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>
#include <SDL/SDL.h>
#include <SDL/SDL_keyboard.h>

int testfunc(void);

int main(int argc, char *argv[])
{
    testfunc();
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

    bool quit=false;
    while(!quit) {
/*	for(size_t k=0; k<320*256; k++)
		{
			uint16_t c=frame16[k];///65536;
			c=(uint8_t)(c>>8);
			uint32_t color=SDL_MapRGB(scr->format, c,c,c );
			bufp[k]=color;
		}
*/
	SDL_Flip(scr);

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

    }
    return 0;
}
