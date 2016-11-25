module Rerebase.Generator.Templates
where

import Rebase.Prelude
import NeatInterpolation
import Rerebase.Generator.Model
import qualified Rebase.Data.Text as A


forwardingModule :: ModuleName -> Text
forwardingModule (ModuleName name) =
  [text|
    module $name
    (
      module Rebase.$name
    )
    where

    import Rebase.$name
  |]

cabal :: List ModuleName -> Text
cabal moduleNames =
  [text|
    name:
      rerebase
    version:
      1
    synopsis:
      Reexports from "base" with a bunch of other standard libraries
    description:
      This package can be used as a drop-in replacement for \"base\",
      with all the modules preserving the original APIs and
      being located in the original namespaces.
    homepage:
      https://github.com/nikita-volkov/rerebase 
    bug-reports:
      https://github.com/nikita-volkov/rerebase/issues 
    author:
      Nikita Volkov <nikita.y.volkov@mail.ru>
    maintainer:
      Nikita Volkov <nikita.y.volkov@mail.ru>
    copyright:
      (c) 2016, Nikita Volkov
    license:
      MIT
    license-file:
      LICENSE
    build-type:
      Simple
    cabal-version:
      >=1.10

    source-repository head
      type:
        git
      location:
        git://github.com/nikita-volkov/rerebase.git

    library
      hs-source-dirs:
        library
      default-language:
        Haskell2010
      exposed-modules:
        $modules
      build-depends:
        rebase == 1.0.*
  |]
  where
    modules =
      A.intercalate "\n" (map (\(ModuleName x) -> x) moduleNames)
