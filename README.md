A very simple clone of wordle.  

## requirements 
- lua >= 5.4
- gcc
- make
- ncurses
- *NIX system recomended (haven't tried on a Windows machine, though I assume you can get it to work with a bit of elbow grease)

## instructions
- before running for the first time, navigate to ./ncurses/ and run the makefile with command ```make``` this only has to be done once.
- run main.lua with ```lua main.lua```

## gameplay
- you must guess a five letter english word.
- you have five guesses.
- type out your five letter guess and press enter.
- the letters of the word you guessed with change colors. this indicates:
  - green
    - this character appears in the word at this location.
  - yellow
    - this character appears in teh word, but at a diffrent location.
  - white
    - this character is not in the word.


### acknowledgment 
I got the list of english words [from here](https://www-personal.umich.edu/~jlawler/wordlist.html)