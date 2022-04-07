# Roadmap

My memory is kinda trash, so I thought of making a roadmap for me and you to know whats supported and whats yet to be 
supported (I promise you I need this more than you 😂)

 - ✅ - fully working
 - ❌ - needs implementation
 - ✅❌ - partially complete, probably works but might be wonky


## **FlxInputTextRTL**

Reguar FlxInputText with extended support for:
 - All languages
 - Bi-directional text
 - Multiline text
 - Commands such as copy and paste

| Feature |  Works On JS  | Works On Non-JS | More Details |
|  :---:  |      :---:    |       :---:     |    :---:     |
| General LTR for LTR languages | ✅ | ✅ | The actual letters/signs being typed|
| General RTL for RTL languages | ✅ | ✅ | The actual letters/signs being typed with the RTL Marker (when needed)|
| LTR Spacebar                  | ✅ | ✅ | The regular `SPACE` character - `" "`|
| RTL Spacebar                  | ✅ | ✅ | The regular `SPACE` character for RTL languages with the RTL Marker|
| LTR Backspace                 | ✅ | ✅ | The regular `backspace` deletion|
| RTL Backspace                 | ✅ | ✅ | The regular `backspace` deletion for RTL languages|
| LTR Delete                    | ✅ | ✅ | The regular `delete` deletion|
| RTL Delete                    | ✅ | ✅ | The regular `delete` deletion for RTL languages|
| LTR Caret                     | ✅ | ✅ | The letter insertion/deletion point|
| RTL Caret                     | ✅ | ✅ | The letter insertion/deletion point|
| Text Auto-Alignment           | ❌ | ✅ | Aligns the text inside of the text input according to the direction of the first character|
| Multiline text                | ❌ | ✅ | Expands the input verticly and escapes words to the next line|
| Scrolling Single-Line text    | ✅ | ✅ | Doesn't expand the input, but moves the text so the caret will be visible|
| Left\Right Arrow Keys         | ✅ | ✅ | Used to move the caret between letters/signs|
| Up/Down Arrow Keys            | ❌ | ✅ | Used to move the caret between lines. Not available on JS targets as multiline crashes them|
| LTR/RTL Enter                 | ❌ | ✅ | Forces a new line and makes the caret appear on a side corresponding to the current language|
| LTR WordWrapping              | ❌ | ✅ | When a sentence/word is too long for a multiline text input, some words will be escaped to the next line|
| RTL WordWrapping              | ❌ | ❌ | When a sentence/word is too long for a multiline text input, some words will be escaped to the next line|
| Unicode BiDi Algorithm (UBA)  | ✅ | ✅ | When a user tries to type in both a LTR language and a RTL language, the text input should be able to handle that correctly with alignments, moving the caret and placing certine unicode characters differently|
| Selection                     | ❌ | ❌ | When dragging & pressing the mouse across the text, a visual selection background should appear. that background tells you those characters can be deleted, copied, cut, pasted over or moved|
| Text Copy/Paste               | ❌ | ✅ | Pressing `CTRL` + `C` copies the selected text. Pressing `CTRL` + `V` - pastes text from the clipboard|

## **FlxTextButton**

A text that calls a function when clicked
Behaves like a regular `FlxInputTextRTL`, but
with extra button functions.

| Feature |  Works On JS  | Works On Non-JS | More Details |
|  :---:  |      :---:    |       :---:     |    :---:     |
| Label Type Switching  | ✅ | ✅ | Switch between `input` mode (text accepts input, `onEnter()` will be called) and `regular mode` (normal `FlxText`) |
| Button Status         | ✅ | ✅ | Tells you the state of the button - `NORMAL`, `HIGHLIGHT` (hover) or `PRESSED` |



