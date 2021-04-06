function timer(delay = 1000) {
  return new Promise((resolve) => setTimeout(() => resolve(), delay));
}

timer()
  .then(() => {
    console.log("delay console");
    return timer(3000)
  })
  .then(() => {
    console.log("delay twice console");
  });
