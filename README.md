Hey Buzz, welcome to your OpenTable assignment.

The goal of this exercise is to test a bit your UIKit abilities, so your task is do our job, and build the upcoming reservation view, also known as "dining mode" internally.
There are 2 aspects to this:

- first, the "dining mode banner". That's an apple music-like banner, that inserts itself above the tab bar, and can be interactively pulled
- second, the dining mode itself. This is a "card" oriented view of your upcoming reservation.

### Dining mode banner
The requirement for this one is pretty simple:

- a banner should be displayed above the tab bar
- tapping the banner expands the upcoming reservation view controller full screen
- the banner can also be dragged interactively, and the upcoming reservation is visible in the dragged view (e.g. exactly what Apple Music does)
- whichever tab is selected, the banner should be visible. If a controller gets presented modally, the banner should NOT be visible (matching the implicit real life analogy that modals slide "over" the main view)

Here's a sample GIF from our current app:
![Dining mode banner](https://d1zjcuqflbd5k.cloudfront.net/files/acc_225157/tgCj?response-content-disposition=attachment;%20filename=Screen%20Capture%20on%202016-12-02%20at%2016-30-28.gif&Expires=1480726021&Signature=U6zXG9fnqvuxBJijX5N6zjqVJL3NZpxNlD3dtQsC1RFc~cvwPw9vduW1tiyB3xeZpGga0WFz0LZE3qyYXvGdzDIA5GEGBLAZ~YOd4bNrp6eupfwlCk7~Mi2g-ldicE~qQ0BoqATay8Y5~vJCORZRN6xIqKzY9tQC~G4NPkpwsLk_&Key-Pair-Id=APKAJTEIOJM3LSMN33SA)

### Dining mode
This is a typical "mix and match" content driven screen, laying out "cards" vertically, where not all of the content is always available:

- First card lists the restaurant name, the reservation time, the party size, and includes a picture of the restaurant
- Second card lists the restaurant address, and a map view with the restaurant's address
- Third card is the "best dishes" feature: an optional list of 1 to 3 dishes, along with a review snippet, where mentions of the dish are bolded out. Some ground rules about dishes:
	* A dish has at least one photo, and exactly one snippet
	* A snippet holds the full review, a range which indicates which part should be displayed, and a list of highlight ranges. All the ranges are relative to the full review (e.g. a highlight with at 197, 8 means "8 characters starting from the 197th character in the full review", regardless of which range of the review should be displayed)
	* if the restaurant has no dishes, the card should not be shown
	* if the restaurant has more than 3 dishes, only the first 3 should be shown
	* each dish is guaranteed to have at least one picture, and one review snippet
	* for each displayed snippet, we want to display: the photo, the dish name and the snippet along with its highlight. You're free to pick whatever method for the highlight (bold, color, underline etc.)
	* If you feel like it and have enough time, tapping anywhere in the card expands the card full screen. If you don't have time for it, that's ok, but I'd love it if you could explain an approach to implement this kind of transition, and the problems you'd face in the process.

Here's a sample GIF from our current app:
![Dining mode](https://d1zjcuqflbd5k.cloudfront.net/files/acc_225157/tgCj?response-content-disposition=inline;%20filename=Screen%20Capture%20on%202016-12-02%20at%2016-30-28.gif&Expires=1480725974&Signature=AZByt90WX1pPQihkTfraK6w1xvEeY9zSy-bm-enF5T0tHJ9Z0Bo~fga33KKNcV8isjojTtGqg-MI2~KTFTCjFuk7VQYw-FOPx84aAdhsHsuHAf4jCZ400oPmpelkgKZxwx24yCLY9-Mj4ByJaYf0srdrPQEmyil6GlX~P~jobDg_&Key-Pair-Id=APKAJTEIOJM3LSMN33SA)

### General Instructions:
- this isn't a visual design exercise, so you don't have to worry about that piece. Subtle use of background colors helps a lot with debugging and differentiating the views, so feel free to use that technique freely. I've included GIFs from our own app, as a reference, you don't have to follow that visual design
- You'll find some code under Vendor/ – I've put basic domain objects in there, a reference JSON file, and assembler code to build up the domain object from the JSON object.
- I do realize there's a lot in this exercise. If you can't wrap it all up, explain why you prioritized something over something else, and if you have a rough plan on how to implement the remaining
- It's friday, and I just put this thing together. I hope the assembler code is bug free, if it isn't, ping me at [github handle] @ the company, I'll do my best to answer
- Xcode is force feeding swift 3 on me. So Swift 3 it is (unless you feel like updating the Assembler class to swift 2.3 :p)
- I've included a binary distro of AFNetworking for the image download part, feel free to use it. Or you can stick with raw NSURLSessions if you're more comfortable with that.
