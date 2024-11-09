// src/heavyComputation.js
function heavyComputation(num) {
    let result = 0;
    for (let i = 0; i < num; i++) {
      result += i;
    }
    return result;
  }
  module.exports = heavyComputation;
  