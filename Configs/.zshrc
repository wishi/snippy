## wishi's zshrc, optimised for MacOS Leopard
# - stolen from here and there
# - put it in ~
# - and have fun!

## changelog
# 15.10.2009 - cleanup & gited ;)
# 7.3.2009 - completion clean-up
# 8.3.2009 - source cleanup


## due debugging and recaching of certain completions
#  may not be necessary 
rm ~/.zcompdump >/dev/null 

## setting iTerm's title tab
function set_title_tab {

    function settab   {
     #  * file settab  -- invoked only if iTerm (or KDE Konsole) is running 
     #  * sets iterm window tab to current directory and penultimate directory if the
	  #  * shell process is running.  Truncate to leave the rightmost $rlength characters.
	  #
	  #  Use with functions settitle (to set iterm title bar to current directory)
	  #  and chpwd

		if [[ $TERM_PROGRAM == iTerm.app && -z "$KONSOLE_DCOP_SESSION" ]];then

			# The $rlength variable prints only the 20 rightmost characters. Otherwise iTerm truncates
			# what appears in the tab from the left.

				# Chage the following to change the string that actually appears in the tab:

					tab_label="$PWD:h:t/$PWD:t"

					rlength="20"   # number of characters to appear before truncation from the left

		            echo -ne "\e]1;${(l:rlength:)tab_label}\a"
	     
		else  

			# For KDE konsole tabs 
			# Chage the following to change the string that actually appears in the tab:

					tab_label="$PWD:h:t/$PWD:t"
					rlength="20"   # number of characters to appear before truncation from the left

		        # If we have a functioning KDE console, set the tab in the same way
		        if [[ -n "$KONSOLE_DCOP_SESSION" && ( -x $(which dcop)  )  ]];then
		                dcop "$KONSOLE_DCOP_SESSION" renameSession "${(l:rlength:)tab_label}"
		        else
		            : # do nothing if tabs don't exist
		        fi    
	
		fi
	}

    function settitle   {
		# Function "settitle"  --  set the title of the iterm title bar. use with chpwd and settab

		# Change the following string to change what appears in the Title Bar label:


			title_lab=$HOST:r:r::$PWD  
				# Prints the host name, two colons, absolute path for current directory

			# Change the title bar label dynamically:

			echo -ne "\e]2;[zsh]   $title_lab\a"
	}

	# Set tab and title bar dynamically using above-defined functions

		function title_tab_chpwd { settab ; settitle }
		
		# Now we need to run it:
	    title_tab_chpwd

	# Set tab or title bar label transiently to the currently running command
	
	if [[ "$TERM_PROGRAM" == "iTerm.app" ]];then		
		function title_tab_preexec {  echo -ne "\e]1; $(history $HISTCMD | cut -b7- ) \a"  } 
		function title_tab_precmd  { settab }	
	else
		function title_tab_preexec {  echo -ne "\e]2; $(history $HISTCMD | cut -b7- ) \a"  } 
		function title_tab_precmd  { settitle }      
	fi

 
	typeset -ga preexec_functions
	preexec_functions+=title_tab_preexec

	typeset -ga precmd_functions
	precmd_functions+=title_tab_precmd

	typeset -ga chpwd_functions
	chpwd_functions+=title_tab_chpwd
 
}
set_title_tab


# ZFTP is an ftp client built right in to zsh. *Very* neat.

  if [[ $ZSH_VERSION > '4.2' ]]; then
  autoload  zfinit ; zfinit
  # Emailaddress for anonymous-session
  (( ${+EMAIL_ADDR} )) || export EMAIL_ADDR="wishinet@gmail.com"
  # A `G' for a get operation and a `P' for a put operation.
  ZFTP_TRANSFER=yes
  # Default is a reverse progressbar but its very ugly *narf*
  # Valid options are ``none'', ``bar'' and ``percent''.
  zstyle ':zftp:*' progress percent
  # Specifies the minimum time interval between updates of the
  # progress meters in seconds
  zstyle ':zftp:*' update true
  # If set to ``1'', ``yes'' or ``true'', filename generation
  # (globbing) is performed on the remote maschine instead of
  # zsh itself. Hell no!!!11!
  zstyle ':zftp:*' remote-glob false
  fi


