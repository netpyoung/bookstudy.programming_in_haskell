module Ch09_GAMEOFLIFE where

import Windows (getCh, cls, goto, beep, writeAt, seqn)
import Parsing

-- 살아 있는 세포 주위에,
--  - 살아 있는 세포가, 둘 또는 셋 있을 경우 : 산다.
--  - 그렇지 않다면                      : 죽는다.
-- 빈칸 주변에,
--  - 살아 있는 세포가, 셋 있을 경우 : 새로운 세포 탄생.
--  - 그렇지 않다면                : 죽는다.

-- types
type Pos   = (Int, Int)
type Board = [Pos]

-- global variables
g_board_width  = 40

g_board_height = 40

g_glider :: Board
g_glider =  [(4,2),(2,3),(4,3),(3,4),(4,4)]

-- functions
showcells :: Board -> IO ()
showcells b = seqn [writeAt p "O" | p <- b]

isAlive :: Board -> Pos -> Bool
isAlive board pos = elem pos board

isEmpty :: Board -> Pos -> Bool
isEmpty board pos = not (isAlive board pos)

neighbs :: Pos -> [Pos]
neighbs (x, y) = map wrap pos
  where
    pos = [(x + x', y + y') | x' <- [-1..1], y' <- [-1..1], not (x' == 0 && y' == 0)]

wrap :: Pos -> Pos
wrap (x, y) = (((x - 1) `mod` g_board_width) + 1,
               ((y - 1) `mod` g_board_height) + 1)

liveneighbs :: Board -> Pos -> Int
liveneighbs board = length . filter (isAlive board) . neighbs

survivors :: Board -> [Pos]
survivors board = [pos | pos <- board, elem (liveneighbs board pos) [2, 3]]

births :: Board -> [Pos]
births board = [pos | pos <- rmdups (concat (map neighbs board)),
                isEmpty board pos,
                liveneighbs board pos == 3]

rmdups :: Eq a => [a] -> [a]
rmdups [] = []
rmdups (x:xs) = x : rmdups (filter (/= x) xs)

nextgen :: Board -> Board
nextgen board = survivors board ++ births board

life :: Board -> IO ()
life board = do cls
                showcells board
                wait 100000
                life (nextgen board)

wait :: Int -> IO ()
wait n = seqn [return () | _ <- [1..n]]
