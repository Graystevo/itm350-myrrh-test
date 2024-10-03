
// __tests__/stress.test.js
const performHeavyOperation = require('../src/stress');

test('should handle heavy load of 1 million iterations', () => {
  expect(() => performHeavyOperation(1000000)).not.toThrow();
});