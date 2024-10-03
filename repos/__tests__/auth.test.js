// __tests__/auth.test.js
const isAuthenticated = require('../src/auth');

test('should return true when user is not null', () => {
  const user = { id: 1, name: 'John' };
  expect(isAuthenticated(user)).toBe(true);
});

test('should return false when user is null', () => {
  expect(isAuthenticated(null)).toBe(false);
});