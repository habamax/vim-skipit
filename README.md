# vim-skipit
Skip text in INSERT mode.

While INSERT mode on press `CTRL-L` to skip everything until parentheses, bars or
quotes and place cursor right after them.

## Example

`|` is the cursor position.

```python
    def make_me_|cappuccino_coffee(temperature):
```

I want to rename function and insert one more parameter so I issue:
    ct_
    latte

```python
    def make_me_latte|_coffee(temperature):
```

Here I press CTRL-L and skip _coffee(

```python
    def make_me_latte_coffee(|temperature):
```

Then add some sugar

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
