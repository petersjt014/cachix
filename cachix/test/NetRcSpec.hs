module NetRcSpec where

import Paths_cachix
import Protolude
import System.Directory (copyFile)
import System.IO.Temp   (withSystemTempFile)
import Test.Hspec

import           Cachix.Api (BinaryCache(..))
import qualified Cachix.Client.NetRc as NetRc
import           Cachix.Client.Config (Config(..))


bc1 :: BinaryCache
bc1 = BinaryCache
 { name = "name"
 , uri = "https://name.cachix.org"
 , publicSigningKeys = ["pub"]
 , isPublic = False
 , githubUsername = "foobar"
 }

bc2 :: BinaryCache
bc2 = BinaryCache
  { name = "name2"
  , uri = "https://name2.cachix.org"
  , publicSigningKeys = ["pub2"]
  , isPublic = False
  , githubUsername = "foobar2"
  }

config :: Config
config = Config
  { authToken = "token123"
  , binaryCaches = []
  }

-- TODO: poor man's golden tests, use https://github.com/stackbuilders/hspec-golden
test :: [BinaryCache] -> Text -> Expectation
test binaryCaches goldenName = withSystemTempFile "hspec-netrc" $ \filepath _ -> do
    input <- getInput
    output <- getOutput
    copyFile input filepath
    NetRc.add config binaryCaches filepath
    real <- readFile filepath
    expected <- readFile output
    real `shouldBe` expected
  where
    getInput = getDataFileName $ toS goldenName <> ".input"
    getOutput = getDataFileName $ toS goldenName <> ".output"

spec :: Spec
spec =
  describe "add" $ do
    -- TODO: not easy to test this with temp files as they are *created*
    --it "populates non-existent netrc file" $ test [bc1, bc2] "fresh"
    it "populates empty netrc file" $ test [bc1, bc2] "empty"
    it "populates netrc file with one additional entry" $ test [bc2] "add"
    it "populates netrc file with one overriden entry" $ test [bc2] "override"
