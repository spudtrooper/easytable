NAME=easytable
VERSION=0.0.1
DATE=$(shell date +"%Y-%m-%d")

%.gemspec:%.gemspec.in
	cat $< | sed \
		-e 's/%NAME%/$(NAME)/g' \
		-e 's/%DATE%/$(DATE)/g' \
		-e 's/%VERSION%/$(VERSION)/g' \
		> $@

all: $(NAME)-$(VERSION).gem

push: $(NAME)-$(VERSION).gem
	gem push $<

install: $(NAME)-$(VERSION).gem
	sudo gem install $<

t: runtest
runtest:
	ruby test/suite.rb

eg: example
	chmod +x $<
	./$<

$(NAME)-$(VERSION).gem: $(NAME).gemspec
	gem build $<

clean:
	rm -f `find . -name "*~"` $(NAME).gemspec $(NAME)-*.gem