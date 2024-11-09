module.exports = {
  collectCoverage: true,
  coverageReporters: ["json", "lcov", "text", "clover"],
  coverageDirectory: "coverage",
  coverageThreshold: {
    global: {
      lines: 50
    },
    "./src/*.js": {
      lines: 80
    }
  }
};
