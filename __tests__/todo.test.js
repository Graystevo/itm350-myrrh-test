// __tests__/todo.test.js
const { addTask, removeTask } = require('../src/todo');

test('should add task to the list', () => {
  const tasks = ['Task 1'];
  const updatedTasks = addTask(tasks, 'Task 2');
  expect(updatedTasks).toContain('Task 2');
});

test('should remove task from the list', () => {
  const tasks = ['Task 1', 'Task 2'];
  const updatedTasks = removeTask(tasks, 'Task 1');
  expect(updatedTasks).not.toContain('Task 1');
});