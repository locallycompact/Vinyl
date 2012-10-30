{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE OverlappingInstances #-}
{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE GADTs #-}

module Data.Vinyl.Proofs where

class Implicit p where
  implicitly :: p

type IElem x xs = Implicit (Elem x xs)
data Elem :: k -> [k] -> * where
  Here  :: Elem x (x ': xs)
  There :: Elem x xs -> Elem x (y ': xs)

type ISubset xs ys = Implicit (Subset xs ys)
data Subset :: [k] -> [k] -> * where
  SubsetNil  :: Subset '[] xs
  SubsetCons ::
    Elem x ys ->
    Subset xs ys ->
    Subset (x ': xs) ys

instance Implicit (Elem x (x ': xs)) where
  implicitly = Here
instance Implicit (Elem x xs) => Implicit (Elem x (y ': xs)) where
  implicitly = There implicitly

instance Implicit (Subset '[] xs) where
  implicitly = SubsetNil
instance (IElem x ys, ISubset xs ys) => Implicit (Subset (x ': xs) ys) where
  implicitly = SubsetCons implicitly implicitly

