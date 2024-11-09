// src/stress.js
function performHeavyOperation(count) {
    let sum = 0;
    for (let i = 0; i < count; i++) {
      sum += i;
    }
    return sum;
  }
  module.exports = performHeavyOperation;