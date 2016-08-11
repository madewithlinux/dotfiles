module Main where
import System.IO
import System.Clipboard
import System.FilePath
-- header just so that sublime text auto detects the syntax
header         = "#!/usr/bin/env bash"
-- start with space so commands don't save in bash history
move           = " mv "
-- this is just something easy to search for
fileNamePrefix = "///"


main :: IO ()
main = do
    modifyClipboardString processLines
    return ()

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
