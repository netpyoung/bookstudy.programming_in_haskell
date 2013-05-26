module Ch09_CALC where
import Windows
import Parsing
import Data.Char (intToDigit)

-- 계산기.

-- global variabls
g_boxw = 13
g_box =  ["+---------------+",
          "|               |",
          "+---+---+---+---+",
          "| q | c | d | = |",
          "+---+---+---+---+",
          "| 1 | 2 | 3 | + |",
          "+---+---+---+---+",
          "| 4 | 5 | 6 | - |",
          "+---+---+---+---+",
          "| 7 | 8 | 9 | * |",
          "+---+---+---+---+",
          "| 0 | ( | ) | / |",
          "+---+---+---+---+"]

g_cmd_expr   = "+-*/()"
g_cmd_quit   = "qQ\ESC"
g_cmd_delete = "dD\BS\DEL"
g_cmd_eval   = "=\n\r"
g_cmd_clear  = "cC"

g_buttons = map intToDigit [0..9]
            ++ g_cmd_expr
            ++ g_cmd_quit
            ++ g_cmd_delete
            ++ g_cmd_eval
            ++ g_cmd_clear

-- parser
expr :: Parser Int
expr = do t <- term
          do symbol "+"
             e <- expr
             return (t + e)
            +++ do symbol "-"
                   e <- expr
                   return (t - e)
            +++ return t

term :: Parser Int
term = do f <- factor
          do symbol "*"
             t <- term
             return (f * t)
            +++ do symbol "/"
                   t <- term
                   return (f `div` t)
            +++ return f

factor :: Parser Int
factor = do symbol "("
            e <- expr
            symbol ")"
            return e
            +++ integer
-- funcs
showbox :: IO ()
showbox = seqn [writeAt(1, y) xs | (y, xs) <- zip [1..g_boxw] g_box]

display :: String -> IO ()
display xs = do writeAt(3, 2) (take g_boxw (repeat '\SP'))
                writeAt(3, 2) (reverse (take g_boxw (reverse xs)))

calc :: String -> IO ()
calc xs = do display xs
             c <- getCh
             print c
             if elem c g_buttons
               then process c xs
               else do beep
                       calc xs

process :: Char -> String -> IO ()
process c xs
  | elem c g_cmd_quit   = quit
  | elem c g_cmd_delete = delete xs
  | elem c g_cmd_eval   = eval xs
  | elem c g_cmd_clear  = clear
  | otherwise           = press c xs

quit :: IO ()
quit = goto (1, g_boxw + 1)

delete :: String -> IO ()
delete "" = calc ""
delete xs = calc (init xs)

eval :: String -> IO ()
eval xs = case parse expr xs of
  [(n, "")] -> calc (show n)
  _         -> do beep
                  calc xs

clear :: IO ()
clear = calc ""

press :: Char -> String -> IO ()
press c xs = calc (xs ++ [c])

run :: IO ()
run = do cls
         showbox
         clear
