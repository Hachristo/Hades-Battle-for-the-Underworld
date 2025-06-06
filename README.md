# Hades: Battle for the Underworld  
  
**Programming Patterns Used**  
I used the state pattern for the cards; cards have 3 seperate states: idle, mouse_over, and grabbed. This makes it much easier to keep track and update how each
card should work when interacted with, rather than having to check elsewhere or invoke a lengthy list of conditionals in place, I can simply check the 
state to decide what should happen.

I decided to use the subclass sandbox pattern to implement the various special effects of the cards. Each card subclass has a unique onReveal function to
accomplish the special properties tied to each card. This implementation reduces the amount of redundant code that would be necessary if I were to write
entire classes for each type of card. Instead, I can use the general functions I already wrote for the card class and customize what makes each card unique
more easily

**Postmortem**  
Implementing the subclass sandbox introduced a bug where creating duplicate cards would overwrite existing cards of the same type in the table of cards kept
in main. It took the better part of a day to figure out how to resolve this; the solution ended up being to change the new() function in each of the subclasses
to return a new instance of CardClass with the __index metamethod of the subclasses being set to the associated subclass prototype. This was necessary in order 
to have a new card built off the prototype each time it was called while also being able to call the onReveal() function unique to each subclass. In retrospect, 
I think the component pattern might have been an easier way of implementing this functionality. I imagine I could write unique components for each of the special 
effects of the cards, and attach them to the cards as they are created.

**Asset List**  
Card Back Sprite: https://kenney.nl/assets/playing-cards-pack