function polling() {
  let i = 0;
  (function run() {
    if (i < 100) {
      changeProgress(++i);
      setTimeout(run, 11);
    }
  })();
}

polling();

function changeProgress(progress) {
  let div = document.getElementById("hcdiv");
  console.log(progress);
  div.innerHTML = `${progress}`;
  div.style.width = progress + "%";
}
