module Rerebase.Generator
(
  ModuleName(..),
  ModuleContents(..),
  Module(..),
  forwardingModule,
  generate,
)
where

import Rebase.Prelude
import Rerebase.Generator.Model
import qualified Rerebase.Generator.Templates as A
import qualified System.Directory as B
import qualified System.FilePath as C
import qualified Rebase.Data.Text as D


generate :: List Module -> IO ()
generate modules =
  do
    B.removeDirectoryRecursive "library"
    forM_ modules (uncurry overwriteModule)
    D.writeFile "rerebase.cabal" (A.cabal (map fst modules))
    D.writeFile "README.md" A.readme

overwriteModule :: ModuleName -> ModuleContents -> IO ()
overwriteModule (ModuleName moduleNameText) (ModuleContents moduleContentsText) =
  do
    B.createDirectoryIfMissing True directoryPath
    D.writeFile filePath moduleContentsText
  where
    directoryPath =
      C.takeDirectory filePath
    filePath =
      moduleNameText &
      D.replace "." "/" &
      mappend "library/" &
      flip mappend ".hs" &
      D.unpack

forwardingModule :: ModuleName -> Module
forwardingModule =
  liftA2 (,) id forwardingModuleContents

forwardingModuleContents :: ModuleName -> ModuleContents
forwardingModuleContents name =
  ModuleContents (A.forwardingModule name)
