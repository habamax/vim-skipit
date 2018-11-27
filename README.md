# vim-skipit
Skip text in INSERT mode.

If you have `g:skipit_default_mappings` set to 1 then while INSERT mode on press
`<CTRL-L>l` to skip everything until parentheses, bars or quotes and place
cursor right after them.

## Example

![vim-skipit example](http://i.imgur.com/agJQSXp.gif)

`|` is the cursor position.

```python
    def make_me_|cappuccino_coffee(temperature):
```

I want to rename function and insert one more parameter so I issue:
```
    ct_
    latte
```

```python
    def make_me_latte|_coffee(temperature):
```

Here I press `<CTRL-L>l` and skip `_coffee(`

```python
    def make_me_latte_coffee(|temperature):
```

Then add some `sugar, `

```python
    def make_me_latte_coffee(sugar, |temperature):
```

And I am ready to exit INSERT mode. `<ESC>`

## Installation
Using `vim-plug`:
```
call plug#begin('~/.vim/plugged')
Plug 'habamax/vim-skipit'
call plug#end()
```
