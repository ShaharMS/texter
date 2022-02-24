# texter

## I'll start with a story

About 5 month ago, just a month after I started programming in haxeflixel, I wanted to make an app that needed text input, specificly of type RTL.

for about 2 months I tried to find some existing (decent) RTL support, but didnt find any that were good enough.

### It was the time I decided to take this duty upon myself - to add more support for text input (in that time - only in haxeflixel)

It might seem like I'm exaggerating, but trust me, it took me a **while** to make progress. but when I did start making (good) progress,
I figured I'm not the only person that needs those fixes, **and thats how and why I created this library.**

### **Can I Help/Contribute?**
Of course! Any help is greatly appreciated! You can help with: 
- fixing bugs
- writing/fixing documentation
- making code more readable/simpler & shorter (don't worry, I think my code is pretty understandable ;) )
- writing code for the library
- adding projects that you think are useful 

And more that pops up in you mind!

# Installation

#### to install the stable version:
```
haxelib install texter
```

#### to istall the newer - but maybe unstable git version - 
```
haxelib git texter https://github.com/ShaharMS/texter.git
```

# Roadmap

My memory is kinda trash, so I thought of making a roadmap for me and you to know whats supported and whats yet to be 
supported (I promise you I need this more than you 😂)

 - ✅ - fully working
 - ❌ - needs implementation
 - ✅❌ - partially complete, probably works but might be wonky
---

## **FlxInputTextRTL**

Reguar FlxInputText with extended support for:
 - All languages
 - Bi-directional text
 - Multilne

| Feature | Works On JS | Works On Non-JS |More Details |
|  :---:  |     :---:   |       :---:     |    :---:    |
| General LTR for LTR languages | ✅ | ✅ | the actual letters/signs being typed |
| General RTL for RTL languages | ✅ | ✅ | the actual letters/signs being typed with the RTL Marker (when needed) |
| LTR Spacebar                  | ✅ | ✅ | the regular `space` character - `" "` |
| RTL Spacebar                  | ✅ | ✅ | the regular `space` character for RTL languages with the RTL Marker |
| LTR Backspace                 | ✅ | ✅ | the regular `backspace` deletion |
| RTL Backspace                 | ✅ | ✅ | the regular `backspace` deletion for RTL languages |
| LTR Delete                    | ✅ | ✅ | the regular `delete` deletion |
| RTL Delete                    | ✅ | ✅ | the regular `delete` deletion for RTL languages |
| LTR Caret                     | ✅ | ✅ | the letter insertion/deletion point |
| RTL Caret                     | ✅ | ✅ | the letter insertion/deletion point|
| Text Auto-Alignment           | ❌ | ✅ | aligns the text inside of the text input according to the direction of the first character |
| Multiline text                | ❌ | ✅ | expands the input verticly and escapes words to the next line|
| Scrolling Single-Line text    | ✅ | ✅ | doesnt expand the input, but moves the text so the caret will be visible |
| Left\Right Arrow Keys         | ✅ | ✅ | used to move the caret between letters/signs |
| Up/Down Arrow Keys            | ❌ | ✅ | used to move the caret between lines. on JS - multiline crashes the app |
| LTR/RTL Enter                 | ❌ | ✅ | forces a new line and makes the caret appear on a side corresponding to the current language |
| LTR WordWrapping              | ❌ | ✅ | when the sentence/word is too long for a multiline text input, some words will be escaped to the next line |
| RTL WordWrapping              | ❌ | ❌ |  when the sentence/word is too long for a multiline text input, some words will be escaped to the next line |
| Unicode BiDi Algorithm (UBA)  | ✅ | ✅ | when a user tries to type in both a LTR language and a RTL language, the text input should be able to handle that correctly with alignments, moving the caret and placing certine unicode characters differently |
| Selection | ❌ | ❌ | when dragging & pressing the mouse across the text, a visual selection background should appear. that background tells you those character could be delted, copied, pasted over/moved |
| Text Copy/Paste | ❌ | ❌ | when pressing `ctrl` + `c` - copy the selected text. when pressing `ctrl` + `v` - paste text from the clipboard |



# About Copying

### You might have noticed that some files look like copies from libs like **OpenFL** or **HaxeFlixel**.
 No, i did not want to do this originally, but some core files had to be modified (because extending those classes didnt work) in order to make things work as expected. You can see I'm fully open about this, because I want those changes to appear in the actual lib's source code, but i dont have time for all of the pull request stuff. I'd be happy to recive help in that department :)