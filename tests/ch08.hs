type Parser a = String -> [(a, String)]

-- ?? inp이 input의 약자인가?

-- 들어오는 것을 처리하지 않고, 문법분석기를 돌려줌.
return' :: a -> Parser a
return' v = \inp ->[(v, inp)]

-- 들어오는것에 상관없이, 실패.
failure :: Parser a
failure = \inp -> []

-- 빈줄 들어오면 실패, 아니면 첫번째 글자 값을 돌려줌 성공.
item :: Parser Char
item = (\inp -> case inp of
           []       -> []
           (x : xs) ->[(x, xs)])

-- parse과정을 명시적으로 나타내기 위한 wapper함수.
parse :: Parser a -> String -> [(a, String)]
parse p inp = p inp

-- then 함수. p를 적용하고, f를 적용하도록 하는 함수.
(>>=) :: Parser a -> (a -> Parser b) -> Parser b
p >>= f = (\inp -> case parse p inp of
              []         -> []
              [(v, out)] -> parse (f v) out)

-- or else 함수. p이거나 q를 적용하도록 하는 함수.
(+++) :: Parser a -> Parser a -> Parser a
p +++ q = \inp -> (case parse p inp of
                      [] -> parse q inp
                      [(v, out)] -> [(v, out)])
--------------------------------------------------------------------------------
sat :: (Char -> Bool) -> Parser Char
sat p = do x <- item
           if p x then return' x else failure

main = do
  print(parse (return' 1) "abc")
  print(parse (item +++ return' 'd') "abc")
  print(parse (failure +++ return' 'd') "abc")
