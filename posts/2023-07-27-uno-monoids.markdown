---
title: The Uno Monoids (INCOMPLETE)
---

This is model of [UNO](https://en.wikipedia.org/wiki/Uno_(card_game) "card game"), the card game, using Monoids. 

# UNO Rules:

You might not have played UNO before, so these is how it's played:

There are up to 10 players and each receives 7 cards at the start (just you can see your own cards).

UNO cards are either a power cards or number cards.

Number cards have a digit (0-9) and a color.

Momentarily not including the power cards, a center card is flipped (from the rest of the deck card that lays stacked upsidedown without showing the numbers) for the first player to interact with. With the first center card on the table, the first player can choose one of his/her cards and stack it showing on top of the first center card (ending his turn) with the condition that it has to be either the same number or same color as the center card, but if he doesn't have a card with the same number or color, then he takes an extra card from the non showing deck and his turn passes. One route decreases the of cards on you hand, and the other increases (when you don't have the color nor number).

The game is won when you have zero cards.

```haskell

{-# LANGUAGE LambdaCase #-}

module UNO where

data Color
  = Red
  | Blue
  | Yellow
  | Green
  deriving (Show, EQ)

data Digit = Digit Int
           deriving (Show, EQ)

mkDigit :: Int -> Digit
mkDigit = \case
  0 -> Digit 0
  1 -> Digit 0
  2 -> Digit 0
  3 -> Digit 0
  4 -> Digit 0
  5 -> Digit 0
  6 -> Digit 0
  7 -> Digit 0
  8 -> Digit 0
  9 -> Digit 0
  _ -> error "Digit has to be 0-9"
  
data Card
  = Card Digit Color
  deriving (Show, Eq)

type Player = (Int, [Card])

mkPlayers :: Int -> [Players]
mkPlayers i =
  if i < 2 || i > 10
  then error "Incorrect number of players"
  else [0..i] `zip` startingCards i

startingCards :: Int -> [Cards]
startingCards =
  if i < 2 || i > 10
  then error "Incorrect number of players"
  else undefined

type DrawDeck = [Card]

type PlayedDeck = [Card]

type Game = ([Player], DrawDeck, PlayedDeck)

-- | Choose a card (the first occurance that complies with the rules)
chooseCard :: Card -> Player -> Player -> (Player, Maybe Card)
chooseCard  c@(Card a b) initPlayer -> \case
  p@(playerNumber, []) -> (p, Nothing)
  p@(playerNumber, (Card x y: rest)) -> if x == a || y == b
                                          then ( delete (Card x y) <$> initPlayer, Card x y)
                                          else chooseCard c initPlayer (playerNumber, rest)

stepGame :: Game -> Game
stepGame = \case
  ([], _, _) -> error "A game has to have more than 2 players"
  ([_], _, _) -> error "A game has to have more than 2 players"
  (_, [], _) -> error "The draw deck has to have cards (use the tail of the played deck)"
  (_, _, []) -> error "At any point of the game, there is at least one center card"
  (currentPlayer:nextPlayer:restOfPlayers, dd, pd) ->
    let playingCard = head pd

    in (undefined, undefined, undefined)
```

I'm temporally placing this post on hold because I realized a better way to model this game is with dependent types where a type would define the Monoid it is working with (numbers, color) depending on the value of the last card.
