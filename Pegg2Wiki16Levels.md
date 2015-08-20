#Getting 16 gray levels on Peggy 2.0

# Introduction #

As a Peggy 2.0 builder I didn't quite understand at first how to get 16 gray levels out of the LEDs in spite of looking WIndell's example code so thought I would see if I can explain it.

# Details #

Unlike light bulbs, LEDs are bianry devices - they are on or they are off. So how can you make one LED look "brighter" or "dimmer" than another? The answer comes from a curious fact of the human vision system called [persistence of vision](http://en.wikipedia.org/wiki/Persistence_of_vision). If you flash an LED on for, say 30 ms, and one beside it for 10ms and you do that 20 times per second, your eye will blur that fast flashing into think the one LED is 3 times brighter than the other.  This technique is usually called [pulse-width modulation](http://en.wikipedia.org/wiki/Pulse-width_modulation).  In the 16 level example code for the Peggy 2.0, the control over the brightness of each frame buffer, which controls which LEDs are on or off, are set to 8, 4, 2, and 1 repeats respectively. So LEDs turned on in frame buffer 0 will be brighter by virtue of being on 8 times longer than those turned on in frame 3, which are on 1/8 as long.  Note that being on 8 times longer doesn't necessarily mean it is 8 times brighter, but you can clearly see that there are 4 different brightnesses this way.

So how then do you get the other levels? By enabling the LEDs in more than one of the 4 frame buffers at a time. So the brightest LED will be on the longest, that is 8+4+2+1 times, while the next brightest would not be enabled in the 3rd frame buffer, so would only display 8+4+2 times, a small difference for sure, but enough to enable 16 different levels of brightness.

The example code peggy2\_qix.pde uses this technique to make a moving LED with a tail of decreasing brightness.