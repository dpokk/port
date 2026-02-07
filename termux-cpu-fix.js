// Termux fix: os.cpus() returns [] on Android,
// causing "Expected concurrency to be a number from 1 and up"
// This preload script patches it to return at least 1 CPU.

const os = require("os");
const _cpus = os.cpus;

os.cpus = function () {
  const result = _cpus.call(this);
  if (!result || result.length === 0) {
    return [
      {
        model: "Termux Virtual CPU",
        speed: 2000,
        times: { user: 0, nice: 0, sys: 0, idle: 0, irq: 0 },
      },
    ];
  }
  return result;
};
