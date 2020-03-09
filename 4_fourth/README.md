# Chapter 4: MetaLinguistic Abstraction #

## Notes ##

- Exercise 4.9: Kind of easy but I did not do all of it (just implemented the while construct, so I have until, do, and while remaining) but I decided not to do them because I did not want to sink that much time for something that I probably wont learn much from ... maybe later tm
- Exercise 4.10: This looks like a waste of time, skipping ...
- Exercise 4.12: I think I should redo this exercise ASAP, I was just too tired and sleep-deprived to use my noggin well.
    **Edit**: Gave in the temptation to do it the very nest day...
- Exercise 4.13: I just straight up skipped this.

- Exercise 4.16:
```
Struggled with this one a lot, not besause the syntax transformation was hard
or anything, I meam there was a trick to it (remember that little fallacy you
made where you did not consider the fact the the variable could be a
procedure), but it was rather simple in the end.  What was realy tricky for me
was that I didn't recognize that my intial way of doing it was mistaken (see
two commits prior to this one), because apparently I needed to nest what I
wrote in yet ANOTHER pair of parens.

I want to make it clear that I realized this after I saw the solution online.
I was initially confused and didn't understand ehy that fixed it, then after
carefully running the code (in my head) I think I understand whats going on:

So, just as a reminder to my future self: `unbound variable let` was the error
message I recieved.

Also remember that when apply applies a compound procedure, it sequentially
evaluates the statements in the body, so, given that let is in the body, it
gets evaluated, as in, the symbol `let` gets evaluated on its own, and since it
is a symbol, the evaluator tries to lookup the variable called `let`, of course
it doesn't find it, so it complains.

However, by adding the application parens the specific line in the evaluator
that takes care of this is the `eval (operator exp) emv`, *it evaluates the let
expression*, thereby producing the code that is to be evaluated. And produces
the expected result.

Thank you for coming to my TED talk.  ```

- Exercise 4.31: Skipping for now, but YOU NEED TO COME BACK AND TRY THIS.
