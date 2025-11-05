---
title: "Stolen Name: How Software Erases Identity"
date: 2025-10-14
permalink: /posts/2025/11/stolen-name/
tags:
  - software
  - culture
---

What happens when you are greeted with just half of your first name by a software system? Or maybe an online tax form or driver's license portal does not recognize your name even when you thought you typed it correctly? From the lens of Chinese names, this post reflects how software systems can inadvertently erase identity through poor handling of names based on biased assumptions.

---

In my junior years as a software engineer responsible for designing different APIs that relay user information to support voice AI interactions, my mentor, [David](https://www.ellipsix.net/index.html), shared with me a funny blog post: [_"Falsehoods Programmers Believe About Names"_](https://www.kalzumeus.com/2010/06/17/falsehoods-programmers-believe-about-names/). This is probably a classic piece that many seasoned geeks have read, but it was humorously eye-opening for me at that time. You gotta read it if you haven't yet! My favorite is the last one:

> _40. People have names._

Joking aside, I recently remembered a series of encounters I had with other Chinese friends regarding their names being misrepresented or truncated by various software systems. And the more I thought about it, the more I realized how these seemingly small issues can have a significant impact on one's sense of identity and belonging.

## Chinese Names in Chinese

This is already a rabbit hole on its own because when we say "Chinese," we are actually referring to a vast array of cultures, ethnicities, languages, and naming conventions across Greater China and beyond. I am a [Han Chinese](https://en.wikipedia.org/wiki/Han_Chinese) from mainland China, so I will focus on the naming conventions that are most common among Han Chinese people.

A Chinese name typically consists of a family name (surname) followed by a given name. However, across most of the local-use official documents or ID cards, the full name is presented as a single string of characters without any segmentation into "first name" and "last name." Growing up, every form I had to filled out simply had one field asking for full name, all characters together.

| Sample | Remark |
|-----------------------|-------------------|
| ![](https://upload.wikimedia.org/wikipedia/commons/e/e7/The_People%27s_Republic_of_China_resident_identity_card_%28SAMPLE%29.png) | In **Mainland China**, a Resident ID Card only has one "full name" (姓名) field with all Chinese characters together. In the sample photo, look for "某某某" as the placeholder of a full name. There are, however, exceptions for a name of a certain ethnic minority where the idea of a "full name" is very different, and the mapping can be not as straightforward... (An interesting read: [Additional Features in Ethnic Minority Areas on a Chinese ID Card](https://en.wikipedia.org/wiki/Resident_Identity_Card#Additional_features_in_ethnic_minority_areas)) |
| ![](https://upload.wikimedia.org/wikipedia/commons/f/f6/ROC_mibunsho.jpg) | An ID card in **Taiwan (ROC)** also only has one "full name" (姓名) field with all characters together, though the spacing between two characters seem significant but I don't think the spacing demarcates the surname name and given name |
| ![](https://upload.wikimedia.org/wikipedia/commons/4/47/Hong_Kong_ID_card_front_side.png) | The Chinese portion of an ID card in **Hong Kong** also only has all Chinese characters together. However, the English portion of the ID card puts a comma between the family name and given name. |
| ![](https://upload.wikimedia.org/wikipedia/commons/b/bf/MacaoID2023.jpg) | **Macau** is the _only_ instance that I can find where the ID card's design explicitly separates the family name and given name fields. |

With the examples above (alas I guess except Macau), it is clear that Chinese names in Chinese are typically treated as a single unit without segmentation.

## Chinese Names in Romanization


---

## Flip the Table

So far, we have explored how a Chinese name identity, being taken into a non-Chinese cultural context where local software systems designed with local conventions, may be unintentionally distorted or erased.

But we can certainly flip the table and ask: _What if a non-Chinese name is being forced into a Chinese naming convention?_ If you have a say in this matter, I'd love to hear from you!