______ _                            ___      _                               _   
|  ___| |                          / _ \    | |                             | |  
| |_  | | ___  _ __  _ __  _   _  / /_\ \___| |_ _ __ ___  _ __   __ _ _   _| |_ 
|  _| | |/ _ \| '_ \| '_ \| | | | |  _  / __| __| '__/ _ \| '_ \ / _` | | | | __|
| |   | | (_) | |_) | |_) | |_| | | | | \__ \ |_| | | (_) | | | | (_| | |_| | |_ 
\_|   |_|\___/| .__/| .__/ \__, | \_| |_/___/\__|_|  \___/|_| |_|\__,_|\__,_|\__|
              | |   | |     __/ |                                                
              |_|   |_|    |___/                                                 
By: María Fernanda Flores Luna (162064) & José Antonio Solís Martínez (162442)
For the course P21-LIS3092-1 LABORATORIO DE VIDEOJUEGOS
Ascii art created using: 
https://patorjk.com/software/taag/#p=display&f=Doom&t=Floppy%20Astronaut

This is a modification of the Flappy Bird game found in: 
https://github.com/games50/fifty-bird

Description:
Flappy Bird is a game where a you controll a little bird and try to make it go
through pipes, where each pipe you cross gives you a point. Coliding with the
ground or pipes makes you start from the beggining. The goal is to get the 
maximum score that you can, with no real end to the game.

Floppy Astronaut follows this idea; you are an astronaut stranded in an alien
world and need to avoid the aliens while you are looking for a really cute 
marshmallow. The aliens have tentacles that they use to try to catch you.  

State Machine:
                 ┌────────┐
    ┌────────────┤champion◄────────┐
    │            └────────┘        │
    │ space                        │marshmallow
    │                              │
    │                              │
┌───▼─────┐                      ┌─┴─────┐
│starting ├──────────────────────►playing│
└───▲─────┘        space         └─┬─────┘
    │                              │
    │                              │
    │ space                        │collision
    │            ┌───────┐         │
    └────────────┤finish ◄─────────┘
                 └───────┘
Diagram created using: https://asciiflow.com/#/

The game starts in the "starting" state, then it moves to the "playing" state 
when the user presses the space bar. From the playing state, if the astronaut
collides with a tentacle or the ground, we will move to the "finish" state; but
if the astronaut manages to collect the marshmallow, we will move to the
"champion" state and win the game. From both the "champion" and "finish" 
stages we can press space to go to the "starting" stage and play again.

Structure:
/Font - Where the font used by the game is stored
/Images - Where we store all the images for the game
/Music - Where the music of the game is stored
/Sounds
    /Floor - Sound effects for when the astronaut hits the floor
    /Propulsor - Sound effects for the astronaut going up
    /Score - Sound effects for goingh between two tentacles
    /Tentacle - Sound effects for when the astronaut touches a tentacle
bird.lua - Class for the behaviour and data of the astronaut
class.lua - Library that adds the Class functionality
conf.lua - Only was used for debugging
main.lua - Where all the classes are called and the complete behaviour of the game
            is found
pipe.lua - Class for the data and behaviour of a single tentacle
pipePair.lua - Class that creates two tentacles and sets them in the correct
                position (one on top, one on the bottom)
push.lua - Library that implements the visual resolution (for pixelated effect)
README.txt - This file

Modifications:
This is a list of the modifications that were done to the game. At least the ones
we can remember. They aren't in any order.
    Custom background
    Custom ground
    Custom bird (astronaut)
    Custom pipes (tentacles)
    Tweak the values of the gravity and separation of the pipes
    Add a scoring system (shows how many points you have)
    Add a highscore system
    Starting screen 
    Music for the starting and playing stages
    When you lose, you get a text with how many points you got
    If you got a highscore, you get an image of a trophy
    A system for winning the game
    Sound effects for crashing to the ground, touching a tentacle, flying, and
        scoring
    Different screen for when you win ("champion" state)
    ...And many many more!!

References:
https://patorjk.com/software/taag/#p=display&f=Doom&t=Floppy%20Astronaut
https://github.com/games50/fifty-bird
https://asciiflow.com/#/