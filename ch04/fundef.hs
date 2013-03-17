isDigit' :: Char -> Bool
isDigit' c = '0' <= c && c <= '9'

even' :: Integral a => a -> Bool
even' n = n `mod` 2 == 0

splitAt' :: Int -> [a] -> ([a],[a])
splitAt' n xs = (take n xs, drop n xs)

recip' :: Fractional a => a -> a
recip' n = 1 / n

abs_1 :: Int -> Int
abs_1 n = if n > 0 then n else -n

abs_2 :: Int -> Int
abs_2 n | n > 0     = n
        | otherwise = -n

signum_1 :: Int -> Int
signum_1 n = if n < 0 then -1 else
               if n == 0 then 0 else 1

signum_2 :: Int -> Int
signum_2 n | n < 0     = -1
           | n == 0    = 0
           | otherwise = 1

not' :: Bool -> Bool
not' False = True
not' True  = False

(&&&) :: Bool -> Bool -> Bool
True  &&& b = b
False &&& _ = False


