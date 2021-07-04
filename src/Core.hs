module Core where

import RIO

data Pipeline = Pipeline {
                  -- |
                  steps :: NonEmpty Step} deriving (Eq, Show)

data Step = Step { name :: StepName
                 , commands :: NonEmpty Text
                 , image :: Image }
            deriving (Eq, Show)

data Build = Build { pipeline :: Pipeline
                   , state :: BuildState } deriving (Eq, Show)

newtype StepName = StepName Text deriving (Eq, Show)

newtype Image = Image Text deriving (Eq, Show)


data BuildState = BuildReady
                | BuildRunning
                | BuildFinished BuildResult
                deriving (Eq, Show)

data BuildResult = BuildSucceeded | BuildFailed deriving (Eq, Show)


progress :: Build -> IO Build
progress build = case build.state of
  BuildReady -> undefined
  BuildRunning -> undefined
  BuildFinished _ -> pure build

-- I think usually newtype should define diffierently, so this method is not needed
stepNameToText :: StepName -> Text
stepNameToText (StepName step) = step

imageToText :: Image -> Text
imageToText (Image t) = t
