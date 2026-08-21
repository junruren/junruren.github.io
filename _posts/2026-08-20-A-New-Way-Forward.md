---
title: "A New Way Forward"
date: 2026-08-20
permalink: /posts/2026/08/a-new-way-forward/
excerpt: "I've joined Waymo as a product manager. Why I think the next decade of AI is about worlds, not just words, and why a robotaxi is where I chose to work on it."
tags:
  - personal
  - waymo
  - career
---

## Pickup

On a Friday afternoon in August, a Waymo pulled up for me. Ahead of us: an hour of Bay Area rush-hour traffic, and my first autonomous ride on a freeway. Somewhere on the US-101, I realized I had spent the whole ride talking into my phone, dictating the first draft of this post. I would not have done that with a driver up front. This car had no one to overhear me.

This post also lives on [my Substack](https://junruren.substack.com/p/a-new-way-forward?utm_source=junruren.com&utm_medium=referral&utm_campaign=a-new-way-forward) — comment there, or subscribe to get future posts by email.
{: .notice}

By the time this reaches you, I will have been at Waymo for about a month as a product manager working on simulation. It is my first time as a product manager, after six years as a software engineer before MIT, and my first time working on autonomous vehicles, or, to use the current phrase, physical AI. One month in, I am taking on two firsts, with a car driving me around as I write about them.

<figure>
  <a href="/images/2026-08-20-A-New-Way-Forward/Waymo-at-WaymoHQ.jpeg">
    <img src="/images/2026-08-20-A-New-Way-Forward/Waymo-at-WaymoHQ.jpeg"
         alt="The author smiling behind the open door of a white Waymo Jaguar I-PACE robotaxi parked on a sunny, tree-lined plaza at Waymo HQ, its rooftop lidar dome and sensor pods visible and a colorful mural painted on the open door"
         width="960"
         height="1280">
  </a>
  <figcaption>August 2026: a Waymo picking me up from Waymo. The novelty has not worn off.</figcaption>
</figure>

Waymo's name stands for "a new way forward in mobility."[^1] I borrowed it for the title because it fits me too. I have embarked on a new way forward in the kind of work I do and the industry I do it in. Both changes connect to a long-running wish to make the world a little better through something physical and tangible. (The irony is that simulation sounds like the total opposite of tangible. But hey, I believe a good simulator sits on the critical path of AI succeeding in our physical world.)

## Worlds, Not Just Words

I believe the next decade of AI is about worlds, not just words: systems that understand space and physics, not only sentences. I think this matters most in the physical world, where a mistake costs more than a bad paragraph. Among the many bets on physical AI, autonomous vehicles look to me like the mature end of the frontier. They already carry ordinary people who pay for rides, and they have the data flywheel most embodied AI is still trying to start.

The hard question in autonomous driving is no longer whether a car can drive, but whether we can prove at scale that it drives well in situations nobody has seen yet. That is a simulation question. I came to this view in roughly the order I tell it here. The views are mine, worked out before I had a badge.

## Why I Care

Self-driving cars were science fiction to me for most of my life. When Waymo was still a Google project,[^2] I filed it under admirable moonshots. It did not feel real to me until I sat in one.

Before I could sit in one, I learned how easy it is to take driving for granted. Between 2020 and 2022, I went through a series of injuries and surgeries. During stretches of those three years, I could not drive. In California, that is humbling. Every trip to a doctor, a grocery store, or a friend's place became a small logistics problem. I am fine now, thankfully, but the experience left me with a lasting awareness of what driving actually requires.

<figure>
  <a href="/images/2026-08-20-A-New-Way-Forward/Shopping-Cart.jpeg">
    <img src="/images/2026-08-20-A-New-Way-Forward/Shopping-Cart.jpeg"
         alt="A motorized mobility shopping cart with a wire basket, black seat, and tall orange safety flag parked in a wet grocery-store parking lot under a partly cloudy sky, with a sign on the basket reading 'IN-STORE USE ONLY'"
         width="960"
         height="1280"
         loading="lazy">
  </a>
  <figcaption>Between surgeries, this was the only thing I could drive.</figcaption>
</figure>

Driving requires a license, and many people, in California and around the world, do not have one for many reasons. It also requires a body that can drive, which mine temporarily could not.[^3] When you cannot drive and call a ride, there is a stranger in the car with you. Usually that is fine. Sometimes you would simply like the ride to be yours: to take a call, sit quietly, or get your hour back. Rush hour on the 101 while dictating a blog post turns out to be one of those times.

My first Waymo ride was on January 27, 2024, in San Francisco, when the service was already fully driverless but still gated behind a waitlist.[^4] A friend from college who worked at Waymo sent me an invite. I had just come out of the last of the surgeries, which is probably why I remember the ride the way I do.

On a single-lane street, a double-parked car blocked us. The Waymo waited, then pulled left into the oncoming lane, went around, and merged back. Two things happened in my head at once. First, that was exactly what a decent human driver would do. Second, I trusted it, because the screen in front of me showed what the lidar saw: nobody was coming. It was a small, educated, human-like decision, and it did more to make autonomy real to me than a decade of headlines had.

I was applying to MIT's LGO program at the time. In an update I sent the program that spring, I wrote that the ride had shown me operational excellence outside of work: safety, deployment, fleet management, demand, regulation, all the work around the algorithm.

## Words

I spent six years at SoundHound building voice AI: systems that turned what people said into what they meant, in cars and, later, on restaurant phone lines. They understood sentences, and I was proud of them. Then, in late 2022, a chatbot made much of what I knew feel less durable, which is roughly why I went back to school; I told that story in [the MIT post]({% post_url 2026-07-29-mit-reflection %}).

What I did not expect was how quickly language would stop being the whole story. Language models are astonishing with words and oddly helpless with the world. Fei-Fei Li points out that even state-of-the-art multimodal models "rarely perform better than chance" at estimating distance, orientation, and size, or at mentally rotating an object.[^5] I recognized the shape of that gap from my own work. My systems could parse "turn left at the next light." They had no idea what a light was, or a left.

The systems I had built understood sentences. The ones I wanted to work on next had to understand a street.

<figure>
  <a href="/images/2026-08-20-A-New-Way-Forward/Words-Worlds-Wheels.jpeg">
    <img src="/images/2026-08-20-A-New-Way-Forward/Words-Worlds-Wheels.jpeg"
         alt="Hand-drawn sketch on aged notebook paper: a speech bubble filled with scribbled text, an arrow pointing to a wireframe cube containing a tree, a winding road, and a stick-figure pedestrian, and a second arrow pointing to a small rounded driverless car with a rooftop sensor, drawn speeding away"
         width="1600"
         height="893"
         loading="lazy">
  </a>
  <figcaption>The argument, in one sketch: words, then worlds, then wheels.</figcaption>
</figure>

## Worlds

At MIT I went looking for the other modalities. In spring 2025 I took an advanced computer-vision class, and one project asked us to reconstruct a bulldozer in three dimensions from a single photo: given one angle, produce the front, the back, the side. Those classes and projects also redrew my map of the field. The research frontier was no longer one specialized model per perception task, an object detector here, a segmentation model there. Attention had moved to general models that learn a representation of the world across modalities and use it to predict what happens next. A few months later, the whole industry had a name for what I was circling: world models, systems that do not just recognize a scene but can imagine how it continues. Li was arguing in ["From Words to Worlds"](https://drfeifei.substack.com/p/from-words-to-worlds-spatial-intelligence) that spatial intelligence is AI's next frontier: "Without spatial intelligence, AI is disconnected from the physical reality it seeks to understand and cannot effectively drive our cars or guide robots." I did not need much convincing.

The obvious applications are in the physical world. Physical AI covers humanoid robots, warehouse arms, and general-purpose robot policies. Much of it is dazzling, but by its own researchers' account it is short of the one thing language models had in abundance. The largest open robot-learning dataset holds about a million trajectories across 22 kinds of robot; language models train on trillions of tokens.[^6] Most of that work is still in the lab. I knew I wanted to work at the frontier and in the real world at the same time.

## Wheels

The exception I found was autonomous vehicles. They are robots with four wheels navigating the physical world, and they were already on the road: paying riders in roughly fifteen U.S. metros,[^7] and more than 200 million fully autonomous miles by Waymo's public count.[^8] Every one of those miles produces data no lab could have invented from scratch. That data feeds model development and deployment, which lead to more miles. This is the flywheel most embodied AI is still trying to start. It made autonomous driving look to me like the mature end of the frontier. The work is not finished, but it is out of the lab.

Waymo also became one of MIT LGO's industry partner companies in 2023,[^9] around the time I applied to the program. That gave me reasons to pay closer attention: partner introductions, classmates and alumni who worked there, and a lot of homework on my side so that I would not ask questions a search engine could have answered. My curiosity went first to the driver, the AI behind the wheel. But two years of an operations program did their work on me. I grew a real respect for everything that has to be true for a robotaxi to be safe, available, and legal in a city, and I would have happily worked on that side too. By the time full-time recruiting came around in late 2025, Waymo was at the top of my list.

There is a confession about temperament here. At SoundHound, I worked on in-car voice assistants for years before I finally sat in a car in China, in 2024, that ran the Mandarin voice system I had helped build. It took more than five years to close that loop. I am, in a way, an impatient person. I like to see my work reach real people sooner. Waymo's driver was already on the road, and that mattered to me more than I expected.

## The Question That Moved

People disagree about whether autonomous driving is still a scientific problem or now mainly an engineering one. Andrej Karpathy, who led AI at Tesla for five years, described the remaining work this way last October: "this is not even near done... it's a march of nines. Every single nine is a constant amount of work."[^10] Waymo's own co-CEO says the demo took 18 months and the product took about 15 years.[^11]

<figure>
  <a href="/images/2026-08-20-A-New-Way-Forward/DD-at-YC.jpeg">
    <img src="/images/2026-08-20-A-New-Way-Forward/DD-at-YC.jpeg"
         alt="Conference-hall view of YC Startup School 2026: Dmitri Dolgov speaks on a round orange stage beneath a large screen showing a slide titled '7 Lessons - Learned from shipping the most mature manifestation of AI in the physical world,' with three generations of Waymo vehicles pictured"
         width="960"
         height="1280"
         loading="lazy">
  </a>
  <figcaption>One week into the job, at YC Startup School: Dmitri Dolgov's seven lessons. Several of them ended up in this post's footnotes, and his slide title is probably where "the mature end of the frontier" started forming in my head.</figcaption>
</figure>

I think the scientific question moved rather than disappeared. It is no longer "can a car drive?" but "can we prove, at scale, that it drives well in situations nobody has seen yet?" Answering that depends on simulation. A simulator has to reproduce the world realistically, generate rare events that real roads seldom offer, and evaluate a driver against them before it meets them. Waymo has been public about this. Simulation is one of the three pillars of its approach to demonstrably safe AI, and its newest simulator is itself a world model, generating camera and lidar data for events "from a tornado to a casual encounter with an elephant."[^12] For me, the words-to-worlds argument leads from the car to the simulator inside the car company.

My new title, product manager for simulation realism, is essentially the sim-to-real gap with a job description attached. A simulator is also where the frontier lands: world models come out of research upstream, and a simulator turns them into a working product, one that trains and validates a robotic driver. Standing at that junction takes someone who can read the papers and ship a product. Two years at MIT rebuilt the first muscle; six years of building software gave me the second. For me it looks like a sweet spot, though one month in, that is still a working hypothesis of mine. The role touches the whole system: the data coming off the fleet, the models, what has to be true before something ships, and the streets it all has to survive. Simulators, evaluation, and closing the gap between the simulated and the real are problems every embodied AI will need to solve; [Li's essay says as much about robots](https://drfeifei.substack.com/p/from-words-to-worlds-spatial-intelligence). The ideas travel. That is why this feels like work I could stay close to for a long time.

I hope robot-learning data catches up soon, and autonomous vehicles stop being the exception in this argument. That would be good news for everyone, and the ideas would only travel further.

## The Deputy PM

The other first needs more explaining, because I did not set out to become a product manager. I came to MIT mainly for a technical reset.

I did not see the pattern clearly at the time. As a junior engineer at SoundHound, I felt comfortable huddling with product and program managers, mostly because I wanted to write code that would still make sense in a year. As a tech lead later on, I found myself bringing intuitions about what a feature should look like and how to spec it, sitting across from my product-manager counterpart almost as an equal partner. I listened to real users' voice interactions with our system. I flew to Nashville, where our sales and support teams sat, to hear what restaurant owners were actually asking for. Colleagues from sales and customer success started coming to me with product questions, and I enjoyed explaining the same piece of code three different ways for three different audiences. Looking back, that was a deputy product manager without the label. At the time I would have said I was just an engineer who wanted the bigger picture.

Product management did not feel like a plausible next step until I read product-manager job descriptions closely for the first time. I started to recognize myself in them: a deep technical background, an understanding of AI systems, and the strategy and people skills I had been practicing without naming. I worked backwards from those descriptions to my own history, and I applied.

If the hard problems in physical AI cut across evaluation, operations, safety, and all the work around the algorithm that I noticed on that first ride, then a technically deep product-manager role seems like a reasonable place for me. That is the argument, anyway. I will report back on whether it survives contact with the job.

Some of the vocabulary makes me wince. Product managers now call themselves builders, and I can hear the MBA in myself when I say "stakeholder mapping." Cringe aside, the substance is real. A technically deep PM with today's AI tooling can prototype and test ideas fast, and the good old skills, understanding organizations, incentives, and people, are what turn a prototype into something a team will actually build. I still write code, happily, when it makes me faster. I have just stopped wanting to be measured by it. Among engineers I was probably the most PM-looking one. Among PMs, I hope to stay the one most comfortable thinking like an engineer.

## One Month In

One month is too early for conclusions, and most of the specifics belong at work. I did my homework before starting, but it did not make the pivot smaller. I really am changing both what I do and the industry I do it in at the same time. For now, I need to learn from the inside: how things actually work here and where I can contribute most. Colleagues, new and long-tenured alike, tell me the same thing in different words: at Waymo, you learn something new every day. I cannot yet claim to know one percent of what a good product manager is. Then again, I should not be that conservative. I know more than I did a month ago.

Everyone I have met so far, regardless of seniority or background, has been welcoming, generous with their time, and patient with a career pivoter. I look forward to working with them and learning from them.

## Drop-Off

<figure>
  <a href="/images/2026-08-20-A-New-Way-Forward/2024-First-Surface-Street-Ride-and-2026-First-Freeway-Ride.jpeg">
    <img src="/images/2026-08-20-A-New-Way-Forward/2024-First-Surface-Street-Ride-and-2026-First-Freeway-Ride.jpeg"
         alt="Two photos from inside a driverless Waymo with an empty driver's seat. Left: a dusk city street in San Francisco with a gold-domed building ahead, the screen reading 'Arrival in 14 min at 5:29 PM.' Right: a daytime freeway with the wheel turning itself, the screen reading 'Arriving in 55 min at 5:54 PM.'"
         width="1280"
         height="853"
         loading="lazy">
  </a>
  <figcaption>Left: my first Waymo ride, San Francisco, January 27, 2024. Right: my first freeway ride, two and a half years later — the one this post was dictated in.</figcaption>
</figure>

An hour after the pickup, the car took the exit toward my drop-off. Waymo has said publicly that the same driver could one day power trucks and personally owned vehicles,[^13] so the mission of getting more people moving is bigger than the robotaxi I was sitting in. For me, that mission stays personal. Three years ago I could not drive. Now I can be carried an hour across the Bay Area while I write, trusting a machine in a way I could not before. I want that for the many people who cannot drive, and for the many who can but would sometimes rather not. I also like that what I work on now is something my family and friends can see and ride: AI embodied on the street, in addition to a voice inside a dashboard.

The months of learning ahead will outnumber the years behind me. I hope they add up to a meaningful contribution to a mission that is personal to me. I will write more here about worlds and simulation as I learn.

Thank you to my mom and dad, who drove me around when I could not drive myself. I hope I can return the favor and drive them around now, even if the car does the driving.

<!-- HOW-I-MADE-THIS statement:

Whenever I had a moment, I'd record myself sharing a snippet of stories or ideas, partly from the back seat of the Waymo :) Then, with my recordings transcribed, I used AI to help me tabulate all the stories, and then I'd organize them into a storyline. Often I'd ask AI to suggest some funny and witty ways to word something. I also used AI for some literature review and fact-checking. Finally, I used AI to check my grammar, as English is not my first language.
-->

[^1]: From Waymo's December 2016 announcement: ["Waymo stands for a new way forward in mobility."](https://medium.com/waymo/say-hello-to-waymo-whats-next-for-google-s-self-driving-car-project-b854578b24ee)
[^2]: The project began in January 2009 as the Google Self-Driving Car Project inside X. Fully driverless rides opened to the general public in the Phoenix area in [October 2020](https://waymo.com/blog/2020/10/waymo-is-opening-its-fully-driverless.html).
[^3]: U.S. DOT Bureau of Transportation Statistics, ["Travel Patterns of American Adults with Disabilities"](https://www.bts.gov/newsroom/travel-patterns-american-adults-disabilities): an estimated 25.5 million Americans age 5 and older have self-reported travel-limiting disabilities, and about 3.6 million of them do not leave home at all (2017 National Household Travel Survey).
[^4]: San Francisco timeline: paid, fully driverless rides were [approved in August 2023](https://www.cpuc.ca.gov/news-and-updates/all-news/cpuc-approves-permits-for-cruise-and-waymo-to-charge-fares-for-passenger-service-in-sf-2023); the waitlist came down and the service [opened to everyone in June 2024](https://waymo.com/blog/2024/06/waymo-one-is-now-open-to-everyone-in-san-francisco/).
[^5]: Fei-Fei Li, ["From Words to Worlds: Spatial Intelligence Is AI's Next Frontier"](https://drfeifei.substack.com/p/from-words-to-worlds-spatial-intelligence), November 2025. On robots: "World models will play a defining role in scaling robotic learning by closing the gap between simulation and reality."
[^6]: [Open X-Embodiment](https://arxiv.org/abs/2310.08864) pools about one million trajectories across 22 robot embodiments. A 2025 study of data scaling in robotic manipulation opens by noting that "the principles of effective data scaling in robotic manipulation remain insufficiently understood" ([Shi et al.](https://arxiv.org/abs/2507.06219)).
[^7]: Waymo counted [ten commercial metro areas](https://waymo.com/blog/2026/02/dallas-houston-san-antonio-orlando/) in February 2026 and began fully autonomous driving in [four more](https://waymo.com/blog/shorts/ro-den-lv-sd-tmpa/) that July.
[^8]: ["Over 200 million fully autonomous miles traveled,"](https://waymo.com/blog/2026/02/dallas-houston-san-antonio-orlando/) Waymo, February 2026; Dolgov cited 220 million-plus in [July 2026](https://www.ycombinator.com/library/WV-waymo-co-ceo-dmitri-dolgov-the-demo-is-only-1-of-the-work).
[^9]: [LGO partner companies](https://lgo.mit.edu/partner-companies/): Waymo, partner since 2023.
[^10]: Andrej Karpathy on the [Dwarkesh Podcast](https://www.dwarkesh.com/p/andrej-karpathy), October 2025.
[^11]: Dmitri Dolgov, [YC Startup School, July 2026](https://www.ycombinator.com/library/WV-waymo-co-ceo-dmitri-dolgov-the-demo-is-only-1-of-the-work): "The demo took 18 months; the product took about 15 years."
[^12]: Waymo, ["The Waymo World Model: A New Frontier for Autonomous Driving Simulation"](https://waymo.com/blog/2026/02/the-waymo-world-model-a-new-frontier-for-autonomous-driving-simulation/), February 2026: "Simulation is a critical component of Waymo's AI ecosystem and one of the three key pillars of our approach to demonstrably safe AI."
[^13]: Dolgov, YC Startup School, July 2026: "In the future, we'll power different products and different commercial applications like trucking and personally owned vehicles."
