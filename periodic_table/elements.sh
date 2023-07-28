#!/bin/bash

if [[ -z $1 ]] 
then
  echo Please provide an element as an argument.
  exit
fi

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

PRINT_ELEMENT_INFO(){
  echo "$1" | while IFS='|' read TYPE_ID ATOMIC_NUMBER  SYMBOL NAME MASS  MELTING_POINT  BOILING_POINT TYPE
  do
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
}

CHECK_ELEMENT_EXISTS(){
  if [[ -z $1 ]]
  then
    echo -e "I could not find that element in the database."
    exit
  fi
}


if [[ $1 =~ [0-9]+ ]]
then
  ELEMENT_INFO=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1")
  CHECK_ELEMENT_EXISTS $ELEMENT_INFO
  PRINT_ELEMENT_INFO $ELEMENT_INFO
elif (( ${#1} <= 2 ))
then
  ELEMENT_INFO=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1'")
  CHECK_ELEMENT_EXISTS $ELEMENT_INFO
  PRINT_ELEMENT_INFO $ELEMENT_INFO
else
  ELEMENT_INFO=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$1'")
  CHECK_ELEMENT_EXISTS $ELEMENT_INFO
  PRINT_ELEMENT_INFO $ELEMENT_INFO
fi

