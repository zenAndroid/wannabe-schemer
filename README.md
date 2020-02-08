# Scheming
![Structure and Interpretation of Computer Programs](SICP.jpg "SICP banner")
Working through Structure and Interpretation of Computer Programs.

This repo is noe=w being simultaneasly posted to [GitLab](https://gitlab.com/zenAndroid/scheming-sicp) and [GitHub](https://github.com/zenAndroid/wannabe-schemer).
Occasionally jotting down my thoughts about the material.

Using vim, when i get stuck i go to DrRacket.

I have a question though, how do i tell the `racket` executable that i want a specific extension of some language ??

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

Need to see if i can actually, ... You know ... *USE* this thing instead of just implementing encoders/decoders that take/spit out a list of symbols .... :weary:

In particular, need to pass the encoding function a *string*, not *a list of symbols* because i cant automate that.

#### YES, USE STRING->SYMBOL ####

Why didn't i think if that beforehand :sweat_smile:

### Data-directed programming ###

I think I understand the general concept, but I think it's still fuzzy in my mind.

Might be due to the fact that i didn't do the exercises ...

### New types vs New operations ###

Hmm, this is some vague bullshit, i understand it somewhat but need to revisit

Message-passing vs Data-directed method.

### Section 2.5 : Generic operations (YET AGAIN) ###

Exercises 2.82, 2.83, 2.84, 2.85, 2.86

Seem somewhat complicated, and seem like the "extension-type" exercises that give you deeper understanding of the topic. 

### This paragraph in the section of type coercion (type casting) ###
...Yeah ... I might ... Fiddle with this ...

This coercion scheme has many advantages over the method of defining explicit cross-type operations, as outlined above. Although we still need to write coercion procedures to relate the types (possibly n 2 procedures for a system with n types), we need to write only one procedure for each pair of types rather than a different procedure for each collection of types and each generic operation.117 What we are counting on here is the fact that the appropriate transformation between types depends only on the types themselves, not on the operation to be applied. 

### Exercises about the polynomials ###

Did exercise 2.87, not particularly difficult.
Exercise 2.89 and 2.90 truly don't interest me, seems like way too much effort for the same rational/polar shenanigans.
Exercise 2.88 and 2.91 sound neat, maybe ill do it later.

Honestly I'm pretty tired from this chapter ...

The extended exercise on rational function will probably also have to wait until later when (if) ill be revisiting this.

# 2020-01-24: Ugh, this chapter was a lot of work #

Anyways, the last exercise doesn't work, i think I'm not going to spend much time with this any longer as it just isn't worth the trouble anymore.

Maybe I'll get back to it way later after i finish the book, but most likely I'll just skip it and return to it independently sometime in the far future.

I'm just tired of my insistence on doing all of the exercises, hope i get better with this obsessive compulsive behavior.

This chapter was a lot of work, at the end it got a bit too repetitive and just a bit too much to track.

I am comforted by the fact that i do not seem the only one to have this sort of opinion.

Finally i can rest ...

Although to be clear, the educational content of this chapter was properly mind-blowing to me, i was just starting a list to enumerate the various concepts gone through but then i stopped because i realized that I'd be listing the table of contents at that point.

There were points were i simply didn't like the approach taken by the book however (my main gripe is with the put/get function in the data directed programming (sections 2.4 to 2.5), not only was it low-key in-actionable because you couldn't run the examples to get a better understanding , which resulted in a host of problems like people posting their "solutions" without checking that they worked {SPOILER ALERT, most of them don't}(as actually writing the code is better than passively reading it), but implementing this entire operations-type table is completely do-able, I've done just that!

So i don't really know why they went and introduced this weird *mutable* thing that sticks out like a sore thumb and ruins the way you reason about the program ...

But either way, the concepts were neat, and if only for providing more concrete feedback on why i thought the material in sections 2.4 and 2.5 was wonderful is that it explains in easy terms how remote things like data dispatch nd type casting can be achieved using rather easy to understand constructs.

I am under no illusion that this is exactly how type coercion works for instance, the same way i am under no illusion that the number used in programming languages are built up using church encoding, but it does explain how they can be achieved using basic components which is the entire point as i understand it.

# On chapter 3 #

I have just finished exercise 3.7

Things are looking pretty interesting, however i think im going to skip the next ecercise, like i get the point that the order of evaluation matters, so i wont waste the time doing the exercise, i dont think its too hard eitherway.

A couple of seconds after writing that, i suddenly decided to give it a shot.

- **Exercise 3.25** : TODO : Dunno why but my brain juat couldn't concentrate enough for it.
Also im skipping exercise 3.26 for now, just deosnt seem vry interesting.

The next exercise however, i might fiddle with a bit.

## Note ##

There are still a number of individual exercises that i will record for posterior practice.

Particularly, i will probably revisit the exercise i skipped at some point.

Also note that there are a bunch of folders that start with 2-80...

Those are when i was frustrated with the use of a mutable data structure so i rolled my own immutable version.

I then started doing all the other exercises i skipped.
