#!/bin/bash
# Number Guesing Game

PSQL="psql --username=freecodecamp --dbname=number_guessing_game -t --no-align -c"

ANSWER=$(($RANDOM % 1000+1))
#echo $ANSWER
N_GUESSES=0;

echo Enter your username:
read USERNAME

BEST_GAME_GUESSES=$($PSQL "SELECT best_game_guesses FROM users WHERE name='$USERNAME'")
N_GAMES_PLAYED=0

if [[ -z $BEST_GAME_GUESSES ]]
then
  echo -e "Welcome, $USERNAME! It looks like this is your first time here."
  INSERT_USER_RESULT=$($PSQL "INSERT INTO users VALUES('$USERNAME',0,0)")
else
  N_GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE name='$USERNAME'")
  echo -e "Welcome back, $USERNAME! You have played $N_GAMES_PLAYED games, and your best game took $BEST_GAME_GUESSES guesses."
fi

echo Guess the secret number between 1 and 1000:

while true
do
  N_GUESSES=$(($N_GUESSES + 1))
  read GUESS

  if [[ ! $GUESS =~ [0-9]+ ]]
  then
   echo That is not an integer, guess again:
   continue
  fi

  if [[ $ANSWER -lt $GUESS ]]
  then
    echo -e "It's lower than that, guess again:"
  elif [[ $ANSWER -gt $GUESS ]]
  then
    echo -e "It's higher than that, guess again:"
  else
    UPDATE_GAMES_PLAYED=$($PSQL "UPDATE users SET games_played=games_played+1 WHERE name='$USERNAME'")
    if [[ -z $BEST_GAME_GUESSES || $N_GUESSES -lt $BEST_GAME_GUESSES ]]
    then
      UPDATE_BEST_GAME_GUESSES=$($PSQL "UPDATE users SET best_game_guesses=$N_GUESSES")
    fi
    echo -e "You guessed it in $N_GUESSES tries. The secret number was $ANSWER. Nice job!"
    break
  fi


done