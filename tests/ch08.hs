type Parser a = String -> [(a, String)]

-- ?? inp�� input�� �����ΰ�?

-- ������ ���� ó������ �ʰ�, �����м��⸦ ������.
return' :: a -> Parser a
return' v = \inp ->[(v, inp)]

-- �����°Ϳ� �������, ����.
failure :: Parser a
failure = \inp -> []

-- ���� ������ ����, �ƴϸ� ù��° ���� ���� ������ ����.
item :: Parser Char
item = (\inp -> case inp of
           []       -> []
           (x : xs) ->[(x, xs)])

-- parse������ ��������� ��Ÿ���� ���� wapper�Լ�.
parse :: Parser a -> String -> [(a, String)]
parse p inp = p inp

-- then �Լ�. p�� �����ϰ�, f�� �����ϵ��� �ϴ� �Լ�.
(>>=) :: Parser a -> (a -> Parser b) -> Parser b
p >>= f = (\inp -> case parse p inp of
              []         -> []
              [(v, out)] -> parse (f v) out)

-- or else �Լ�. p�̰ų� q�� �����ϵ��� �ϴ� �Լ�.
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
