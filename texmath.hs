module Main where

import Text.TeXMath
import Text.XML.Light
import Text.TeXMath.Macros
import Text.ParserCombinators.Parsec
import System.IO

inHtml :: Element -> Element
inHtml x =
  add_attr (Attr (unqual "xmlns") "http://www.w3.org/1999/xhtml") $
  unode "html"
    [ unode "head" $
        add_attr (Attr (unqual "content") "application/xhtml+xml; charset=UTF-8") $
        add_attr (Attr (unqual "http-equiv") "Content-Type") $
        unode "meta" ()
    , unode "body" x ]

main :: IO ()
main = do
  inp <- getContents
  let (ms, rest) = parseMacroDefinitions inp
  case (texMathToMathML DisplayBlock $! applyMacros ms rest) of
        Left err         -> hPutStrLn stderr err
        Right v          -> putStr . ppTopElement . inHtml $ v