module Reanimate.Signal
  ( Signal
  , constantS
  , fromToS
  , reverseS
  , curveS
  , bellS
  , oscillateS
  -- , fromListS
  ) where

-- | Signals are time-varying variables. Signals can be composed using function
--   composition.
type Signal = Rational -> Rational

-- fromListS :: [(Double, Signal)] -> Signal
-- fromListS fns t = worker 0 fns
--   where
--     worker _ [] = 0
--     worker now [(len, fn)] = fn (min 1 ((t-now) / min (1-now) len))
--     worker now ((len, fn):rest)
--       | now+len < t = worker (now+len) rest
--       | otherwise = fn ((t-now) / len)

-- | Constant signal.
--
--   Example:
--
--   > signalA (constantS 0.5) drawProgress
--
--   <<docs/gifs/doc_constantS.gif>>
constantS :: Rational -> Signal
constantS x = const x

-- | Signal with new starting and end values.
--
--   Example:
--
--   > signalA (fromToS 0.8 0.2) drawProgress
--
--   <<docs/gifs/doc_fromToS.gif>>
fromToS :: Rational -> Rational -> Signal
fromToS from to t = from + (to-from)*t

-- | Reverse signal order.
--
--   Example:
--
--   > signalA reverseS drawProgress
--
--   <<docs/gifs/doc_reverseS.gif>>
reverseS :: Signal
reverseS t = 1-t

-- | S-curve signal. Takes a steepness parameter. 2 is a good default.
--
--   Example:
--
--   > signalA (curveS 2) drawProgress
--
--   <<docs/gifs/doc_curveS.gif>>
curveS :: Integer -> Signal
curveS steepness s =
  if s < 0.5
    then 0.5 * (2*s)^steepness
    else 1-0.5 * (2 - 2*s)^steepness

-- | Oscillate signal.
--
--   Example:
--
--   > signalA oscillateS drawProgress
--
--   <<docs/gifs/doc_oscillateS.gif>>
oscillateS :: Signal
oscillateS t =
  if t < 1/2
    then t*2
    else 2-t*2

-- | Bell-curve signal. Takes a steepness parameter. 2 is a good default.
--
--   Example:
--
--   > signalA (bellS 2) drawProgress
--
--   <<docs/gifs/doc_bellS.gif>>
bellS :: Integer -> Signal
bellS steepness = curveS steepness . oscillateS
