module Windows where

import Control.Monad
import Data.Char
import Foreign.C

import System.Cmd (system)

-- http://oparrow.tistory.com/entry/Windows-console%EC%97%90%EC%84%9C-%EA%B3%84%EC%82%B0%EA%B8%B0-%EC%98%88%EC%A0%9C-%EC%8B%A4%ED%96%89%ED%95%98%EA%B8%B0
-- cabal install ansi-terminal
-- import Win32ANSI (setCursorPosition)
import System.Console.ANSI (setCursorPosition)

type Pos = (Int, Int)

getCh :: IO Char
getCh = liftM (chr . fromEnum) c_getch
foreign import ccall unsafe "conio.h getch" c_getch::IO CInt

cls :: IO ()
cls = do system("cls")
         return ()

goto :: Pos -> IO ()
goto (x, y) = setCursorPosition (y - 1) (x - 1)

beep :: IO ()
beep = putStr "\BEL"

-----------------------
writeAt :: Pos -> String -> IO ()
writeAt p str = do goto p
                   putStr str

seqn :: [IO a] -> IO ()
seqn [] = return ()
seqn (a:as) = do a
                 seqn as
