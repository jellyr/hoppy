module Foreign.Cppop.Generator.Std.String (c_string) where

import Data.Monoid (mappend)
import Foreign.Cppop.Generator.Spec
import Language.Haskell.Syntax (
  HsName (HsIdent),
  HsQName (UnQual),
  HsType (HsTyCon),
  )

-- | @std::string@
c_string :: Class
c_string =
  addReqIncludes [includeStd "string"] $
  classModifyConversions
  (\c -> c { classHaskellConversion =
             Just ClassHaskellConversion
             { classHaskellConversionType = HsTyCon $ UnQual $ HsIdent "CppopP.String"
             , classHaskellConversionTypeImports = hsImportForPrelude
             , classHaskellConversionToCppFn =
               "CppopP.flip CppopFC.withCString string_newFromCString"
             , classHaskellConversionToCppImports = hsImportForPrelude `mappend` hsImportForForeignC
             , classHaskellConversionFromCppFn = "CppopFC.peekCString <=< string_c_str"
             , classHaskellConversionFromCppImports =
               hsImport1 "Control.Monad" "(<=<)" `mappend` hsImportForForeignC
             }
           }) $
  makeClass (ident1 "std" "string") (Just $ toExtName "StdString")
  []
  [ makeCtor (toExtName "string_newFromCString") [TPtr $ TConst TChar]
  ]
  [ makeMethod "c_str" (toExtName "string_c_str") MConst Nonpure [] $ TPtr $ TConst TChar
  , makeMethod "size" (toExtName "string_size") MConst Nonpure [] TSize
  ]
