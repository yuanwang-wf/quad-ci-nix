module Main where

import RIO
import qualified RIO.NonEmpty.Partial as NonEmpty.Partial
import Core


makeStep :: Text -> Text -> [Text] -> Step
makeStep name image commands = Step { name = StepName name
                                    , image = Image image
                                    , commands = NonEmpty.Partial.fromList commands}

makePipeline :: [Step] -> Pipeline
makePipeline = Pipeline . NonEmpty.Partial.fromList


testPipeline :: Pipeline
testPipeline = makePipeline [makeStep "First step" "ubuntu" ["date"]]


main :: IO ()
main = pure ()
