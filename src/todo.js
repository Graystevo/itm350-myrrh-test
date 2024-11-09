// src/todo.js
function addTask(tasks, task) {
    tasks.push(task);
    return tasks;
  }
  function removeTask(tasks, task) {
    return tasks.filter(t => t !== task);
  }
  module.exports = { addTask, removeTask };
  