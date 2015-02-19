
build:
	@npm install
	@echo "BUILD coffee-script"
	@rm -rf js/
	@node_modules/.bin/coffee -b -o js/ coffee/
	@echo " -- done"

test: build
	@echo "TEST"
	@node_modules/.bin/coffee ./test/generic.coffee
	@node_modules/.bin/coffee ./test/plugin/*
	@echo " -- done"
