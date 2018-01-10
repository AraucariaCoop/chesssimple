module Chesssimple.GameAI ( ZeroSumGame, evaluateGame, availableMovements, isGameOver, performMovement ) where

import Data.List (maximumBy)
import Data.Ord  (compare)

class ZeroSumGame zsg where
  evaluateGame       :: zsg -> Float -- IMPORTANT: this function MUST return a score relative to the side to being evaluated
  availableMovements :: zsg -> [zsg]
  isGameOver         :: zsg -> Bool

performMovement :: (ZeroSumGame zsg) => zsg -> Integer -> zsg
performMovement game strength = negamax game strength

negamax :: (ZeroSumGame zsg) => zsg -> Integer -> zsg
negamax game depth =
  let negamaxScoreFor   = \aGame -> - negamaxScore aGame depth
      candidateMovs     = map (\candidateGame -> (candidateGame, negamaxScoreFor candidateGame)) (bestNextGames game)
      bestMovComparator = \(_, nma) (_, nmb)  -> compare nma nmb
   in fst $ maximumBy bestMovComparator candidateMovs

negamaxScore :: (ZeroSumGame zsg) => zsg -> Integer -> Float
negamaxScore game depth
  | depth == 0 || isGameOver game = evaluateGame game
  | otherwise  = let negamaxDepthEvaluator = \candidateGame -> - negamaxScore candidateGame (depth - 1)
                     negamaxDepthValues    = map negamaxDepthEvaluator (bestNextGames game)
                  in maximum negamaxDepthValues

bestNextGames :: (ZeroSumGame zsg) => zsg -> [zsg]
bestNextGames game = availableMovements game