-- 연산자를 정의.
data Op = Add | Sub | Mul | Div

-- 연산을 적용할 수 있는지 검증.
valid :: Op -> Int -> Int -> Bool
valid Add _ _ = True
valid Sub x y = x > y
valid Mul _ _ = True
valid Div x y = x `mod` y == 0

-- 연산을 적용.
apply :: Op -> Int -> Int -> Int
apply Add x y = x + y
apply Sub x y = x - y
apply Mul x y = x * y
apply Div x y = x `div` y

-- 표현식을 정의.
data Expr = Val Int | App Op Expr Expr

-- -- 식이 가지는 값을 리스트로 반환.
values :: Expr -> [Int]
values (Val x)     = [x]
values (App _ l r) = values l ++ values r

-- 표현식을 평가하여, 반환.
eval :: Expr -> [Int]
eval (Val x)     = [x | x > 0]
eval (App o l r) = [apply o x y | x <- eval l, y <- eval r, valid o x y]

-- --
-- 주옥같은 함수들이다.
subs :: [a] -> [[a]]
subs []     = [[]]
subs (x:xs) = yss ++ map (x:) yss where yss = subs xs
-- subs [1, 2, 3] -- =>[[],[3],[2],[2,3],[1],[1,3],[1,2],[1,2,3]]

interleave :: a -> [a] -> [[a]]
interleave x [] = [[x]]
interleave x (y:ys) = (x:y:ys):map (y:) (interleave x ys)
-- interleave 1 [2, 3, 4] -- => [[1,2,3,4],[2,1,3,4],[2,3,1,4],[2,3,4,1]]

perms :: [a] -> [[a]]
perms [] = [[]]
perms (x:xs) = concat (map (interleave x) (perms xs))
-- perms [1, 2, 3] -- => [[1,2,3],[2,1,3],[2,3,1],[1,3,2],[3,1,2],[3,2,1]]

choices :: [a] -> [[a]]
choices xs = concat (map perms (subs xs))
-- choices [1,2,3] -- => [[],[3],[2],[2,3],[3,2],[1],[1,3],[3,1],[1,2],[2,1],[1,2,3],[2,1,3],[2,3,1],[1,3,2],[3,1,2],[3,2,1]]

solution :: Expr -> [Int] -> Int -> Bool
solution expr ns n = elem (values expr) (choices ns) && eval expr == [n]
-- solution (App Mul (App Add (Val 1) (Val 50)) (App Sub (Val 25) (Val 10))) [1,3,7,10,25,50] 765 -- => True

split :: [a] -> [([a], [a])]
split []     = []
split [_]    = []
split (x:xs) = ([x], xs):[(x:ls,rs) | (ls,rs) <- split xs]
-- split [1,2,3,4] -- => [([1],[2,3,4]),([1,2],[3,4]),([1,2,3],[4])]

--
-- 무차별 대입으로 풀기.
exprs :: [Int] -> [Expr]
exprs []  = []
exprs [n] = [Val n]
exprs ns  = [e | (ls,rs) <- split ns
               , l <- exprs ls
               , r <- exprs rs
               , e <- combine l r]

combine :: Expr -> Expr -> [Expr]
combine l r = [App o l r | o <- ops]

ops :: [Op]
ops = [Add, Sub, Mul, Div]

solutions :: [Int] -> Int -> [Expr]
solutions ns n = [e | ns' <- choices ns
                    , e <- exprs ns'
                    , eval e == [n]]
-- 생성하면서 풀기.
-- 대수적 성질 이용해서 풀기.
