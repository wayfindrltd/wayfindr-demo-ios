SHELL = /bin/bash
APP_NAME = Wayfindr Demo

setup:
	gem install bundler
	bundle install
	pod update
