---
title: My experience refactoring from Parsec to Megaparsec for the SIL parser thus far
---

So I'm trying to refactor [SIL](https://github.com/Stand-In-Language/stand-in-language)'s parser from using [Parserc](https://hackage.haskell.org/package/parsec) to use [Megaparsec](https://hackage.haskell.org/package/megaparsec). This is my journey so far. An incomplete journey, because things do not work yet, but I think I've learned, so I'll try to share and better conceptualize such learnings in this post.

So my [first step](https://github.com/hhefesto/stand-in-language/commit/f5a7292c8999b6d98b419a3fdf285a05989310dc) was to qualify all Parsec's imports with `RM` to visualize what I have to remove.

My second step was to read up about Megaparsec, Parsec, some blog posts, and a Youtube video:
- [Megaparsec's tutorial](https://markkarpov.com/tutorial/megaparsec.html)
- [Youtube video using Megaparsec](https://www.youtube.com/watch?v=swmcdn_Nf9g)
- [Indentation with Parsec](https://spin.atomicobject.com/2012/03/16/using-text-parsec-indent-to-parse-an-indentation-sensitive-language-with-haskells-parsec-library/)
- [Example of someone doing "Indentation using Megaparsec"](https://stackoverflow.com/questions/48271208/indentation-using-megaparsec)

Reading about Parsec and Megaparsec was Okay to getting familiarized with how things happened. But, if I had to do it again, I would concentrate on [Megaparsec's tutorial](https://markkarpov.com/tutorial/megaparsec.html) and dive into the code.

Previous *reading* is necessary to not stab the problem in the dark, but, a posteriori, I wouldn't recommend trying to understand deeply after reading. You/I should see *reading* as skimming through a resource for a general direction. And this is important to me because I felt my anxiety building up as no code was being written and me still not understanding Parsec's and Megaparsec's take on *monadic parsing* to the fullest with such reading. So I would recommend to you and myself to take it easy, recognize when your *reading* is done by doing an introspective gaze and answer: Is this enough to get started?

Deeper understanding comes from actually doing stuff. I still feel that *reading* is important to build up your self confidence, but just to be able to start. One gets stuck if you try to start after knowing everything, because you will never actually learn everything by just reading, you need hands-on experience.

Continuing with my [next step](https://github.com/hhefesto/stand-in-language/commit/17578785e0a1f91f0512adc442459b993d3fd2b1) on this refactoring business, once I felt a bit more confident from my reading, I made a new copy of SIL's `Parser.hs` module, renamed it to `ParserMegaparsec`, commented everything out and started "consuming" every commented function and refactoring them to code that type-checked using Megaparsec's combinators.

At first things seemed to finally accelerate, but that was because the first parsers I refactored were not indentation sensitive. It was until I faced refactoring `parserPair` that I got stuck again. And I had already read the indentation section of Megaparsec's tutorial, but it wasn't until I was doing stuff with it that I noticed clear holes on my knowledge. Identifying those holes I was able to read about them and better understand while trying to solve the problem.

After more reading, I finally got a sense of how to implement `parsePair` so that it type-checked. Having this indentation sensitive parser ready, it was quite simple to replicate the effort for the rest of the indentation sensitive parsers (which were most of them). This is shown in [this commit](https://github.com/hhefesto/stand-in-language/commit/9b86a4bbd216edd11d117b99db75ef71f7c3071c).

And that's basically where I'm at. `Megaparsec.hs` does compile, but that won't warranty correctness (it takes you a step closer, but more testing is required). After running the parser with a simple hello-world SIL script, I got a memory leak and had to force reboot my machine...

So whats next? I need a better way to test/run my parsers and a better understanding of how to read and improve Megaparsec's error handling.

See you/me next time ;)
