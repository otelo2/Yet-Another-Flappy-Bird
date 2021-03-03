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

This is a modification of the Flappy Bird game found in: 
https://github.com/games50/fifty-bird

Description:
Flappy Bird is a game where a you controll a little bird and try to make it go
through pipes, where each pipe you cross gives you a point. Coliding with the
ground or pipes makes you start from the beggining. The goal is to get the 
maximum score that you can, with no real end to the game.

Floppy Astronaut follows this idea; you are an astronaut stranded in an alien
world and need to avoid the aliens while you are looking for -----XXXXEND CONDITION HEREXXXX---------

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