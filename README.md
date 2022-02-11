# texter



## I'll start with a story

About 5 month ago, just a month after I started programming in haxeflixel, I wanted to make an app that needed text input, specificly RTL.

for about 2 months I tried to find some existing (decent) RTL support, but didnt find any that were good enough.

### It was the time I decided to take this duty upon myself - to add more support for text input (in that time - only in haxeflixel)

It might seem like im exaggerating, but trust me, it took me a **while** to make progress. but when I did start making (good) progress,
I figured I'm not the only person that needs those fixes, **and thats how and why I created this library.**



## Roadmap

My memory is kinda trash, so i thought of making a roadmap for me and you to know whats supported and whats yet to be 
supported (I promise you i need this more then you 😂)

 - ✅ - fully working
 - ❌ - needs implementation
 - ✅❌ - partially complete, probably works but might be wonky
---

### **FlxInputTextRTL**

Reguar FlxInputText with extended support for:
 - All languages
 - Bi-directional text
 - Multilne (Almost!)

| Feature | Works On JS | Works On Non-JS |More Details |
|  :---:  |     :---:   |       :---:     |    :---:    |
| General LTR typing for LTR languages | ✅ | ✅ | the actual letters/signs being typed |
| General RTL typing for RTL languages | ✅ | ✅ | the actual letters/signs being typed with the RTL Marker (when needed) |
| LTR Spacebar  | ✅ | ✅ | the regular `space` char - `" "` |
| RTL Spacebar  | ✅ | ❌ | the regular `space` char for RTL languages with the RTL Marker - need to add RTL spacebar logic on non-JS targets |
| LTR Backspace | ✅ | ✅ | the regular `backspace` deletion |
| RTL Backspace | ✅ | ✅ | the regular `backspace` char for RTL languages |
| LTR Delete    | ✅ | ✅ | the regular `delete` deletion |
| RTL Delete    | ✅ | ✅ | the regular `delete` deletion for RTL languages |
| LTR Caret     | ✅ | ✅ | the letter insertion/deletion point |
| RTL Caret     | ✅ | ✅ | the letter insertion/deletion point|
| Multiline text | ❌ | ✅❌ | expands the input text verticly to match the text size & create a  new line. on non-JS - caret gets stuck on the first line, on JS - implement word wrapping (text moving between the lines) |
| Scrolling Single-Line text | ✅ | ✅ | doesnt expand the input, but moves the text so the caret will be visible |
| Left\Right Arrow Keys | ✅ | ✅ | used to move the caret between letters/signs |
| Up/Down Arrow Keys | ❌ | ❌ | used to move the caret between lines. on non-JS - doesnt work because the caret is always on the first line |
| LTR/RTL Enter | ❌ | ❌ | forces a new line and makes the caret appear on a side corresponding to the current language. On non-JS - isnt supported since multiline isnt supported yet|



