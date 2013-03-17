import Test.HUnit

-- main = do
--   runTestTT tests
mapTupleM_ :: Monad m => (a -> m b) -> (a) -> m ()


main = do
  mapM_ print ("hello", 1, 2)

tests = TestList [
  test_generator
                 ]

test_generator =
  [x ^ 2 | x <- [1..5]] ~?= [1,4,9,16,25]
