SHELL = /bin/bash
APP_NAME = Wayfindr Demo

setup:
	sudo gem install bundler
	bundle install
	pod repo update
	pod install
