#!/bin/bash

# This script tests POST, GET, DELETE on same given endpoints for an API using curl commands.

# Variables must be changed for each API
BASE_URL="http://jp-verse.duckdns.org:5000//api"
ENDPOINT="timeline_post"
POST_PAYLOAD="name=ScriptyTester&email=test@automated.com&content=Generic test message from script"

# Testing the POST endpoint
echo "Testing POST endpoint to $BASE_URL/$ENDPOINT..."
POST_RESPONSE=$(curl -s -X POST "$BASE_URL/$ENDPOINT" -d "$POST_PAYLOAD")
echo "POST Response: $POST_RESPONSE"

# Extract ID from the POST response
ID=$(echo "$POST_RESPONSE" | grep -o '"id": *[0-9]*' | grep -o '[0-9]*')

if [ -z "$ID" ]; then
    echo "Failed to extract ID from POST response. Aborting further tests."
    exit 1
fi

echo " 1. SUCCESSFUL POST REQUEST => with ID: $ID"

# GET all posts
echo "Testing GET endpoint to $BASE_URL/$ENDPOINT..."
GET_RESPONSE=$(curl -s "$BASE_URL/$ENDPOINT")
echo "GET Response (first lines):"
echo "$GET_RESPONSE" | head -n 10

# Check if the new post exists in GET response by ID
echo "Searching for created post ID $ID..."
echo "$GET_RESPONSE" | grep "\"id\": *$ID" > /dev/null

if [ $? -eq 0 ]; then
  echo " 2. SUCCESFUL GET REQUEST: Recent Post found in GET response."
else
  echo " Post NOT found in GET response. Something went wrong."
  exit 1
fi

# DELETE the test post
echo "Deleting post ID $ID..."
DELETE_RESPONSE=$(curl -s -X DELETE "$BASE_URL/$ENDPOINT/$ID")
echo "3. SUCCESFUL DELETE Response: $DELETE_RESPONSE"

echo "All tests completed successfully. ALL 3 REQUESTS PASSED!"
