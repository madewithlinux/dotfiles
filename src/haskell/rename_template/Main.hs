module Main where
import System.IO
import System.Clipboard
import System.Environment
import System.FilePath
import System.Path.NameManip (guess_dotdot, absolute_path)
import System.Directory (getHomeDirectory)
import Data.Maybe (fromJust)
import Data.List (isPrefixOf)
-- header just so that sublime text auto detects the syntax
header         = "#!/usr/bin/env bash"
-- start with space so commands don't save in bash history
move           = " mv "
-- this is just something easy to search for
fileNamePrefix = "///"


main :: IO ()
main = do
    argPaths <- getArgs >>= (mapM absolutize)
    case argPaths of
        [] -> modifyClipboardString processLines >> return ()
        xs -> setClipboardString $ processLines $ unlines xs

processLines :: String -> String
processLines s = header ++ "\n" ++ outputLines
    where
        inputLines  = lines s
        maxlen      = maximum $ map (length . show) inputLines
        outputLines = unlines $ map (processLine maxlen) inputLines

processLine :: Int -> FilePath -> String
processLine l s = move ++ show s ++ padding ++ fileNamePrefix ++ show (takeFileName s)
    where
        padLength = 1 + l - (length . show $ s)
        padding   = replicate padLength ' '

-- https://www.schoolofhaskell.com/user/dshevchenko/cookbook/transform-relative-path-to-an-absolute-path
absolutize :: String -> IO String
absolutize aPath 
    | "~" `isPrefixOf` aPath = do
        homePath <- getHomeDirectory
        return $ normalise $ addTrailingPathSeparator homePath 
                             ++ tail aPath
    | otherwise = do
        pathMaybeWithDots <- absolute_path aPath
        return $ fromJust $ guess_dotdot pathMaybeWithDots
