module Cachix.Types.BinaryCacheCreate
  ( BinaryCacheCreate(..)
  ) where

import           Data.Aeson                     ( FromJSON
                                                , ToJSON
                                                )
import           Data.Swagger
import           Data.Text                      ( Text )
import           GHC.Generics                   ( Generic )


data BinaryCacheCreate = BinaryCacheCreate
  { publicSigningKey :: Maybe Text
  , isPublic :: Bool
  , githubOrganization :: Maybe Text
  , githubTeamId :: Maybe Int
  } deriving (Show, Generic, FromJSON, ToJSON, ToSchema)
