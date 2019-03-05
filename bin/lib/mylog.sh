source "$BKLIB/colors.sh"

pheader() {
	printf "\n$underline$@$reset\n"
}

pokay() {
	printf "$green$@$reset\n"
}

pinfo() {
	printf "$blue$@$reset\n"
}

pwarn() {
	printf "$yellow$@$reset\n"
}

perror() {
	printf "$red$@$reset\n"
}

piheader() {
	printf "$underline$@$reset"
}

piokay() {
	printf "$green$@$reset"
}

piinfo() {
	printf "$blue$@$reset"
}

piwarn() {
	printf "$yellow$@$reset"
}

pierror() {
	printf "$red$@$reset"
}

ptrue() {
	pokay "✔ $@"
}

pitrue() {
	piokay "✔ $@"
}

pfalse() {
	perror "✘ $@"
}

pifalse() {
	pierror "✘ $@"
}

ptodo() {
	pinfo "[ ] $@"
}

pitodo() {
	piinfo "[ ] $@"
}

ptodoDone() {
	pokay "[x] $@"
}

pitodoDone() {
	piokay "[x] $@"
}
