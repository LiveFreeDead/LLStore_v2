#!/bin/bash

yes | cp "$PWD/llstore Libs (Both)"/* "$PWD/llstore Libs/"

yes | cp -rf "$PWD/Resources"/* "$PWD/llstore Resources/"

rm -rf "$PWD/Debugllstore"
