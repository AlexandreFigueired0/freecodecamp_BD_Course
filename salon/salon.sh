#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
SERVICES=$($PSQL "SELECT service_id,name FROM services")
MAIN_MENU(){

  if [[ ! -z $1 ]]
  then 
    echo -e "\n$1"
  fi

  echo "$SERVICES" | while IFS=' ' read SERVICE_ID BAR SERVICE
  do
    echo  "$SERVICE_ID) $SERVICE"
  done

  read SERVICE_ID_SELECTED
  
  SERVICE $SERVICE_ID_SELECTED
}

SERVICE(){
  if [[ -z $1 ]]
  then
    MAIN_MENU "Please enter a valid option"
    return
  fi
  SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id=$1")
  if [[ -z $SERVICE_ID ]]
  then
    MAIN_MENU "Please enter a valid option"
    return
  fi
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID")

  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  if [[ -z $CUSTOMER_ID ]]
  then
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME

    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
  fi

  echo -e "\nWhat time to make an appointment?"
  read SERVICE_TIME

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id=$CUSTOMER_ID")

  APPOINTEMENT_INSERT_RESULT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
  SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME | sed -E 's/^ *| *$//g')
  CUSTOMER_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')
  echo -e "\nI have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME_FORMATTED."
}

MAIN_MENU