## set default browser
  (( ${+BROWSER} )) || export BROWSER="links"
  (( ${+PAGER} ))   || export PAGER="less"


## alias section
alias -g ll="ls -l"
alias -g ls="ls -G"

# MacVim specific - regular updates made me integrate it as standard Vim
alias mvim="open -a MacVim"
alias vim="/Volumes/MacOS_10.4/Applications/MacVim.app/Contents/MacOS/Vim"

# twitter2/me: wishinet :)
alias twitter="perl /Volumes/MacOS_10.4/Sourced/twitter-cmdline/twitter-1.03/twitter.pl"
# Thunderbird has nice commandline-options
alias thunderbird="/Volumes/MacOS_10.4/Applications/Thunderbird.app/Contents/MacOS/thunderbird-bin"

## has been necessary on Tiger systems: dtterm for Vim. 
# alias vim="export TERM=dtterm && open /Applications/MacVim.app/Contents/MacOS/Vim"

## BEWARE: this is propellarhead stuff
# esoteric aliase... 
alias -g ....='../..'
alias -g ......='../../..'
alias -g ........='../../../..'

# some nice stuff... and not esoteric
alias -g C='|wc -l'
alias -g cls="clear"                   # yes, Windows. I use ZSH on Windows, too 

alias ldiff='tla what-changed --diffs | less'

# listings
alias dir="ls -lSrah"
alias lad='ls -d .*(/)'                # only show dot-directories
alias lsa='ls -a .*(.)'                # only show dot-files
alias lss='ls -l *(s,S,t)'             # only files with setgid/setuid/sticky flag
alias lsl='ls -l *(@[1,10])'           # only symlinks
alias lsx='ls -l *(*[1,10])'           # only executables
alias lsw='ls -ld *(R,W,X.^ND/)'       # world-{readable,writable,executable} files
alias lsbig="ls -flh *(.OL[1,10])"     # display the biggest files
alias lsd='ls -d *(/)'                 # only show directories
alias lse='ls -d *(/^F)'               # only show empty directories
alias lsnew="ls -rl *(D.om[1,10])"     # display the newest files
alias lsold="ls -rtlh *(D.om[1,10])"   # display the oldest files
alias lssmall="ls -Srl *(.oL[1,10])"   # display the smallest files
alias pdb="/usr/lib/python2.5/pdb.py"  # python debugger

# chmod stuff
alias rw-='chmod 600'
alias rwx='chmod 700'
alias r--='chmod 644'
alias r-x='chmod 755'

# some useful alias for OpenVMS people 
alias md='mkdir -p'

## console stuff
# if you're not using mplayer: vlc has commandline options, too. I exported VLC to my $PATH 
alias cmplayer='mplayer -vo fbdev'
alias fbmplayer='mplayer -vo fbdev'

# nicer manpages - you know these retarded people telling you: "read man foobar"? 
[ -d ~/.terminfo/ ] && alias man='TERMINFO=~/.terminfo/ LESS=C TERM=mostlike PAGER=less man'

# Xterm resizing-fu. 
# Based on http://svn.kitenet.net/trunk/home-full/.zshrc?rev=11710&view=log (by Joey Hess)
  alias hide='echo -en "\033]50;nil2\007"'
  alias tiny='echo -en "\033]50;-misc-fixed-medium-r-normal-*-*-80-*-*-c-*-iso8859-15\007"'
  alias small='echo -en "\033]50;6x10\007"'
  alias medium='echo -en "\033]50;-misc-fixed-medium-r-normal--13-120-75-75-c-80-iso8859-15\007"'
  alias default='echo -e "\033]50;-misc-fixed-medium-r-normal-*-*-140-*-*-c-*-iso8859-15\007"'
  alias large='echo -en "\033]50;-misc-fixed-medium-r-normal-*-*-150-*-*-c-*-iso8859-15\007"'
  alias huge='echo -en "\033]50;-misc-fixed-medium-r-normal-*-*-210-*-*-c-*-iso8859-15\007"'
  alias smartfont='echo -en "\033]50;-artwiz-smoothansi-*-*-*-*-*-*-*-*-*-*-*-*\007"'
  alias semifont='echo -en "\033]50;-misc-fixed-medium-r-semicondensed-*-*-120-*-*-*-*-iso8859-15\007"'
