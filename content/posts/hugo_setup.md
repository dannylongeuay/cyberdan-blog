+++ 
draft = false
date = 2024-04-12T08:25:28-07:00
title = "Hugo Blog Setup"
description = "Setup guide for a Hugo blog site"
slug = "hugo-blog-setup"
authors = ["Daniel Longeuay"]
tags = ["Hugo"]
categories = ["Personal"]
externalLink = ""
series = []
+++  
```
gh repo create
```
```
z cyberdan-blog/
```
```
hugo new site . --force --format yaml
```
```
git submodule add https://github.com/luizdepra/hugo-coder.git themes/hugo-coder
```
```
hugo new content posts/hello_world.md
```
