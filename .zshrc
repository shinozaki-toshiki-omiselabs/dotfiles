# Emacs風ショートカットキー設定
bindkey -e

# エディタ
export EDITOR="/usr/bin/vim"

setopt IGNORE_EOF
setopt NO_FLOW_CONTROL
setopt NO_BEEP

# カーソル位置は保持したままファイル名一覧を順次その場で表示する
setopt always_last_prompt

# ディレクトリ名を打つだけでcd出来る
setopt auto_cd

# cdコマンドで移動した場所を記録する。 使う時はcd -[TAB]で
setopt auto_pushd

# 補完で末尾に補われた / を自動的に削除
setopt auto_remove_slash

# 履歴ファイル（HISTFILE）に開始時刻と経過時間を記録
setopt extended_history

# 補完時にヒストリを自動的に展開
# setopt hist_expand

# ヒストリで、重複するコマンドは古い方を削除
setopt hist_ignore_all_dups

# コマンドの先頭にスペースを入れた場合は、ヒストリに保存されない
setopt hist_ignore_space

# 履歴をインクリメンタルに追加
setopt inc_append_history

# C-s/C-q によるフロー制御を使わない
setopt no_flow_control

# ビープ音を消す
setopt no_beep

# プロンプトに escape sequence (環境変数) を通す
setopt prompt_subst

# ディレクトリスタックで、重複する物は古い方を削除
setopt pushd_ignore_dups

# 複数のpromptでログインした時など、履歴を共有する
setopt share_history

HISTFILE=$HOME/.zsh-history
# メモリ内の履歴
HISTSIZE=10000
# 保存される履歴
SAVEHIST=100000
function history-all { history -E 1 }

# 補完機能
autoload -U compinit
compinit

autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
bindkey "^o" history-beginning-search-backward-end

autoload -Uz add-zsh-hook
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ":chpwd:*" recent-dirs-max 200
zstyle ":chpwd:*" recent-dirs-default true

autoload -Uz zmv

zstyle ':completion:*:default' menu select=1

# 補完の時に大文字小文字を区別しない
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 一部のコマンドライン定義は、展開時に時間のかかる処理を行う
zstyle ':completion:*' use-cache true

# 補完候補もLS_COLORSに合わせて色づけ。
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# 
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# プロンプト
PROMPT='%! %n:%m %(!.#.>) '

# プロンプト右端
autoload -Uz vcs_info
precmd () { vcs_info }
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
setopt prompt_subst
RPROMPT='[%~]${vcs_info_msg_0_}'

# screenの設定
if [ "$TERM" = "screen" ]; then
	chpwd () { echo -n "_`dirs`\\" }
	preexec() {
		# see [zsh-workers:13180]
		# http://www.zsh.org/mla/workers/2000/msg03993.html
		emulate -L zsh
		local -a cmd; cmd=(${(z)2})
		case $cmd[1] in
			fg)
				if (( $#cmd == 1 )); then
					cmd=(builtin jobs -l %+)
				else
					cmd=(builtin jobs -l $cmd[2])
				fi
				;;
			%*)
				cmd=(builtin jobs -l $cmd[1])
				;;
			cd)
				if (( $#cmd == 2)); then
					cmd[1]=$cmd[2]
				fi
				;&
			*)
				echo -n "k$cmd[1]:t\\"
				return
				;;
		esac

		local -A jt; jt=(${(kv)jobtexts})

		$cmd >>(read num rest
			cmd=(${(z)${(e):-\$jt$num}})
			echo -n "k$cmd[1]:t\\") 2>/dev/null
	}
	chpwd
fi

function chpwd() {
	echo -n "\e]2;$(pwd)\a"
	ls -CFqv | tail
}

# エイリアス
alias -g L='| less'
alias -g G='| grep -n'
alias ..='cd ..'
alias ls='ls -CFqv'
alias l='ls -lh'
alias lt='ls -ltr'
alias la='ls -a'
alias rm='rm -i'
alias h='history'
alias jk='jobs; kill %%'
alias grep='grep -nr'

alias gs='git status'
alias gl='git log --oneline'
alias gln='git log --name-only'
alias gd='git diff'
alias gdn='git diff --name-only'
alias gcm='git commit -m'

if [ -f ~/.alias ]; then
	source ~/.alias
fi

fpath=(~/src/github.com/shinozaki-toshiki-omiselabs/dotfiles/zsh-completions/src $fpath)
source ~/src/github.com/shinozaki-toshiki-omiselabs/dotfiles/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# eval $(dircolors ~/src/github.com/shinozaki-toshiki-omiselabs/dotfiles/dircolors-solarized/dircolors.ansi-universal)

if [ -n "$LS_COLORS" ]; then
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi


export PATH="$HOME/.poetry/bin:$PATH"