#  if [ "$TERM" = "xterm" ] && [ "$LINES" -ge 50 ] && [ "$COLUMNS" -ge 100 ] && [ -z "$SSH_CONNECTION" ]; then
#          large
#  fi

## Functions {

# useful functions without detailed explanation:
  agoogle() { ${=BROWSER} "http://groups.google.com/groups?as_uauthors=$*" ; }
  bk()      { cp -b ${1} ${1}_`date --iso-8601=m` }
  cdiff()   { diff -crd "$*" | egrep -v "^Only in |^Binary files " }
  cl()      { cd $1 && ls -a }        # cd && ls
  cvsa()    { cvs add $* && cvs com -m 'initial checkin' $* }
  cvsd()    { cvs diff -N $* |& $PAGER }
  cvsl()    { cvs log $* |& $PAGER }
  cvsq()    { cvs -nq update }
  cvsr()    { rcs2log $* | $PAGER }
  cvss()    { cvs status -v $* }
  # debbug()  { ${=BROWSER} "http://bugs.debian.org/$*" }
  debbugm() { bts show --mbox $1 } # provide bugnummer as $1
  disassemble(){ gcc -pipe -S -o - -O -g $* | as -aldh -o /dev/null }
  dmoz()    { ${=BROWSER} http://search.dmoz.org/cgi-bin/search\?search=${1// /_} }
  dwicti()  { ${=BROWSER} http://de.wiktionary.org/wiki/${(C)1// /_} }
  ewicti()  { ${=BROWSER} http://en.wiktionary.org/wiki/${(C)1// /_} }
  # fir()     { open -a firefox | $1 }
  ggogle()  { ${=BROWSER} "http://groups.google.com/groups?q=$*" }
  # google()  { ${=BROWSER} "http://www.google.com/search?&num=100&q=$*" }
  mdiff()   { diff -udrP "$1" "$2" > diff.`date "+%Y-%m-%d"`."$1" }
  memusage(){ ps aux | awk '{if (NR > 1) print $5; if (NR > 2) print "+"} END { print "p" }' | dc }
  mggogle() { ${=BROWSER} "http://groups.google.com/groups?selm=$*" }
  netcraft(){ ${=BROWSER} "http://toolbar.netcraft.com/site_report?url=$1" }
  oleo()    { ${=BROWSER} "http://dict.leo.org/?search=$*" }
  shtar()   { gunzip -c $1 | tar -tf - -- | $PAGER }
  shtgz()   { tar -ztf $1 | $PAGER }
  shzip()   { unzip -l $1 | $PAGER }
  sig()     { agrep -d '^-- $' "$*" ~/.Signature }
  swiki()   { ${=BROWSER} http://de.wikipedia.org/wiki/Spezial:Search/${(C)1} }
  udiff()   { diff -urd $* | egrep -v "^Only in |^Binary files " }
  viless()  { vim --cmd 'let no_plugin_maps = 1' -c "so \$VIMRUNTIME/macros/less.vim" "${@:--}" }
  wikide () { ${=BROWSER} http://de.wikipedia.org/wiki/"${(C)*}" }
  wikien()  { ${=BROWSER} http://en.wikipedia.org/wiki/"$*" }
  wodeb ()  { ${=BROWSER} "http://packages.debian.org/cgi-bin/search_contents.pl?word=$1&version=unstable" }

# create pdf file from source code
  makereadable() {
     output=$1
     shift
     a2ps --medium A4dj -E -o $output $*
     ps2pdf $output
  }

## perl stuff: quick Perl-hacks 
 bew() { perl -le 'print unpack "B*","'$1'"' }
 web() { perl -le 'print pack "B*","'$1'"' }
 hew() { perl -le 'print unpack "H*","'$1'"' }
 weh() { perl -le 'print pack "H*","'$1'"' }
 pversion()    { perl -M$1 -le "print $1->VERSION" } # i. e."pversion LWP -> 5.79"
 getlinks ()   { perl -ne 'while ( m/"((www|ftp|http):\/\/.*?)"/gc ) { print $1, "\n"; }' $* }
 gethrefs ()   { perl -ne 'while ( m/href="([^"]*)"/gc ) { print $1, "\n"; }' $* }
 getanames ()  { perl -ne 'while ( m/a name="([^"]*)"/gc ) { print $1, "\n"; }' $* }
 getforms ()   { perl -ne 'while ( m:(\</?(input|form|select|option).*?\>):gic ) { print $1, "\n"; }' $* }
 getstrings () { perl -ne 'while ( m/"(.*?)"/gc ) { print $1, "\n"; }' $*}
 getanchors () { perl -ne 'while ( m/«([^«»\n]+)»/gc ) { print $1, "\n"; }' $* }
 showINC ()    { perl -e 'for (@INC) { printf "%d %s\n", $i++, $_ }' }
 vimpm ()      { vim `perldoc -l $1 | sed -e 's/pod$/pm/'` }
 vimhelp ()    { vim -c "help $1" -c on -c "au! VimEnter *" }


## simple extraction of archives
# Usage: 		simple-extract <file>
# Description: 	extracts archived files (maybe)
  simple-extract () {
        if [[ -f $1 ]]
        then
                case $1 in
                        *.tar.bz2)  bzip2 -v -d $1      ;;
                        *.tar.gz)   tar -xvzf $1        ;;
                        *.rar)      unrar $1            ;;
                        *.deb)      ar -x $1            ;;
                        *.bz2)      bzip2 -d $1         ;;
                        *.lzh)      lha x $1            ;;
                        *.gz)       gunzip -d $1        ;;
                        *.tar)      tar -xvf $1         ;;
                        *.tgz)      gunzip -d $1        ;;
                        *.tbz2)     tar -jxvf $1        ;;
                        *.zip)      unzip $1            ;;
                        *.Z)        uncompress $1       ;;
                        *)          echo "'$1' Error. Please go away" ;;
                esac
        else
                echo "'$1' is not a valid file"
        fi
  }

