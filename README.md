# Scheming

Working through Structure and Interpretation of Computer Programs.

Using vim, when i get stuck i go to DrRacket.

I have a question tho, how do i tell the `racket` executable that i want a specific extension of some language ??

IE how to translate `#lang scheme` to the racket executable ?

# ToDo #

There are couple of things i should note (as of 2019-04-12)
    - I will redo some exercises that are more on the challenging side, because i want the full experience TM.
    - I will list them soon.

## Important sections of the book I've seen so far ##

Here are :
- Some of the sections i have either skipped because they were too hard for me at the time.
- Still hard for me RN.
- Sections that i completed but that are about concepts important enough for me to redo them.
- Sections i liked.

### Square roots by newton's method ###

### 1.2.3 Orders of Growth ###

### 1.2.6 Testing for optimality ###

### 2.1.4 EXTENDED EXERCISE : INTERVAL ARITHMETIC ###

 This one particularly spooked me, dunno if it was warranted or not

### Symbolic differentiation ###

Which, coincidentally, i am working on at the moment of writing this (2019-04-12 14:58)

### Sets as trees ###

And all of the trees shenanigans

### HUFFMAN TREES ###

Need to see if i can actually, ... you know ... *USE* this thing instead of just implementing encoders/decoders that take/spit out a list of symbols .... :weary:

In particular, need to pass the encoding function a *string*, not *a list of symbols* because i cant automate that.

#### YES, USE STRING->SYMBOL ####

Why didn't i think if that beforehand :sweat_smile:

### Data-directed programming ###

I think I understand the general concept, but I think it's still fuzzy in my mind.

Might be due to the fact that i didn't do the exercises ...

### New types vs New operations ###

Hmmm, this is some vague bullshit, i understand it somewhat but need to revisit

Message-passing vs Data-directed method.

### Section 2.5 : Generic operations (YET AGAIN) ###

Exercices 2.82, 2.83, 2.84, 2.85, 2.86

Seem somewhat complicated, and seem like the "extension-type" exercises that give you deeper understanding of the topic. 

### This paragraph in the section of type coercion (type casting) ###
...Yeah ... i might ... fiddle with this ...

This coercion scheme has many advantages over the method of defining explicit cross-type operations, as outlined above. Although we still need to write coercion procedures to relate the types (possibly n 2 procedures for a system with n types), we need to write only one procedure for each pair of types rather than a different procedure for each collection of types and each generic operation.117 What we are counting on here is the fact that the appropriate transformation between types depends only on the types themselves, not on the operation to be applied. 

### Exercices about the polynomials ###

Did exercice 2.87, not particularly difficult.
Exercice 2.89 qmd 2.90 truly don't interest me, seems like way too much effort for the same rational/polar shenanigans.
Exercice 2.88 and 2.91 sound neat, maybe ill do it later.

Honestly im pretty tired from this chapter ...

The extended exercice on rational function will probably also have to wait until later when (if) ill be revisiting this.

## Note ##

There are still a number of individual exercises that i will record for posterior practice.

Particularly, i will probably revisit the exercise i skipped at some point.

Also note that there are a bunch of folders that start with 2-80...

Those are when i was frustrated with the use of a mutable data structure so i rolled my own immutable version.

I then started doing all the other exercices i skipped.
