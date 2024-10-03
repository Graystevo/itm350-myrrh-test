// src/thread.js
async function performAsyncTasks(tasks) {
    const results = await Promise.all(tasks.map(task => task()));
    return results;
  }
  module.exports = performAsyncTasks;