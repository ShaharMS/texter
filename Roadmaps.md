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
 - Multilne

| Feature |  Works On JS  | Works On Non-JS | More Details |
|  :---:  |      :---:    |       :---:     |    :---:     |
| General LTR for LTR languages | ✅ | ✅ | the actual letters/signs being typed                                                                        |
| General RTL for RTL languages | ✅ | ✅ | the actual letters/signs being typed with the RTL Marker (when needed)                                      |
| LTR Spacebar                  | ✅ | ✅ | the regular `space` character - `" "`                                                                       |
| RTL Spacebar                  | ✅ | ✅ | the regular `space` character for RTL languages with the RTL Marker                                         |
| LTR Backspace                 | ✅ | ✅ | the regular `backspace` deletion                                                                            |
| RTL Backspace                 | ✅ | ✅ | the regular `backspace` deletion for RTL languages                                                          |
| LTR Delete                    | ✅ | ✅ | the regular `delete` deletion                                                                               |
| RTL Delete                    | ✅ | ✅ | the regular `delete` deletion for RTL languages                                                             |
| LTR Caret                     | ✅ | ✅ | the letter insertion/deletion point                                                                         |
| RTL Caret                     | ✅ | ✅ | the letter insertion/deletion point                                                                         |
| Text Auto-Alignment           | ❌ | ✅ | aligns the text inside of the text input according to the direction of the first character                  |
| Multiline text                | ❌ | ✅ | expands the input verticly and escapes words to the next line                                               |
| Scrolling Single-Line text    | ✅ | ✅ | doesnt expand the input, but moves the text so the caret will be visible                                    |
| Left\Right Arrow Keys         | ✅ | ✅ | used to move the caret between letters/signs                                                                |
| Up/Down Arrow Keys            | ❌ | ✅ | used to move the caret between lines. on JS - multiline crashes the app                                     |
| LTR/RTL Enter                 | ❌ | ✅ | forces a new line and makes the caret appear on a side corresponding to the current language                |
| LTR WordWrapping              | ❌ | ✅ | when the sentence/word is too long for a multiline text input, some words will be escaped to the next line  |
| RTL WordWrapping              | ❌ | ❌ |  when the sentence/word is too long for a multiline text input, some words will be escaped to the next line |
| Unicode BiDi Algorithm (UBA)  | ✅ | ✅ | when a user tries to type in both a LTR language and a RTL language, the text input should be able to handle that correctly with alignments, moving the caret and placing certine unicode characters differently                                                           |
| Selection                     | ❌ | ❌ | when dragging & pressing the mouse across the text, a visual selection background should appear. that background tells you those character could be delted, copied, pasted over/moved                                                                                     |
| Text Copy/Paste               | ❌ | ✅ | when pressing `ctrl` + `c` - copy the selected text. when pressing `ctrl` + `v` - paste text from the clipboard |

## **FlxTextButton**

A text that calls a function when clicked
Behaves like a regular `FlxInputTextRTL`, but
with extra button functions.

| Feature |  Works On JS  | Works On Non-JS | More Details |
|  :---:  |      :---:    |       :---:     |    :---:     |
| Label Type Switching  | ✅ | ✅ | Switch between `input` mode (text accepts input, `onEnter()` will be called) and `regular mode` (normal `FlxText`) |
| Button Status         | ✅ | ✅ | tells you the state of the button - `NORMAL`, `HIGHLIGHT` (hover) or `PRESSED` |




