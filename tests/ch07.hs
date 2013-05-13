import Data.Char

type Bit = Int

bin2int :: [Bit] -> Int
bin2int bits = sum [b * w | (b, w) <- zip bits weights]
  where weights = iterate (*2) 1
-- bin2int = foldr (\x y -> x + 2 * y) 0

int2bin :: Int -> [Bit]
int2bin 0 = []
int2bin n = n `mod` 2 : int2bin (n `div` 2)

make8 :: [Bit] -> [Bit]
make8 bits = take 8 (bits ++ repeat 0)

encode :: String -> [Bit]
encode = concat . map (make8 . int2bin . ord)

chop8 :: [Bit] -> [[Bit]]
chop8 [] = []
chop8 bits = take 8 bits : chop8 (drop 8 bits)

decode :: [Bit] -> String
decode = map (chr . bin2int) . chop8

transmit :: String -> String
transmit = decode . channel . encode

channel :: [Bit] -> [Bit]
channel = id

-- main = do
--   print(decode [1,0,0,0,0,1,1,0,0,1,0,0,0,1,1,0,1,1,0,0,0,1,1,0])
--   print ((chop8 . encode) "abc")
--   print (make8 [1, 0, 1, 1])
--   print (int2bin (bin2int [1, 0, 1, 1]))
--   print (transmit "higher-order functions are easy")
--------------------------------------------------------------------------------

-- ex1
ex1 f p xs = [f x | x <- xs, p x]

ex1_1 f p xs = map f (filter p xs)

-- ex2
all2 :: (a -> Bool) -> [a] -> Bool
all2 p = and . map p

any2 :: (a -> Bool) -> [a] -> Bool
any2 p = or . map p

takeWhile2 :: (a -> Bool) -> [a] -> [a]
takeWhile2 _ [] = []
takeWhile2 p (x:xs)
  | p x = x:takeWhile2 p xs
  | otherwise = []


dropWhile2 :: (a -> Bool) -> [a] -> [a]
dropWhile2 _ [] = []
dropWhile2 p (x:xs)
  | p x = dropWhile2 p xs
  | otherwise = x:xs

-- ex3
-- ref: http://stackoverflow.com/questions/5726445/how-would-you-define-map-and-filter-using-foldr-in-haskell
map2 :: (a -> b) -> [a] -> [b]
map2 f = foldr (\x xs -> f x : xs) []

filter2 :: (a -> Bool) -> [a] -> [a]
filter2 p = foldr (\x xs -> if p x then x : xs else xs) []

-- ex4
dec2int :: [Int] -> Int
dec2int xs = sum [b * w | (b, w) <- zip (reverse xs) (iterate (* 10) 1)]

-- ex5 :skip
-- ex6 :skip
-- ex7
-- ref: http://davidtran.doublegifts.com/blog/?p=135
unfold p h t x | p x       = []
               | otherwise = h x : unfold p h t (t x)
-- p를 만족하면, []
-- h를 적용시키면서, t를 적용시킨다.

int2bin' = unfold (== 0) (`mod` 2) (`div` 2)
chop8' = unfold null (take 8) (drop 8)
map' f = unfold null (f . head) tail
iterate' f (x:xs)= unfold (\_ -> False) id f

 -- ex8 :skip
 -- ex9 :skip

main = do
  print (ex1 (* 2) even [1,2,3,4,5])
  print (ex1_1 (* 2) even [1,2,3,4,5])

  print (all2 even [2,4,6,8])
  print (any2 even [1,3,5])

  print(takeWhile2 even [2,4,6,7,9,10])
  print(dropWhile2 even [2,4,6,7,9,10])

  print(map2 (*2) [1,2,3,4,5])
  print(filter2 even [1,2,3,4,5])

  print(dec2int [2,3,4,5])
  print ((sum . map (^2) . filter even) [1,2,3,4,5])

  print (int2bin' 15)
  print(chop8' [1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0])
  print(map' (^2) [1,2,3,4,5])
  print(map' (^2) [])

  print(take 3 (iterate (^ 2) 3))
