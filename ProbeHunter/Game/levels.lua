-- p = player, w = wall, x = goal, e = enemy, b = bugEnemy, ^ = windPlant, $ = drone, s = spike
local levels = {
[[
w                  w
w                  w
w                  w
w                  w
w                  w
w                  w
w                  w
w         t        w
w                  w
w                 cw
w                 ww
w                 ww
w                 ww
w  p             www
w                www
w    c        c  www
wwwwwwwwwwwwwwwwwwww
wwwwwwwwwwwwwwwwwwww
wwwwwwwwwwwwwwwwwwww
wwwwwwwwwwwwwwwwwwww
]],


[[
ww p  wwwwwwww   -   wwwww
ww    wwwwww          wwww
ww     wwwww           www
w      wwww              w
w        dd              w
w        dd              w
w       |dd              w
w        dd c            w
w  c     dd w            w
wwwwwwwwwwwww            w
wwwwwwwwwwwww            w
wwwwwwwwwwwwwddddddddddddw
wwwwwwwwwwwwwddddddddddddw
wwwwwwwwwwwww            w
wwwwwwwwwwwwww           w
wwwwwwwwwwwwww          cw
wwwwwwwwwwwwww          ww
wwwwwwwwwwwwwww        www
wwwwwwwwwwwwwwwww  x wwwww
wwwwwwwwwwwwwwwwwwwwwwwwww.
]],

[[
ww    wwwwwwwww   -  wwwwwwwwwwwwwww
w      ww    ww      wwwww         w
w      ww    ww      wwwww         w
w      ww    ww      wwwww         w
w       w    ww      wwwww         w
w       w     w      w             w
w       w     w     ww             w
w      cw    cw     dd  |          w
w      ww    ww     dd    c      x w
w      dd    dd     dd  www     wwww
w      dd    dd     dd             w
w      dd    dd     dd             w
w      dd    dd     ww             w
w      dd    dd     ww             w
w p    dd    dd     ww             w
w c    dd    dd     ww             w
wwww   dd    dd     ww             w
wwww   dd    dd     ww             w
wwww                ww             w
wwww                ww             w.
]],

[[
wwwwwwwwwww          wwwwwww
wwww                  p  www             wwwww
www                   c  www             wwwww
ww             c      w  www              wwww
ww          wwww      w  www              wwww
w          wwwww         www               www
w         wwwwww      | wwww               www
w          wwwww        wwww               www
w             wwwwwwwwwwww                  ww
w                  wwwww                    ww
w             |    wwwww                     w
w                  ww                        w
w             c    ww                       |w
w            ww    ww                        w
w            ww -  ww                    x  ww
ww c         ww                        wwwwwww
wwwwww       ww                c       wwwwwww
wwwwww       ww   c|         www       wwwwwww
wwwwwww      wwwwwwwww        ww       wwwwwww
wwwwwwwwwwwwwwwwwwwww         ww       wwwwwww.
]],

[[
wwwww                     wwwwwwwwwwwwwwwwww
wwwww                      wwwwwwwwwwwwwwwww
wwww                       wwwwwwwwwwwwwwwww
wwww                        wwwwwwwwwwwwwwww
ww                          wwwwwwwwwwwwwwww
ww                           w    wwwwwwwwww
ww                           w   -wwwwwwwwww
w                            w    wwwwwwwwww
w                                 wwwwwwwwww
w                                 wwwwwwwwww
w                                 wwwwwwwwww
w                                  w   -  ww
wdddddd                            w      ww
w     d                            w      ww
w     d                            w       w
w     d                            w       w
wp    d                   c        w       w
wwwwwww                   w        |       w
wwwwwww                 e w        e    x  w
wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww.
]],

[[
wwwwwwww                 
wwwww                    
www                      
www                      
ww                       
ww                       
ww                       
w                        
w                        
w                        
w                       w
w                       w
w                       w
w                     x w
w                    wwww
w      c      w  e   wwww
w      w    e wwwwwwwwwww
w p    wwwwwwwwwwwwwwwwww
wwwwwwwwwwwwwwwwwwwwwwwww
wwwwwwwwwwwwwwwwwwwwwwwww.
]],

[[
wwwwww           www
wwww              ww
www               ww
www                w
ww               x w
ww             wwwww
ww             wwwww
w                  w
w                  w
w                  w
w                  w
w                  w
w     c            w
w    www         e w
w  - www  ^  wwwwwww
w    wwwwwwwwwwwwwww
w -  wwwwwwwwwwwwwww
w    wwwwwwwwwwwwwww
w p^ wwwwwwwwwwwwwww
wwwwwwwwwwwwwwwwwwww
]],

[[
wwwwwwwwwwwwwwwwwwww
w              wwwww
w  ww           wwww
wwwwwx           www
wwwwwww -      - www
wwwwwwwwwc        ww
wwwwwwwwww-      -ww
www                w
w                  w
w                  w
w                  w
w                  w
w                  w
w                  w
w               ^  w
w              wwwww
w                www
w                  w
w p ^          |  |w
wwwwww             w
]],

[[
wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
wwwww        wwwwwwwwwwww   wwwwwwwwwww
ww             wwwwwwww        wwwwwwww
w                wwcww          wwwwwww
w                 www            wwwwww
w                  w               wwww
w                  w               wwww
w                  w               w ww
w                  w               w ww
w                  w               w  w
w                                  wc w
w                                  wwww
w                                     w
w                                     w
wp   c                             |  w
wwwwwww            b                 xw
wwwwwww            c              cbwww
wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww.
]],

[[
w                        w
w                        w
w                        w
w                        w
w                        w
w                        w
w                        w
w                        w
w                        w
w                        w
w                        w
w                        w
w                        w
w p       ww   c    c   !w
wwwww     ww   wwwwwwwwwww
wwwww     ww   wwwwwwwwwww
wwwww     ww   wwwwwwwwwww
wwwww     ww   wwwwwwwwwww
wwwww     ww   wwwwwwwwwww
wwwww     ww   wwwwwwwwwww.
]],

[[
wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
wwwww            wwww       wwwwwwwwwww
ww                www          wwwwwwww
w                 www           wwwwwww
w                 ww             wwwwww
w                 ww               wwww
w                                  wwww
w                                  wwww
w                                  wwww
w                                     w
w                                     w
w                                     w
w                                     w
w                           c       b w
w                  b        www      xw
w                  c        www  -  www
wp          c     ww - ww - www     www
wwwww     www  -  ww        www     www
wwwww  -  www     ww        www     www
wwwww     www     ww        www     www.
]],



[[
wwwwwwwwwwwwwwwwwwww
w              wwwww
w                www
w                  w
w p                w
wwwww              w
wwwww     sc e     w
wwwwwwwwwwwwww     w
wwwwwwwww          w
w                  w
w                  w
w                 sw
w            sss cww
w            wwwwwww
w            wwwwwww
w            wwwwwww
w            wwwwwww
wss          ww    w
www c sssssssss  ! w
wwwwwwwwwwwwwwwwwwww
]],

[[
        wwww        wwww      w
        wwww        wwww      w
        wwww        wwww      w
        wwww        wwww      w
         ww         wwww      w
w        ww          ww       w
w                             w
w                             w
w                     b       w
w                             w
ww                            w
ww                            w
www       b   c       d  c  x w
wwwwp         wwww       wwwwww
wwwwwww       wwww   ss  wwwwww
wwwwwww       ww     ww  wwwwww
wwwwwww  ss   ww     ww   wwwww
wwwwwww  ww   ww    sww   wwwww
wwwwwww  ww   ww    www   wwwww
wwwwwww  ww   ww    www   wwwww.
]],



[[
wwwwwwwwwwwwwwwwwwwwww
w                           w
w                           w
w       c                   w
wxc     d         d         w
www    d         ddd        w
w     b w   c    d d        w
w           dddddc    w     w
w                d    wc    w
w     c               ww  - w
w     d                     w
w                     |    ww
w                     c    ww
w                     ww  -ww
w                      w   ww
w     d       d        w  cww
w    cd       d        w  www
w    dsd     d d b        www
wpc  dwd     d d c    c|  www
www              w    wwwwwww.
]],

[[
wwwwwwwwwwwwwwwwww  
wwwwwww             
wwwww               
www   |  |          
www x     c         
wwwwwwwwwww         
wwwwwwwwwww         
wwwwwwwwwww         
www       w     b   
www       w     ^   
www    |  w     w   
www    b  w         
www    c  w         
www   -w  w         
www    w            
www    w            
www    w     ^      
w      w    www     
wp  ^  w   cwww     
wwwwwwww-  wwwwwwwww
]],


[[
wwwwwwww        wwwwwwwwww
wwwwwww           wwwwwwww
wwwww             wwwwwwww
ww                     www
w                 |      w
w                 c!     w
w                 ww    cw
w                       ww
w                       ww
w                       ww
w                      www
w                      www
w                      www
w                     wwww
w                     wwww
w                    cwwww
wp               $   wwwww
wwwww                wwwww
wwwww   c            wwwww
wwwwwwwwwwwwwwwwwwwwwwwwww.
]],

[[
wwwwwwww        wwwwwwwwww
w                        w
w                        w
w                        w
w                        w
w                        w
w                        w
w                        w
w                        w
w                        w
w                      $ w
w                        w
w             $ c    x   w
w               dddddwwddw
w               dd       w
w   p           dd       w
wddddddddddddddww        w
wdddddddddddddd          w
w                        w
w                        w.
]],

[[
wwwwww            wwwwwwww       
www                  www         
ww                               
w                     $          
w                     c          
w p           c      www         
wwwww  ddddddddddd   www         
wwwwwss     sssssssssww          
wwwwwwwssssswwwwwwwwwww          
wwwwwwwwwwwwwwwwww               
wwwwwwwwwwwww                    
wwwwwwwwwww                     s
wwwwwww                         w
wwwwww   $                      w
wwwwww   $                      w
wwwwww  c$         $            w
wwwwwwwww$                      w
wwwwwwwww$         x          c w
wwwwwwwww$  ddddddwwdddddd   wwww
wwwwwwwww                       w.
]],


[[
w                                           wwwwwwwwwwwwwwwwwwww     c  w
w                                                                    d  w
w                                                    |               $  w
w                                                     c              $  w
w                                                    www             $  w
w                                                     wwww           $e!w
w                                                       wwwwwwwwwwwwwwwww
w                                                     |       wwwww
w                                                       c     www
w                                           w^     ewwwww     www
w                                           wwwwwwwwwwwww  -  wwwww
w                            $                    ww          wwwww
w                                                             wwwww
w                                 $                |          wwwwwwww
w p            ww   c                             c           wwwwwwwwwww
w c        c   ww   ww                         b  ww          wwwwwwwwwww
w w   w   ww   ww   ww    c              c        ww    e   ^ wwwwwwwwwww
w w   w   ww - ww   ww    wwww    www   ww    ww -wwwwwwwwwwwwwwwwwwwwwww
w w   w   ww   ww   ww  - wwww    www   ww  - ww  ww          wwwwwwwwwww
w w   w   ww   ww   ww    wwww    www   ww    ww              wwwwwwwwwww.
]]
}

local testLevels = {
    
[[
wwwwwwwwwwwwwwwwwwww
w                  w
w                  w
w                  w
w                  w
w                  w
w                  w
w                  w
w                  w
w                  w
w                  w
w                  w
w                  w
w                  w
w                  w
w                  w
w                  w
w                  w
w p   c  ! c     x w
wwwwwwwwwwwwwwwwwwww
]],
    
    
[[
wwwwwwwwwwwwwwwwwwwwwwwwwwww
w          w       w       w
w          w       w       w
w          w       w       w
w                  w       w
wp                         w
ww                         w
wwc     c  w               w
wwwwwwwwwwww       c       w
wwwwwwwwwwwwsc  e bw       w
w          wwwwwwwww      bw
w                   dddddddw
w                   d      w
w       c           d   c sw
w      ww           d  wwwww
w x c eww                  w
wwwwwwwww                  w
wwwwwwwww                  w
wwwwwwwww ^   ww           w
wwwwwwwwwwwwwwww           w.
]]
};

--levels = testLevels;
return levels;