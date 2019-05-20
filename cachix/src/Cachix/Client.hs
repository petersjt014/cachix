module Cachix.Client
  ( main
  ) where

import Protolude

import Cachix.Client.OptionsParser ( CachixCommand(..), getOpts )
import Cachix.Client.Commands      as Commands
import Cachix.Client.Commands.Export      as Commands.Export
import Cachix.Client.Env           ( mkEnv, cachixVersion )


main :: IO ()
main = do
  (cachixoptions, command) <- getOpts
  env <- mkEnv cachixoptions
  case command of
    AuthToken token -> Commands.authtoken env token
    Create name -> Commands.create env name
    Export export -> Commands.Export.run env export
    GenerateKeypair name -> Commands.generateKeypair env name
    Push name paths watchStore -> Commands.push env name paths watchStore
    Use name useOptions -> Commands.use env name useOptions
    Version -> putText cachixVersion
