module Rerebase.Generator.Model
where

import Rebase.Prelude


newtype ModuleName =
  ModuleName Text

newtype ModuleContents =
  ModuleContents Text

type Module =
  (ModuleName, ModuleContents)