## and of course: pack that stuff again.  
# Usage: 		smartcompress <file> (<type>)
# Description: 	compresses files or a directory.  Defaults to tar.gz
  smartcompress() {
        if [ $2 ]; then
                case $2 in
                        tgz | tar.gz)   tar -zcvf$1.$2 $1 ;;
                        tbz2 | tar.bz2) tar -jcvf$1.$2 $1 ;;
                        tar.Z)          tar -Zcvf$1.$2 $1 ;;
                        tar)            tar -cvf$1.$2  $1 ;;
                        gz | gzip)      gzip           $1 ;;
                        bz2 | bzip2)    bzip2          $1 ;;
                        *)
                        echo "Error: $2 is not a valid compression type"
                        ;;
                esac
        else
                smartcompress $1 tar.gz
        fi
  }

## preview archives before extraction
# Usage: 		show-archive <archive>
# Description: 	view archive without unpack
  show-archive() {
        if [[ -f $1 ]]
        then
                case $1 in
                        *.tar.gz)      gunzip -c $1 | tar -tf - -- ;;
                        *.tar)         tar -tf $1 ;;
                        *.tgz)         tar -ztf $1 ;;
                        *.zip)         unzip -l $1 ;;
                        *.bz2)         bzless $1 ;;
                        *)             echo "'$1' Error. Please go away" ;;
                esac
        else
                echo "'$1' is not a valid archive"
        fi
  }

## printout system information  
status() {
        print ""
        print "Date..: "$(date "+%Y-%m-%d %H:%M:%S")""
        print "Shell.: Zsh $ZSH_VERSION (PID = $$, $SHLVL nests)"
        print "Term..: $TTY ($TERM), $BAUD bauds, $COLUMNS x $LINES cars"
        print "Login.: $LOGNAME (UID = $EUID) on $HOST"
        print "System: $(cat /etc/[A-Za-z]*[_-][rv]e[lr]*)"
        print "Uptime:$(uptime)"
        print ""
  }

