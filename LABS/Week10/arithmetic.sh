#!/bin/bash

#Basic arithmetic using let

let a=5+4
echo $a

let "a = 5 + 4"
echo $a

let a++
echo $a

let "a = 4 * 5"
echo $a # 20

let "a = $1 + 30"

echo $a #30 + first command line argument
