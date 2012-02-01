cojiro [![Build Status](https://secure.travis-ci.org/netalab/cojiro.png)](http://travis-ci.org/netalab/cojiro) 
======

cojiro is a platform for discovering and sharing conversations across languages.

(In the spirit of [Readme Driven Development](http://tom.preston-werner.com/2010/08/23/readme-driven-development.html), this text describes an application that is not yet implemented. For an up-to-date overview of implemented features see the latest build on [Travis-CI](http://travis-ci.org/netalab/cojiro).)

Introduction
------------

An earthquake has hit Japan, and the world wants to know what is happening. Information is pouring out in blogs, bulletin boards, video sharing sites and local websites, but the voices on the ground are buried in the noise, and the language they are speaking in is Japanese.

Popular services for discovering and sharing conversations in one language are surprisingly bad at handling his type of cross-lingual information flow. So we decided to build our own.

cojiro is a platform designed to enable people with complementary skill sets to identify, group and convey stories in one language to a broader audience in another language. The platform is based on the philosophy that in order to effectively bridge language barriers, content should only be translated if there is an audience who will actually read it.

To do this, cojiro appeals to two key user groups to narrow the focus of translation: domain experts in the source language, whose knowledge of local contexts and specific areas is essential to uncovering and grouping interesting conversations, and readers in the target language, who can evaluate which of these conversations would be of interest to foreign audiences.

Closing the feedback loop between these groups would make cross-lingual sharing and collaboration a much more seamless process—and, we believe, a much more interesting and exciting one.

Features
--------

General features:

* Sign-in via Twitter or Facebook, no need to remember new logins or passwords (OAuth/OmniAuth)
* Set language preferences to tailor presentation of language-specific content
* Submit and index media sources (articles, tweets, videos, photos) in any supported language with a single click
* Collaborate with users in other languages to organize sources (links) into multilingual discussion threads
* Discuss content with users in other languages via multilingual threaded commenting
* All changes recorded in revision history

For bilinguals:

* Share content across your social networks by translating content metadata from articles, tweets, videos or photos using simple in-place editing
* Create re-usable translated excerpts (quotes) to include in your blog or in multilingual discussion threads

For curators:

* Apply your knowledge of a specific topic to arrange and organize media sources into a natural flow using built-in bundling functions
* Find new audiences by gauging interest in your content among users in other language(s) through activity metrics

For story-writers:

* Discover story leads in languages you don’t speak by searching translated metadata (titles, summaries, excerpts)
* Get help looking for relevant sources in multiple languages by posting questions and calls for help

Copyright
---------

Copyright (c) 2011 NetaLab. See [MIT-LICENSE](cojiro/blob/develop/MIT-LICENSE) for details.