## rip audio files  
  audiorip() {
        mkdir -p ~/ripps
        cd ~/ripps
        cdrdao read-cd --device $DEVICE --driver generic-mmc audiocd.toc
        cdrdao read-cddb --device $DEVICE --driver generic-mmc audiocd.toc
        echo " * Would you like to burn the cd now? (yes/no)"
        read input
        if
                [ "$input" = "yes" ]; then
                echo " ! Burning Audio CD"
                audioburn
                echo " * done."
        else
                echo " ! Invalid response."
        fi
  }

## burn that stuff  
  audioburn() {
        cd ~/ripps
        cdrdao write --device $DEVICE --driver generic-mmc audiocd.toc
        echo " * Should I remove the temporary files? (yes/no)"
        read input
        if [ "$input" = "yes" ]; then
                echo " ! Removing Temporary Files."
                cd ~
                rm -rf ~/ripps
                echo " * done."
        else
                echo " ! Invalid response."
        fi
  }

  mkaudiocd() {
        cd ~/ripps
        for i in *.[Mm][Pp]3; do mv "$i" `echo $i | tr '[A-Z]' '[a-z]'`; done
        for i in *.mp3; do mv "$i" `echo $i | tr ' ' '_'`; done
        for i in *.mp3; do mpg123 -w `basename $i .mp3`.wav $i; done
        normalize -m *.wav
        for i in *.wav; do sox $i.wav -r 44100 $i.wav resample; done
  }

  mkiso() {
        echo " * Volume name "
        read volume
        echo " * ISO Name (ie. tmp.iso)"
        read iso
        echo " * Directory or File"
        read files
        mkisofs -o ~/$iso -A $volume -allow-multidot -J -R -iso-level 3 -V $volume -R $files
  }

## generate thumbnails 
  genthumbs () {
    rm -rf thumb-* index.html
    echo "
<html>
  <head>
    <title>Images</title>
  </head>
  <body>" > index.html
    for f in *.(gif|jpeg|jpg|png)
    do
        convert -size 100x200 "$f" -resize 100x200 thumb-"$f"
        echo "    <a href=\"$f\"><img src=\"thumb-$f\"></a>" >> index.html
    done
    echo "
  </body>
</html>" >> index.html
  }

## for specific dbg situations:  
# unset all limits (see zshbuiltins(1) /ulimit for details)
#  allulimit() {
#    ulimit -c unlimited
#    ulimit -d unlimited
#    ulimit -f unlimited
#    ulimit -l unlimited
#    ulimit -n unlimited
#    ulimit -s unlimited
#    ulimit -t unlimited
#  }

