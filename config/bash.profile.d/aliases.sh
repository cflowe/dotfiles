alias rm='/bin/rm -i'
alias cp='/bin/cp -i'
alias mv='/bin/mv -i'
alias l='/bin/ls -lF --color=auto'
alias la='/bin/ls -alF --color=auto'
alias ll='/bin/ls -AlF --color=auto'
alias lx='/bin/ls -AxF --color=auto'
alias grep='/bin/grep --color=auto'
alias egrep='/bin/egrep --color=auto'
alias isum='perl -e "map {s/(^\s+|\s+\$)//g; s/(\s)+/\1/g; map {\$i += int} split(/\s/)} <STDIN>; print(\"\$i\n\");"'
alias asum='perl -e "\$i = 0; map {s/(^\s+|\s+\$)//g; s/(\s)+/\1/g; map {\$i += \$_} split(/\s/)} <STDIN>; print(\"\$i\n\");"'
alias avg='perl -e "map {s/(^\s+|\s+\$)//g; s/(\s)+/\1/g; map {if (\$_ > 0) {\$i += \$_; \$c++}} split(/\s/)} <STDIN>; print((\$i / \$c) . \"\n\");"'
alias max='perl -e "\$i=0; map { map { \$i = \$_ if(\$_ > \$i) } split(/\s/)} <STDIN>; print \$i"'
alias min='perl -e "\$i=0xffffffff; map { map { \$i = \$_ if(\$_ < \$i) } split(/\s/)} <STDIN>; print \$i"'
alias sec2date='perl -e "\$ref = scalar(@ARGV) ? \@ARGV : (@in = <STDIN>, \@in) ; map { chomp; print(\"\$_ = \" . scalar(localtime(\$_)) . \"\\n\") } @{\$ref}"'
alias sec2dateg='perl -e "\$ref = scalar(@ARGV) ? \@ARGV : (@in = <STDIN>, \@in) ; map { chomp; print(\"\$_ = \" . scalar(gmtime(\$_)) . \"\\n\") } @{\$ref}"'
alias gmtdiff='zdump US/Eastern GMT'
alias fbroken="perl -MFile::Find -le 'find(sub { -l && !-e && print \$File::Find::name }, \".\")'"

function wpushd {
  pushd "$@" && [ -f .virtualenv-workon ] && workon "$(cat .virtualenv-workon)"
}

function wpopd {
  popd "$@" && [ -f .virtualenv-workon ] && workon "$(cat .virtualenv-workon)"
}
