# texter



## I'll start with a story

About 5 month ago, just a month after I started programming in haxeflixel, I wanted to make an app that needed text input, specificly RTL.

for about 2 months I tried to find some existing (decent) RTL support, but didnt find any that were good enough.

### It was the time I decided to take this duty upon myself - to add more support for text input (in that time - only in haxeflixel)

It might seem like im exaggerating, but trust me, it took me a **while** to make progress. but when I did start making (good) progress,
I figured I'm not the only person that needs those fixes, **and thats how and why I created this library.**

### **Can I Help/Contribute?**
Of course! Any help is greatly appreciated! You can help with: 
- fixing bugs
- writing/fixing documentation
- making code more readable/simpler & shorter (don't worry, I think my code is pretty understandable ;) )
- writing code for the library
- adding projects that you think are useful 

And more that pops up in you mind!

# Roadmap

My memory is kinda trash, so i thought of making a roadmap for me and you to know whats supported and whats yet to be 
supported (I promise you i need this more then you 😂)

 - ✅ - fully working
 - ❌ - needs implementation
 - ✅❌ - partially complete, probably works but might be wonky
---

## **FlxInputTextRTL**

Reguar FlxInputText with extended support for:
 - All languages
 - Bi-directional text
 - Multilne (Almost!)

| Feature | Works On JS | Works On Non-JS |More Details |
|  :---:  |     :---:   |       :---:     |    :---:    |
| General LTR for LTR languages | ✅ | ✅ | the actual letters/signs being typed |
| General RTL for RTL languages | ✅ | ✅ | the actual letters/signs being typed with the RTL Marker (when needed) |
| LTR Spacebar                  | ✅ | ✅ | the regular `space` char - `" "` |
| RTL Spacebar                  | ✅ | ❌ | the regular `space` char for RTL languages with the RTL Marker - need to add RTL spacebar logic on non-JS targets |
| LTR Backspace                 | ✅ | ✅ | the regular `backspace` deletion |
| RTL Backspace                 | ✅ | ✅ | the regular `backspace` deletion for RTL languages |
| LTR Delete                    | ✅ | ✅ | the regular `delete` deletion |
| RTL Delete                    | ✅ | ✅ | the regular `delete` deletion for RTL languages |
| LTR Caret                     | ✅ | ✅ | the letter insertion/deletion point |
| RTL Caret                     | ✅ | ✅ | the letter insertion/deletion point|
| LTR WordWrapping              | ✅ | ✅ | when a word or a sentence is too long for the text input, it cuts it/escapes it to the next line |
| RTL WordWrapping              | ✅ | ✅ | when a word or a sentence is too long for the text input, it cuts it/escapes it to the next line |
| Multiline text                | ❌ | ✅❌ | expands the input text verticly to match the text size & create a  new line. on JS - crashes with `shader is null` |
| Scrolling Single-Line text    | ✅ | ✅ | doesnt expand the input, but moves the text so the caret will be visible |
| Left\Right Arrow Keys         | ✅ | ✅ | used to move the caret between letters/signs |
| Up/Down Arrow Keys            | ❌ | ❌ | used to move the caret between lines. on JS - multiline crashes the app |
| LTR/RTL Enter                 | ❌ | ✅ | forces a new line and makes the caret appear on a side corresponding to the current language |

### Bugs

| Bug | Fixed On JS | Fixed On non-JS | More Details |
|:---:|    :---:    |      :---:      |     :---:    |
| First Char remains visible| ✅ | ✅ | A known problem that plagued FlxInputText on JS for a while - when deleting all of the chars from that text input, the first one will remain visible, even tho it doesn't exist |
| Caret Stuck On First Line | ❌ | ✅❌ | when the text wraps itself and makes a new line, the caret remains on the last leter of the first line |
| Next Bug Here |  |  | Bug Description Here |

