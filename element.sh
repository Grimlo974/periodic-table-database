#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  #Test if is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    SEARCHED_ELEMENT_RESULT=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements inner join properties using(atomic_number) inner join types using (type_id) where atomic_number = $1;")
  else
    SEARCHED_ELEMENT_RESULT=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements inner join properties using(atomic_number) inner join types using (type_id) where name = '$1' or symbol = '$1';")
  fi
  
  if [[ -z $SEARCHED_ELEMENT_RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    IFS=$"|"
    echo "$SEARCHED_ELEMENT_RESULT" | while read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi