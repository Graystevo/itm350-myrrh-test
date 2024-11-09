// src/api.js
async function fetchUserData(userId) {
    const response = await fetch(`https://api.example.com/user/${userId}`);
    return response.json();
  }
  module.exports = fetchUserData;
  