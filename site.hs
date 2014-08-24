--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend, mconcat)
import           Hakyll
{- import           Text.Pandoc.Options (readerExtensions
                                     ,strictExtensions
                                     ,Extension(Ext_tex_math_single_backslash, Ext_tex_math_dollars)
                                     ) -}
{- import           Data.Set (insert, delete) -}


--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match (fromList ["about.markdown", "contact.markdown"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "posts/*" $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Archives"            `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls

    match "index.html" $ do
        route   idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let indexCtx = mconcat [ listField "posts" postCtx (return posts)
                                   , constField "title" "Home"
                                   , defaultContext
                                   ]

            -- pandocCompilerWith defaultHakyllReaderOptions { readerExtensions = Ext_tex_math_dollars `delete` (Ext_tex_math_single_backslash `insert` strictExtensions) } defaultHakyllWriterOptions
            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler


    create ["feed.xml"] $ do
        route idRoute
        compile $ do
            let feedCtx =
                    mconcat [ postCtx
                            , constField "description" "This is the post description"
                            ]
            posts <- recentFirst =<< loadAll "posts/*"
            renderRss myFeedConfiguration feedCtx posts
--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

--------------------------------------------------------------------------------

myFeedConfiguration :: FeedConfiguration
myFeedConfiguration =
  FeedConfiguration
    { feedTitle       = "Zamboni of The Mind"
    , feedDescription = "Latest posts of the Zamboni"
    , feedAuthorName  = "Yuval Langer"
    , feedAuthorEmail = "yuval.langer@gmail.com"
    , feedRoot        = "http://yuvallanger.github.io/zamboni-of-the-mind/"
    }
