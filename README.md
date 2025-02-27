# my shitty ass dotfiles

I use i3wm on my laptop and sway on my desktop

To do:
- fix dunst being ugly for no reason
- make sway windows look cool


# How to use all of them (for my future reference)

Originally used this [Atlassian guide](https://www.atlassian.com/git/tutorials/dotfiles)

1. Add this alias to your .bashrc `alias dotf='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'`
2. (Optional) Make a copy of your bashrc if you don't want to lose it
3. Clone the repository like so `git clone --bare git@github.com:danakongur/dotfiles.git $HOME/.dotfiles`
4. Checkout the content to put everything in its place `dotf checkout` (you probably have to move existing files that would be overwritten)

Congragulagon, your shit is now synced up!


