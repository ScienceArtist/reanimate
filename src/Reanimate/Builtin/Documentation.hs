module Reanimate.Builtin.Documentation where

import Reanimate.Animation
import Reanimate.Svg
import Reanimate.Raster
import Reanimate.Constants
import Codec.Picture

docEnv :: Animation -> Animation
docEnv = mapA $ \svg -> mkGroup
  [ mkBackground "white"
  , withFillOpacity 0 $
    withStrokeWidth 0.1 $
    withStrokeColor "black" (mkGroup [svg]) ]

-- | <<docs/gifs/doc_drawBox.gif>>
drawBox :: Animation
drawBox = mkAnimation 2 $ \t ->
  partialSvg t $ pathify $
  mkRect (screenWidth/2) (screenHeight/2)

-- | <<docs/gifs/doc_drawCircle.gif>>
drawCircle :: Animation
drawCircle = mkAnimation 2 $ \t ->
  partialSvg t $ pathify $
  mkCircle (screenHeight/3)

drawBall :: Animation
drawBall = mkAnimation 2 $ \t ->
  scale t $ withFillOpacity 1 $ withFillColor "red" $
  mkCircle (screenHeight/3)

-- | <<docs/gifs/doc_drawProgress.gif>>
drawProgress :: Animation
drawProgress = mkAnimation 2 $ \t ->
  mkGroup
  [ mkLine (-screenWidth/2*widthP,0)
           (screenWidth/2*widthP,0)
  , translate (-screenWidth/2*widthP + screenWidth*widthP*realToFrac t) 0 $
    withFillOpacity 1 $ mkCircle 0.5 ]
  where
    widthP = 0.8

showColorMap :: (Double -> PixelRGB8) -> SVG
showColorMap f = center $ scaleToSize screenWidth screenHeight $ embedImage img
  where
    width = 256
    height = 1
    img = generateImage pixelRenderer width height
    pixelRenderer x _y = f (fromIntegral x / fromIntegral (width-1))
