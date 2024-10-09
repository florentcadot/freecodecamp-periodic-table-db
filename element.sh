#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 ]]; then
 # Look for element 
 if [[ $1 =~ ^[0-9]+$ ]]; then
  ELEMENT=$($PSQL "SELECT * FROM elements WHERE atomic_number=$1")
  else
   ELEMENT=$($PSQL "SELECT * FROM elements WHERE symbol ILIKE'$1' OR name ILIKE'$1'")
 fi

 if [[ -z $ELEMENT ]]; then
  echo "I could not find that element in the database."
  else
   IFS='|' read ATOMIC_NUMBER SYMBOL NAME <<< "$ELEMENT"
   PROPERTIES=$($PSQL "SELECT atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM properties LEFT JOIN types ON properties.type_id=types.type_id WHERE atomic_number=$ATOMIC_NUMBER;")
   IFS='|' read ATOMIC_MASS MELTING_TEMPERATURE BOILING_TEMPERATURE TYPE <<< "$PROPERTIES" 

   echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_TEMPERATURE celsius and a boiling point of $BOILING_TEMPERATURE celsius."
 fi

 else 
  echo "Please provide an element as an argument."
fi