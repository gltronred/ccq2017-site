--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TupleSections #-}
import           Control.Monad
import           Data.Function
import           Data.List
import           Data.Monoid (mappend)
import           Data.Ord
import qualified Data.Set as S
import           Hakyll
import           Text.Pandoc.Options

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "js/*" $ do
      route idRoute
      compile copyFileCompiler

    match "favicon.ico" $ do
      route idRoute
      compile copyFileCompiler

    match "pages/*" $ do
      route $ gsubRoute "pages/" (const "") `composeRoutes` setExtension "html"
      compile $ pandocCompilerWith
        (defaultHakyllReaderOptions { readerExtensions = multimarkdownExtensions })
        defaultHakyllWriterOptions
          >>= loadAndApplyTemplate "templates/default.html" pageCtx
          >>= relativizeUrls

    match "index.html" $ do
      route idRoute
      compile $ getResourceBody
        >>= loadAndApplyTemplate "templates/default.html" pageCtx
        >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler


--------------------------------------------------------------------------------

menu :: [(String, String)]
menu = [ ("Purpose and Scope", "purpose-and-scope")
       , ("Call for Papers", "call-for-papers")
       , ("Important Dates", "important-dates")
       , ("Invited Lectures", "invited-lectures")
       , ("Program Committee", "program-committee")
       , ("Accepted papers", "accepted-papers")
       , ("Venue", "venue")
       ]

menuCtx :: Context (String, String)
menuCtx =
  field "url"  (\(Item _ (name, url)) -> return url)  `mappend`
  field "name" (\(Item _ (name, url)) -> return name) `mappend`
  mempty

pageCtx :: Context String
pageCtx =
    listField "menu" menuCtx (mapM makeItem menu) `mappend`
    constField "workshop" "Computation and cryptography with qu-bits" `mappend`
    constField "shortworkshop" "CCQ'17" `mappend`
    constField "email" "csr2017-workshop@googlegroups.com" `mappend`
    defaultContext