## RFC 2396 URL encoding in Z-Shell
  urlencode() {
   setopt localoptions extendedglob
   input=( ${(s::)1} )
   print ${(j::)input/(#b)([^A-Za-z0-9_.!~*\'\(\)-])/%$(([##16]#match))}
  }


## invoke this every time when you change .zshrc to recompile it.
src ()
  {
    autoload -U zrecompile
    [ -f ~/.zshrc ] && zrecompile -p ~/.zshrc
    [ -f ~/.zcompdump ] && zrecompile -p ~/.zcompdump
    [ -f ~/.zshrc.zwc.old ] && rm -f ~/.zshrc.zwc.old
    [ -f ~/.zcompdump.zwc.old ] && rm -f ~/.zcompdump.zwc.old
    source ~/.zshrc
  }


## send files via netcat

# on sending side:
send() {j=$*; tar cpz ${j/%${!#}/}|nc -w 1 ${!#} 51330;}
# send dir* $HOST
alias receive='nc -vlp 51330 | tar xzvp'

# typeset -U path manpath fpath

## This is the very essential section of 
#  completion & completion cache

# autocomplete for current dir on filetypes
compctl -g '*.Z *.gz *.tgz' + -g '*' zcat gunzip
compctl -g '*.bz2' + -g '*' bunzip2
compctl -g '*.tar.Z *.tar.gz *.tgz *.tar.bz2' + -g '*' tar
compctl -g '*.zip *.ZIP' + -g '*' unzip

# completion fkt enable
autoload -U compinit
compinit

# correction fkt
setopt correctall

# style
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'

## ssh host autocompletion
local _myhosts
# if [[ -f $HOME/.ssh/known_hosts ]]; then
  _myhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
  zstyle ':completion:*' hosts $_myhosts
# fi

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# special completion
zstyle ':completion:*:processes-names' command  'ps c -u ${USER} -o command | uniq'


## other zsh settings
zmodload -i zsh/complist
zstyle ':completion:*' menu select=10
zstyle ':completion:*' verbose yes
setopt hist_ignore_all_dups
 
# Make sure ~/.zlogin is always read if it exists
if [[ -f ~/.zlogin ]];then
    source ~/.zlogin
fi

# Variables
export COLORTERM="yes"

# Color definitions
RED="%{\e[1;31m%}"
GREEN="%{\e[1;32m%}"
YELLOW="%{\e[1;33m%}"
BLUE="%{\e[1;34m%}"
PINK="%{\e[1;35m%}"
CYAN="%{\e[1;36m%}"
WHITE="%{\e[1;37m%}"

## a nice prompt ;)
#export PS1='[32m%n[0m@[33m%m[0m [36m%~[0m

export PS1='[32m'$(whoami)'[0m@[31m%m[0m [34m%~[0m
%# '


## create a history
#
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=65535
DIRSTACKSIZE=16

setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt NO_hist_beep
setopt hist_reduce_blanks
setopt hist_save_no_dups


## set/unset shell options
# stop annoying mailchecks - we are not using AOL
unset MAILCHECK

# stop the nerving beep
setopt nobeep

# lower priority of background processes & other process management
setopt bg_nice
setopt NO_HUP
setopt NO_check_jobs
setopt long_list_jobs

## SPROMPT - the spelling prompt
SPROMPT='zsh: correct '%R' to '%r' ? ([Y]es/[N]o/[E]dit/[A]bort) '

## bindkey
bindkey -v     ## vi-style
bindkey "^[[2~" yank
bindkey "^[[3~" delete-char
bindkey "^[[5~" up-line-or-history ## PageUp
bindkey "^[[6~" down-line-or-history ## PageDown
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[e" expand-cmd-path 
bindkey "^[[A" up-line-or-search ## up arrow for back-history-search
bindkey "^[[B" down-line-or-search ## down arrow for fwd-history-search
bindkey " " magic-space ## do history expansion on space

#bindkey '\e[Q' beginning-of-line
#bindkey '\e[E' end-of-line
bindkey '^B' beginning-of-line
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^L' clear-screen

# csh compatibility
setenv()  { export $1=$2 }
test -r /sw/bin/init.sh && . /sw/bin/init.sh

# changed at 8.2.2009
# since Apple utilized Xorg instead of X11 it's not necessary any longer
# export DISPLAY=:0.0

# input variables
. ~/.zshinput

# auto cd - .. instead of cd ..
setopt autocd

# advanced globbing functions module
setopt extendedglob

# Umlauts for German folder names
set meta-flag on
set convert-meta off
set output-meta on
set completion-ignore-case on
set show-all-if-ambiguous on

# enf
# stty erase ^H

## PATH stuff

# export MacPorts
export PATH=/Volumes/MacOS_10.4/opt/local/bin:/Volumes/MacOS_10.4/opt/local/sbin:$PATH

# export LaTeX
export PATH=/Library/TeX/Root/bin/i386-darwin:$PATH

# export DevTools
export PATH=/Developer/Developer/usr/bin:$PATH

# export dvtm
export PATH="/Volumes/docs/code/Sourced/dvtm":$PATH

# export mvim && vim
export PATH="/Applications/MacVim.app/Contents/MacOS/":$PATH

# export TOR
export PATH="/Library/Tor/":$PATH

# export bro
export PATH="/usr/local/bro/bin":$PATH

# Nessus
export PATH="/Library/Nessus/i386/bin":$PATH

# wireshark
export PATH="/Volumes/MacOS_10.4/Applications/Wireshark/bin":$PATH

# vlc
export PATH="/Volumes/MacOS_10.4/Applications/VLC.app/Contents/MacOS/":$PATH

# hla
export PATH="/Volumes/docs/code/Sourced/hla/hla/":$PATH

# mysql - due paimei
export PATH="/usr/local/mysql/bin":$PATH

## configures ls -g color
# yellow instead of blue
export LSCOLORS=DxGxcxdxCxcgcdabagacad
