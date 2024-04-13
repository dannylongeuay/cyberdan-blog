+++ 
draft = false
date = 2024-04-12T08:25:28-07:00
title = "Hugo Blog Setup"
description = "Setup guide for a Hugo blog site"
slug = "hugo-blog-setup"
tags = ["Hugo"]
categories = ["Personal"]
+++
Setup guide for a Hugo blog site
```fish
gh repo create
```
```fish
z cyberdan-blog/
```
```fish
hugo new site . --force --format yaml
```
```fish
git submodule add https://github.com/luizdepra/hugo-coder.git themes/hugo-coder
```
```fish
hugo new content posts/hello_world.md
```
