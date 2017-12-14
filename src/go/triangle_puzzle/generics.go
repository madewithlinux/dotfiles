package main

//go:generate genny -in=$GOFILE -out=gen-$GOFILE gen "BoardState=TriangleBoard Move=TriangleMove"

import (
	"github.com/cheekybits/genny/generic"
)


type BoardState generic.Type
type Move generic.Type

func nop(state BoardState) *BoardState {
	return nil
}