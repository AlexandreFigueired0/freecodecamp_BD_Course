#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "$($PSQL "TRUNCATE games,teams")\n"

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #insert teams
  if [[ $YEAR == year ]]
  then continue
  fi
  WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

  if [[ -z $WINNER_TEAM_ID  ]]
  then
    WINNER_TEAM_INSERT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    if [[ $WINNER_TEAM_INSERT == "INSERT 0 1" ]]
    then 
      echo Inserted into teams, $WINNER
    fi
  fi

  OPP_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  if [[ -z $OPP_TEAM_ID  ]]
  then
    OPP_TEAM_INSERT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    if [[ $OPP_TEAM_INSERT == "INSERT 0 1" ]]
    then 
      echo Inserted into teams, $OPPONENT
    fi
  fi

  #insert games
  WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPP_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  GAME_INSERT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_TEAM_ID,$OPP_TEAM_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
  if [[ $GAME_INSERT == "INSERT 0 1" ]]
  then
    echo Inserted into games, $ROUND $YEAR: $WINNER $WINNER_GOALS - $OPPONENT_GOALS $OPPONENT
  fi
done
