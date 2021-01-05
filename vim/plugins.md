# Vim Plugins

([From this article])(https://opensource.com/article/20/2/how-install-vim-plugins)

## Manually

You may or may not have a `~/.vim` directory. Plugins are loaded as:
```
~/.vim/pack/*/start
```
...and...
```
~/.vim/pack/*/opt
```

The * could be anything. to keep it simple, it could be `vendor`. Vim best practices say to
name it after the plugin. Anything found in a `start` dir will startup when Vim does. Anything
in `opt` will need to be loaded with a command: `:packadd NERDTree`

## vim-plug

`vim-plug` is an easy plugin manager.

Install it:
```
$ curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  ```

in the `.vimrc`:
```
call plug#begin()
Plug 'preservim/NERDTree'
call plug#end()
```

Syntax is `Plug + Github Account Name + Repo Name` or it's the url for the plugin if not on
Github.

Commands:

`:PlugInstall` - to install
`:PlugUpdate` - to update
`:PlugUpdate NERDTree` - to specify the plugin
`:PlugSnapshot ~/vim-plug.list` to doc and export plugins

[And so much more](https://github.com/junegunn/vim-plug)

