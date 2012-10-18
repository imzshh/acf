#!/bin/bash

mocha -R spec --compilers coffee:coffee-script ./tests/index.coffee
